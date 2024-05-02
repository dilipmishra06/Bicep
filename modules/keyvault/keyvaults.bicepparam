using './keyvaults.bicep'

param keyvaultDetails = [
  {
    name: 'vm-keyvault-example-wer'
    accessPolicies: [{
        objectId: '21efc58e-ee53-44eb-aa03-b7ca27ab1fe7'
        permissions: {
          secrets: [
            'all'
          ]
        }
        tenantId: '96a94e33-bfb0-41c9-aeec-507a5f327e5c'
    }]
    createMode: 'default'
    enablePurgeProtection: true
    enableRbacAuthorization: true
    enableSoftDelete: true
    enableVaultForDeployment:  true
    enableVaultForDiskEncryption:  true
    enableVaultForTemplateDeployment: true
    keys: []
    location: 'East US'
    networkAcls:  {}
    publicNetworkAccess: 'Enabled'
    secrets: {}
    softDeleteRetentionInDays: 90
    tags: {
      use : 'keyvault-dev'
    }
    vaultSku: 'standard'
  }
]

