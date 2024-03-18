/*

``````````````````````````````
Types for AppService Module

``````````````````````````````

*/

type appServiceDetails = ({

    appServicePrefix: string
    FxVersion : string
    webAppPrefix : string
    location : string

})[]

/*

``````````````````````````````
Parameters for AppService Module

``````````````````````````````

*/

param sku string = 'F1' // The SKU of App Service Plan

@allowed([
  'linux'
  'windows'
])
param OperatingSystem string

param appServicePlanLocation string

param appServices appServiceDetails

/*

``````````````````````````````
Variables for AppService Module

``````````````````````````````

*/

var appServicePlanName = toLower('AppServicePlan-${substring(uniqueString(resourceGroup().id),0,5)}')

/*

``````````````````````````````
Resources for AppService Module

``````````````````````````````

*/

resource appServiceWindowsPlan 'Microsoft.Web/serverfarms@2023-01-01' = if (OperatingSystem == 'windows') {
  name: appServicePlanName
  location: appServicePlanLocation
  sku: {
    name: sku
  }
  kind: 'windows'
  properties: OperatingSystem == 'linux' ? {
    reserved: true
  } : null
}

resource appServiceLinuxPlan 'Microsoft.Web/serverfarms@2023-01-01' = if (OperatingSystem == 'linux') {
  name: appServicePlanName
  location: appServicePlanLocation
  sku: {
    name: sku
  }
  properties:  {
    reserved: true
  }
}


resource appService 'Microsoft.Web/sites@2023-01-01' = [ for webapp in appServices : {
  name: '${webapp.webAppPrefix}-${substring(uniqueString(resourceGroup().id),0,5)}'
  location: webapp.location
  properties: {
    serverFarmId: OperatingSystem == 'windows' ? appServiceWindowsPlan.id :appServiceLinuxPlan.id
    siteConfig: OperatingSystem == 'windows' ? {
      windowsFxVersion: webapp.FxVersion }:{ 
      linuxFxVersion: OperatingSystem
    }

  }
}]
