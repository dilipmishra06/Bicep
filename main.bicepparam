using './main.bicep'

/*

``````````````````````````````
Parameters for Network Module

``````````````````````````````

*/

param location = 'East US'
param virtualNetworkName = 'Network-a'
param virtualNetworkAddressPrefix = '192.168.0.0/16'
param subnets = [
  {
    name: 'Network-a-subnet-1'
    addressPrefix: '192.168.1.0/24'
    nsgName: 'Network-a-nsg-1'
  }
  {
    name: 'Network-a-subnet-2'
    addressPrefix: '192.168.2.0/24'
    nsgName: 'Network-a-nsg-2'
  }
]
param networkSecurityGroup = [
  {
    nsgName: 'Network-a-nsg-1'
    securityRules: [
      {
        name: 'Allow_RDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          priority: 300
        }
      }
    ]
  }
  {
    nsgName: 'Network-a-nsg-2'
    securityRules: [
      {
        name: 'Allow_RDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          priority: 199
        }
      }
      {
        name: 'Allow_http_80_port'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          priority: 200
        }
      }
    ]
  }
]

/*

```````````````````````````````````````
Parameters for Virtual Machines Module

````````````````````````````````````````

*/

param virtualMachines = [
  {
    adminUsername: 'adminvmkavi'
    adminPassword: 'K@v1pr1y@njj'
    OSVersion: '2022-datacenter-azure-edition'
    vmSize: 'Standard_B1s'
    location: location
    virtualNetworkName: 'Network-a'
    subnetName: 'Network-a-subnet-1'
    allocateStaticIP: false
  }
  {
    adminUsername: 'adminvmkavipriyan'
    adminPassword: 'K@v1pr1y@njj'
    OSVersion: '2022-datacenter-azure-edition'
    vmSize: 'Standard_B1s'
    location: location
    virtualNetworkName: 'Network-a'
    subnetName: 'Network-a-subnet-2'
    allocateStaticIP: true
  }
]


/*

````````````````````````````````
Parameters for key vault Module

`````````````````````````````````

*/

param keyvaultDetailsArray = [
  {
   keyVaultNamePrefix: 'keyvault-1'
   location: 'East US'
   accessPolicies : [
     {
      objectId: '21efc58e-ee53-44eb-aa03-b7ca27ab1fe7'
      permissions: {
        keys: ['list']
        secrets: ['list']
        certificates: ['list']
       }
     }
   ]
 } 
 {
   keyVaultNamePrefix: 'keyvault-2'
   location: 'East US'
   accessPolicies : [
     {
      objectId: '21efc58e-ee53-44eb-aa03-b7ca27ab1fe7'
      permissions: {
        keys: ['list']
        secrets: ['list']
        certificates: ['list']
       }
     }
   ]
 }
]

param keyvaultSkuName = 'standard'

/*

``````````````````````````````````
Parameters for AppService Module

``````````````````````````````````

*/

param WebappSku = 'F1' 

param WebappPlanOperatingSystem = 'linux'

param appServices  = [
  { 
    appServicePrefix: 'finance-app'
    FxVersion : 'NODE|20-lts'
    webAppPrefix : 'finance'
  }
  { 
    appServicePrefix: 'dev-app'
    FxVersion : 'PYTHON|3.12'
    webAppPrefix : 'dev'
  }
]
