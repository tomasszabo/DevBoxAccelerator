targetScope = 'resourceGroup'

param devCenterName string
param networkConnectionId string

resource dc 'Microsoft.DevCenter/devcenters@2025-07-01-preview' existing = {
  name: devCenterName
}

resource networkConnection 'Microsoft.DevCenter/devcenters/attachednetworks@2025-07-01-preview' = {
  name: split(networkConnectionId, '/')[8]
  parent: dc
  properties: {
    networkConnectionId: networkConnectionId
  }
}
