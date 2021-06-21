param appName string
param location string = resourceGroup().location

var appInsightName = toLower('appi-${appName}')

resource appInsights 'microsoft.insights/components@2020-02-02-preview' = {
  name: appInsightName
  location: location
  kind: 'string'
  properties: {
      Application_Type: 'web'
  }
}
 
resource hosting 'Microsoft.Web/serverfarms@2019-08-01' = {
    name: 'hosting-${appName}'
    location: location
    sku: {
        name: 'S1'
    }
}
 
resource app 'Microsoft.Web/sites@2018-11-01' = {
    name: appName
    location: location
    identity: {
        type: 'SystemAssigned'
    }
    properties: {
        name: appName
        siteConfig: {
            appSettings: [
                {
                    name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
                    value: appInsights.properties.InstrumentationKey
                }
            ]
        }
        serverFarmId: hosting.id
    }
}
 
output appId string = app.id
output APPINSIGHTS_INSTRUMENTATIONKEY string = appInsights.properties.InstrumentationKey
