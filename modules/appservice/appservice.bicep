param appServicePlanDetails array

param appServiceDetails array

module appServicePlan 'serverfarm/serverfarm.bicep' = [for (plan, index) in appServicePlanDetails : {
  name: 'appServicePlan-${uniqueString(deployment().name)}-${index}'
  params: {
    name: plan.name
    sku: plan.sku
    appServiceEnvironmentId: plan.appServiceEnvironmentId
    location: plan.location
    maximumElasticWorkerCount: plan.maximumElasticWorkerCount
    perSiteScaling: plan.perSiteScaling
    reserved: plan.reserved
    tags: plan.tags
    targetWorkerCount:plan.targetWorkerCount
    targetWorkerSize: plan.targetWorkerSize
    workerTierName: plan.workerTierName
    zoneRedundant: plan.zoneRedundant
  }
}]

module appService 'site/site.bicep' = [for (site, index) in appServiceDetails :  {
  name: 'appService-${uniqueString(deployment().name)}-${index}'
  dependsOn: [appServicePlan]
  params: {
    kind: site.kind
    name: site.name
    serverFarmResourceId:  resourceId('Microsoft.Web/serverfarms',site.serverFarmResourceName)
    appServiceEnvironmentResourceId: site.appServiceEnvironmentResourceId
    clientAffinityEnabled: site.clientAffinityEnabled
    clientCertEnabled: site.clientCertEnabled
    clientCertExclusionPaths: site.clientCertExclusionPaths
    clientCertMode: site.clientCertMode
    cloningInfo: site.cloningInfo
    containerSize: site.containerSize
    customDomainVerificationId: site.customDomainVerificationId
    dailyMemoryTimeQuota: site.dailyMemoryTimeQuota
    enabled: site.enabled
    hostNameSslStates: site.hostNameSslStates
    httpsOnly: site.httpsOnly
    hyperV: site.hyperV
    keyVaultAccessIdentityResourceId: site.keyVaultAccessIdentityResourceId
    location: site.location
    publicNetworkAccess: site.publicNetworkAccess
    redundancyMode: site.redundancyMode
    scmSiteAlsoStopped: site.scmSiteAlsoStopped
    vnetRouteAllEnabled: site.vnetRouteAllEnabled
    vnetImagePullEnabled: site.vnetImagePullEnabled
    vnetContentShareEnabled: site.vnetContentShareEnabled
    siteConfig: site.siteConfig
    storageAccountRequired: site.storageAccountRequired
    tags: site.tags
    virtualNetworkSubnetId: site.virtualNetworkSubnetId
  }
}]
