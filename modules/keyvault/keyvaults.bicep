

param keyvaultDetails array = []

module keyvault 'single_keyvault/keyvault.bicep'= [for (keyvault,index) in keyvaultDetails : {
  name: 'keyvault-deployment-${index}'
  params: {
    name: keyvault.name
    accessPolicies: keyvault.accessPolicies
    createMode: keyvault.createMode
    enablePurgeProtection: keyvault.enablePurgeProtection
    enableRbacAuthorization: keyvault.enableRbacAuthorization
    enableSoftDelete: keyvault.enableSoftDelete
    enableVaultForDeployment:  keyvault.enableVaultForDeployment
    enableVaultForDiskEncryption:  keyvault.enableVaultForDiskEncryption
    enableVaultForTemplateDeployment: keyvault.enableVaultForTemplateDeployment
    keys: keyvault.keys
    location: keyvault.location
    networkAcls:  keyvault.networkAcls
    publicNetworkAccess: keyvault.publicNetworkAccess
    secrets: keyvault.secrets
    softDeleteRetentionInDays: keyvault.softDeleteRetentionInDays
    tags: keyvault.tags
    vaultSku:  keyvault.vaultSku
  }
}]
