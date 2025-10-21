targetScope = 'resourceGroup'

param config object
param windows365PrincipalId string

var devBoxConfig = config.features.devBox
var galleryConfig = devBoxConfig.?gallery
var galleryName = galleryConfig == null ? '' : replace(galleryConfig.name, '-', '_')
var devBoxDefinitions = devBoxConfig.?definitions ?? []

resource devCenter 'Microsoft.DevCenter/devcenters@2025-07-01-preview' existing = {
  name: config.name
}

resource gallery 'Microsoft.Compute/galleries@2024-03-03' = if(!empty(galleryName)) {
  name: galleryName
  location: config.location
}

resource roleDefinitionContributor 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' existing = if(!empty(galleryName)) {
  name: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  scope: subscription()
}

resource roleAssignmentContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = if(!empty(galleryName)) {
  name: guid(gallery.id,devCenter.id,roleDefinitionContributor.id)
  scope: gallery
  properties: {
    principalId: devCenter.identity.principalId
    roleDefinitionId: roleDefinitionContributor.id
  }
}

resource roleDefinitionReader 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' existing = if(!empty(galleryName)) {
  name: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
  scope: subscription()
}

resource roleAssignmentReader 'Microsoft.Authorization/roleAssignments@2022-04-01' = if(!empty(galleryName)) {
  name: guid(gallery.id,windows365PrincipalId,roleDefinitionReader.id)
  scope: gallery
  properties: {
    principalId: windows365PrincipalId
    roleDefinitionId: roleDefinitionReader.id
  }
}

resource attachGallery 'Microsoft.DevCenter/devcenters/galleries@2025-07-01-preview' = if(!empty(galleryName)) {
  name: gallery.name
  parent: devCenter
  dependsOn: [
    roleAssignmentContributor
    roleAssignmentReader
  ]
  properties: {
    #disable-next-line use-resource-id-functions
    galleryResourceId: gallery.id
  }
}

resource devBoxDefinition 'Microsoft.DevCenter/devcenters/devboxdefinitions@2025-07-01-preview' = [for item in devBoxDefinitions: {
  name: item.name
  location: config.location
  parent: devCenter
  properties: {
    imageReference: {
      id: resourceId('Microsoft.DevCenter/devcenters/galleries/images', devCenter.name, 'default', item.image)
    }
    sku: {
      name: item.sku
    }
    osStorageType: item.storage
    hibernateSupport: 'Enabled'
  }
}]
