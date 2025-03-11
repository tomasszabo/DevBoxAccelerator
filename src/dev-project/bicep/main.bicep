targetScope = 'subscription'

import * as tools from '../../shared/tools.bicep'

param config object

var devCenterId = tools.resolveResourceId(config.devCenterId)

module devCenterDetails 'modules/resolve-dev-center-details.bicep' = {
  name: '${take(deployment().name, 36)}-dcl'
  scope: resourceGroup(split(devCenterId, '/')[2], split(devCenterId, '/')[4])
  params: {
    devCenterName: split(devCenterId, '/')[8]
  }
}

module mainInternal 'main-internal.bicep' = {
  name: '${take(deployment().name, 36)}-mi'
  params: {
    config: config
    location: devCenterDetails.outputs.devCenterLocation
  }
}

output devCenterId string = devCenterDetails.outputs.devCenterId
output devProjectId string = mainInternal.outputs.devProjectId
