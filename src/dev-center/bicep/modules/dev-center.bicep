targetScope = 'resourceGroup'

param config object

var devBoxConfig = config.features.devBox

resource dc 'Microsoft.DevCenter/devcenters@2025-07-01-preview' = {
  name: config.name
  location: config.location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    projectCatalogSettings: {
      catalogItemSyncEnableStatus: (config.?settings.?enableCatalogsPerProject ?? false) ? 'Enabled' : 'Disabled'
    }
    networkSettings: {
      microsoftHostedNetworkEnableStatus: (devBoxConfig.?settings.?allowMicrosoftHostedNetworkInProjects ?? false) ? 'Enabled' : 'Disabled'
    }
    devBoxProvisioningSettings: {
      installAzureMonitorAgentEnableStatus: (devBoxConfig.?settings.?enableAzureMonitorAgentInstallation ?? false) ? 'Enabled' : 'Disabled'
    }
  }
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' = {
  name: config.name
  location: config.location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    workspaceCapping: {
      dailyQuotaGb: 1
    }
  }
}

resource devCenterDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: dc.name
  scope: dc
  properties: {
    workspaceId: workspace.id
    logs: [
      {
        categoryGroup: 'audit'
        enabled: true
      }
      {
        categoryGroup: 'allLogs'
        enabled: true
      }
    ]
  }
}

output devCenterId string = dc.id
