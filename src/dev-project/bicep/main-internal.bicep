targetScope = 'subscription'

param config object
param location string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: config.resourceGroup
  location: location
}

module devProject './modules/dev-project.bicep' = {
  name: '${take(deployment().name, 36)}-dp'
  scope: rg
  params: {
    config: config
  }
}

output devProjectId string = devProject.outputs.devProjectId
