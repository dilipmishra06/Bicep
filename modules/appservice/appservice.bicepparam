using './appservice.bicep'

// /*

// ```````````````````````````````````````
// Parameters for Virtual Machines Module

// ````````````````````````````````````````

// */

// param virtualMachines = [
//   {
//     OSVersion: '2022-datacenter-azure-edition'
//     vmSize: 'Standard_B1s'
//     location: location
//     virtualNetworkName: 'Network-a'
//     subnetName: 'Network-a-subnet-1'
//     allocatePublicIP: false
//     osDiskStorageAccountType : 'StandardSSD_LRS'
//   }
//   {
//     OSVersion: '2022-datacenter-azure-edition'
//     vmSize: 'Standard_B1s'
//     location: location
//     virtualNetworkName: 'Network-a'
//     subnetName: 'Network-a-subnet-2'
//     allocatePublicIP: true
//     osDiskStorageAccountType: 'StandardSSD_LRS'
//   }
// ]

// param keyVaultNamePrefix = 'keyvault-1'


// /*

// ````````````````````````````````
// Parameters for key vault Module

// `````````````````````````````````

// */

// param keyvaultDetailsArray = [
//   {
//    keyVaultNamePrefix: 'keyvault-1'
//    location: location
//    softDeleteRetentionInDays: 90
//    accessPolicies : [
//      {
//       objectId: ''
//       permissions: {
//         keys: ['list','create','get']
//         secrets: ['list','set','get','delete','purge']
//         certificates: ['list']
//        }
//      }
//    ]
//  } 
//  {
//    keyVaultNamePrefix: 'keyvault-2'
//    location: location
//    softDeleteRetentionInDays:90
//    accessPolicies : [
//      {
//       objectId: ''
//       permissions: {
//         keys: ['list','create','get']
//         secrets: ['list','set','get','delete','purge']
//         certificates: ['list']
//        }
//      }
//    ]
//  }
// ]

// param keyvaultSkuName = 'standard'

// /*

// ``````````````````````````````````
// Parameters for AppService Module

// ``````````````````````````````````

// */

param sku = 'F1' 

param OperatingSystem = 'linux'

param appServicePlanLocation = 'East US'

param appServices  = [
  { 
    appServicePrefix: 'finance-app'
    FxVersion : 'NODE|20-lts'
    webAppPrefix : 'finance'
    location : 'East US'
  }
  { 
    appServicePrefix: 'dev-app'
    FxVersion : 'PYTHON|3.12'
    webAppPrefix : 'dev'
    location : 'West US'
  }
]
