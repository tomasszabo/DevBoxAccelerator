targetScope = 'subscription'

param config object
param windows365PrincipalId string

var devBoxEnabled = contains(config.features, 'devBox')

resource rg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: config.resourceGroup
  location: config.location
}

module devCenter './modules/dev-center.bicep' = {
  name: '${take(deployment().name, 36)}-dc'
  scope: rg
  params: {
    config: config
  }
}

module devBox './modules/devbox.bicep' = if (devBoxEnabled) {
  name: '${take(deployment().name, 36)}-db'
  scope: rg
  dependsOn: [
    devCenter
  ]
  params: {
    config: config
    windows365PrincipalId: windows365PrincipalId
  }
}

output devCenterId string = devCenter.outputs.devCenterId
