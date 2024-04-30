using './appservice.bicep'

param appServicePlanDetails = [
  {
    name: 'example-appService-plan-fl-lkjh'
    sku: {
      name :'F1'
    }
    appServiceEnvironmentId: ''
    location:'East US'
    maximumElasticWorkerCount: 1
    perSiteScaling: false
    reserved: false
    tags: {
      env : 'dev'
    }
    targetWorkerCount: 0
    targetWorkerSize: 0
    workerTierName: ''
    zoneRedundant: false

  }

]
param appServiceDetails = [

  {
    kind: 'app'
    name: 'dev-appService-example-ertyu'
    serverFarmResourceName: 'example-appService-plan-fl-lkjh'
    appServiceEnvironmentResourceId: ''
    clientAffinityEnabled: true
    clientCertEnabled: false
    clientCertExclusionPaths: ''
    clientCertMode: 'Optional'
    cloningInfo: {}
    containerSize: -1
    customDomainVerificationId: ''
    dailyMemoryTimeQuota: -1
    enabled: true
    hostNameSslStates: []
    httpsOnly: true
    hyperV: false
    keyVaultAccessIdentityResourceId: ''
    location: 'East US'
    publicNetworkAccess: 'Enabled'
    redundancyMode: 'None'
    scmSiteAlsoStopped: false
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: { 
     windowsFxVersion: 'dotnet:8'
    }
    storageAccountRequired: false
    tags: {
      env : 'dev'
    }
    virtualNetworkSubnetId: ''
  }

]

