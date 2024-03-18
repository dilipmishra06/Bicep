/*

``````````````````````````````
Types used in Network Module

``````````````````````````````

*/

type subnetOptions = ({

  @description('Name of the subnet')
  name: string

  @description('Address range of the subnet')
  addressPrefix: string

  @description('Name of NetworkSecurity Groups to be attached for the subnet')
  nsgName: string

})[]

type nsgOptions = ({

   @description('Name of the networkSecurityGroup')
   nsgName: string

  @description('Security rules to be applied to the networkSecurityGroup')
   securityRules: array

})[]

/*

````````````````````````````````````
Types used in VirtualMachine Module

````````````````````````````````````

*/

type virtualMachineDetails = ({

    @description('Username for the Virtual Machine.')
    adminUsername: string

    @description('Password for the Virtual Machine.')
    @minLength(12)
    @secure()
    adminPassword: string

    @description('OSimage of the Virtual Machine.')
    OSVersion: string

    @description('Size of the Virtual machine.')
    vmSize: string

    @description('Location of the Virtual Machine.')
    location: string

    @description('Vnet name for the deployment of Virtual Machine.')
    virtualNetworkName: string

    @description('Subnet name for the deployment of Virtual Machine.')
    subnetName: string

    @description('Allocate Public IP for the VM')
    allocatePublicIP: bool

    @description('OsDisk Storage Account type for the VM')
    osDiskStorageAccountType : string

})[]

/*

`````````````````````````````````
Types used for Key vault Module

`````````````````````````````````

*/

type keyvaultparams = ({
  
@description('Specifies the name of the key vault.')
keyVaultNamePrefix : string

@description('Specifies the Azure location where the key vault should be created.')
location : string

@description('Specifies the accesPolicies for the key vault.')
accessPolicies: array

@description('Specifies the softDeleteRetentionInDays for the key vault.')
softDeleteRetentionInDays : int

})[]

/*

`````````````````````````````````
Types used for AppService Module

`````````````````````````````````

*/

type appServiceDetails = ({

  @description('Specifies the prefix for the webapp plan name')
  appServicePrefix: string

  @description('Specifies the Runstack for the webapp')
  FxVersion : string

  @description('Specifies the prefix for the webapp name')
  webAppPrefix : string
  
  @description('Specifies the location for the webapp')
  location : string

})[]

/*

``````````````````````````````
Parameters for Network Module

``````````````````````````````

*/

@description('Azure region used for the deployment of all resources.')
param location string

@description('Name of the VirtualNetwork to be deployed')
param virtualNetworkName string

@description('Address prefix of the VirtualNetwork to be deployed')
param virtualNetworkAddressPrefix string

@description('Object Array containing details of the subnets to be deployed.')
param subnets subnetOptions

@description('Object Array containing details of the NetworkSecurityGroups to be deployed')
param networkSecurityGroup nsgOptions 

/*

```````````````````````````````````````
Parameters for Virtual Machines Module

```````````````````````````````````````

*/

@description('Object Array containing detailes used for the deployment of Virtual Machines.')
param virtualMachines virtualMachineDetails


/*

``````````````````````````````
Parameters for keyvault Module

``````````````````````````````

*/

@description('Specifies whether the key vault is a standard vault or a premium vault.')
@allowed([
  'standard'
  'premium'
])
param keyvaultSkuName string


@description('Object Array containing keyvault details')
param keyvaultDetailsArray keyvaultparams

/*

````````````````````````````````
Parameters for Appservice Module

````````````````````````````````

*/
param WebappSku string 

@allowed([
  'linux'
  'windows'
])
param WebappPlanOperatingSystem string

param appServices appServiceDetails

param appServicePlanLocation string


/*

``````````````````````````````
Network Module

``````````````````````````````

*/

module network 'network.bicep' = {
  name: 'network-deployment'
  params:{
  location: location
  networkSecurityGroups:networkSecurityGroup
  subnets:subnets
  virtualNetworkAddressPrefix:virtualNetworkAddressPrefix
  virtualNetworkName:virtualNetworkName
  }
}

/*

``````````````````````````````
VirtualMachine Module

``````````````````````````````

*/
module virtualMachine 'vm.bicep' = {
  name: 'vm-deployment'
  params:{
    virtualMachines: virtualMachines
  }
  dependsOn:[
    network
  ]
}

/*

``````````````````````````````
Appservice Module

``````````````````````````````

*/

module appservice 'appservice.bicep' = {
  name: 'appservice-deployment'
  params:{

    appServicePlanLocation : appServicePlanLocation
    sku: WebappSku
    appServices: appServices
    OperatingSystem: WebappPlanOperatingSystem
  }
}

/*

``````````````````````````````
Keyvault Module

``````````````````````````````

*/
module keyvault 'keyvault.bicep' = {
  name: 'keyvault-deployment'
  params:{
    keyvaultDetails:keyvaultDetailsArray
    skuName: keyvaultSkuName
  }
}

