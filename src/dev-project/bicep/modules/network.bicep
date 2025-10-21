targetScope = 'resourceGroup'

import * as tools from '../../../shared/tools.bicep'

param config object
param networkIndex int

var devCenterId = tools.resolveResourceId(config.devCenterId)
var devCenterName = split(devCenterId, '/')[8]

var network = config.networks[networkIndex]
var subnets = network.?subnets ?? []
var subnetId = network.type == 'Reference' ? network.subnetId : networkResource.properties.subnets[0].id

resource networkResource 'Microsoft.Network/virtualNetworks@2024-10-01' = if (network.type == 'Definition') {
  name: network.name
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: network.addressPrefixes
    }
    subnets: [ for item in subnets : {
        name: item.name
        properties: {
          addressPrefix: item.addressPrefix
        }
    }]
  }
}

resource networkConnection 'Microsoft.DevCenter/networkConnections@2025-07-01-preview' = {
  name: network.name
  location: resourceGroup().location
  properties: {
    subnetId: subnetId
    domainJoinType: 'AzureADJoin'
    networkingResourceGroupName: '${resourceGroup().name}-${uniqueString(toLower(subnetId))}'
  }
}

module registerNetworkConnection 'register-network-connection.bicep' = {
  name: '${take(deployment().name, 36)}-rncr-${networkIndex}'
  scope: resourceGroup(split(devCenterId, '/')[2], split(devCenterId, '/')[4])
  params: {
    devCenterName: devCenterName
    networkConnectionId: networkConnection.id
  }
}
