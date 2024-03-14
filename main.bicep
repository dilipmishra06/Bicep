
@description('Azure region used for the deployment of all resources.')
param location string = resourceGroup().location

module vnet1 'network-a.bicep' = {
  name: 'network-a-deployment'
  params:{
    location: location
  }
}

module vnet2 'network-b.bicep' = {
  name: 'network-b-deployment'
  params:{
    location: location
  }
}

module storageaccount 'storage.bicep' = {
  name: 'storage-account-deployment'
  params:{
    location:location
  }
}

module vm1 'vm.bicep' = {
  name: 'vm1-deployment'
  params:{
    adminPassword: 'N5b@rLTH7gbr@p4'
    adminUsername: 'kavipriyan'
    storageAccountURI: storageaccount.outputs.storageAccountURI
    subnetId: vnet1.outputs.subnetid 
    location:location
    OSVersion:'2022-datacenter-azure-edition'
    publicIPAllocationMethod:'Dynamic'
    publicIpName:'ip1'
    publicIpSku:'Basic'
    securityType:'TrustedLaunch'
    vmName: 'vm1'
    vmSize:'Standard_B1s'
    nicName: 'Network-a-nic'
  }
  dependsOn:[
    storageaccount
    vnet1
  ]
}
module vm2 'vm.bicep' = {
  name: 'vm2-deployment'
  params:{
    adminPassword: ''
    adminUsername: ''
    storageAccountURI: storageaccount.outputs.storageAccountURI
    subnetId: vnet2.outputs.subnetid 
    location:location
    OSVersion:'2022-datacenter-azure-edition'
    publicIPAllocationMethod:'Dynamic'
    publicIpName:'ip2'
    publicIpSku:'Basic'
    securityType:'TrustedLaunch'
    vmName: 'vm2'
    vmSize:'Standard_B1s'
    nicName:'Network-b-nic'
  }
  dependsOn:[
    storageaccount
    vnet2
  ]
}

module appservice 'appservice.bicep' = {
  name: 'appservice-deployment'
  params:{
    windowsFxVersion: 'NODE:20-lts'
    location: location
    sku: 'F1'
    webAppName:'appservice-${uniqueString(resourceGroup().id)}'
  }
}

module keyvault 'keyvault.bicep' = {
  name: 'keyvault-deployment'
  params:{
    keyVaultName: 'kv-${uniqueString(resourceGroup().id)}'
    enabledForDeployment: false
    enabledForDiskEncryption:false
    enabledForTemplateDeployment:false
    location:location
    skuName:'standard'
    tenantId: subscription().tenantId
  }
}

