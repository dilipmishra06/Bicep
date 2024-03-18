/*

``````````````````````````````
Types for Key Vault Module

``````````````````````````````

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

```````````````````````````````
Parameters for Key Vault Module

```````````````````````````````

*/

@description('Specifies whether the key vault is a standard vault or a premium vault.')
@allowed([
  'standard'
  'premium'
])
param skuName string = 'standard'

param keyvaultDetails keyvaultparams

/*

``````````````````````````````
Variables for Key Vault Module

``````````````````````````````

*/

@description('Specifies whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault.')
var enabledForDeployment = false

@description('Specifies whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys.')
var enabledForDiskEncryption  = false

@description('Specifies whether Azure Resource Manager is permitted to retrieve secrets from the key vault.')
var enabledForTemplateDeployment = false

var enableSoftDelete = true


var skuFamily = 'A'


@description('Specifies the Azure Active Directory tenant ID that should be used for authenticating requests to the key vault.')
var tenantId = subscription().tenantId


/*

``````````````````````````````
Resources for Key Vault Module

``````````````````````````````

*/

resource keyvault 'Microsoft.KeyVault/vaults@2022-07-01' = [for kv in keyvaultDetails :  {
  name: '${kv.keyVaultNamePrefix}-${substring(uniqueString(resourceGroup().id),0,5)}'
  location: kv.location
  properties: {
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    tenantId: tenantId
    enableSoftDelete: enableSoftDelete
    softDeleteRetentionInDays: kv.softDeleteRetentionInDays
    accessPolicies: [ for ap in kv.accessPolicies : {
        objectId: ap.objectId
        permissions: ap.permissions
        tenantId: tenantId
      }
    ]
    sku: {
      name: skuName
      family: skuFamily
    }
  }
}
]
