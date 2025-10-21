targetScope = 'resourceGroup'

import * as tools from '../../../shared/tools.bicep'

param config object

var devCenterId = tools.resolveResourceId(config.devCenterId)
var devBoxConfig = config.features.devBox
var networks = config.?networks ?? []
var devBoxPools = devBoxConfig.?pools ?? []
var devBoxPoolsManagedReferenceItems = filter(devBoxPools, item => contains(item, 'networkRegions'))
var devBoxPoolsUnmanagedReferenceItems = filter(devBoxPools, item => contains(item, 'networkName'))

resource devProject 'Microsoft.DevCenter/projects@2025-07-01-preview' = {
  name: config.name
  location: resourceGroup().location
  properties: {
    #disable-next-line use-resource-id-functions
    devCenterId: devCenterId
  }
}

module network 'network.bicep' = [for index in range(0, length(networks)): {
  name: '${take(deployment().name, 36)}-n-${index}'
  scope: resourceGroup()
  params: {
    config: config
    networkIndex: index
  }
}]

resource devBoxPoolManagedReference 'Microsoft.DevCenter/projects/pools@2025-07-01-preview' = [for item in devBoxPoolsManagedReferenceItems: if (!contains(item.definition, 'sku')) {  
  name: item.name
  location: resourceGroup().location
  parent: devProject
  properties: {
    devBoxDefinitionName: item.definition.name
    devBoxDefinitionType: 'Reference'
    virtualNetworkType: 'Managed'
    networkConnectionName: 'managedNetwork'
    licenseType: 'Windows_Client'
    localAdministrator: (item.?enableLocalAdmin ?? false) ? 'Enabled' : 'Disabled'
    singleSignOnStatus: (item.?enableSingleSignOn ?? false) ? 'Enabled' : 'Disabled'
    displayName: item.displayName ?? item.name
    managedVirtualNetworkRegions: [for region in item.networkRegions: toLower(replace(region, ' ', ''))]
  }
}]

resource devBoxPoolUnmanagedReference 'Microsoft.DevCenter/projects/pools@2025-07-01-preview' = [for item in devBoxPoolsUnmanagedReferenceItems: if (!contains(item.definition, 'sku')) {
  name: item.name
  location: resourceGroup().location
  parent: devProject
  properties: {
    devBoxDefinitionName: item.definition.name
    devBoxDefinitionType: 'Reference'
    virtualNetworkType: 'Unmanaged'
    networkConnectionName: item.networkName
    licenseType: 'Windows_Client'
    localAdministrator: (item.?enableLocalAdmin ?? false) ? 'Enabled' : 'Disabled'
    singleSignOnStatus: (item.?enableSingleSignOn ?? false) ? 'Enabled' : 'Disabled'
    displayName: item.displayName ?? item.name
  }
  dependsOn: [
    network
  ]
}]

output devProjectId string = devProject.id
