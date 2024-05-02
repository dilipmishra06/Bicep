
param vmDetails array
param keyvaultName string



module vmpasswords '../passwordGenerator/passwordGenerator.bicep' = {
  name: 'vm-passwords-deployment-script'
  params: {
    count: length(vmDetails)
    location: 'East US'
  }
}


resource keyvault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyvaultName
}

module secret '../keyvault/secret/secret.bicep' =  [for index in range(0, length(vmDetails)): {
  name: 'vm-secret-deployment-${index}'
  dependsOn:[keyvault]
  params: {
    keyVaultName: keyvault.name
    name: 'vm-${vmDetails[index].name}-secret'
    value: vmpasswords.outputs.passwordsArray[index]
    attributesEnabled: true
    attributesExp: -1
    attributesNbf: -1
    contentType: ''
    tags: {
      env : 'dev'
    }
  }
}]

module vms 'single_vm/single_vm.bicep' = [ for (vm,index) in vmDetails : {
  name: 'vm-deployment-${uniqueString(deployment().name)}-${index}'
  dependsOn:[vmpasswords]
  params: {
    adminUsername: vm.adminUsername
    imageReference: vm.imageReference 
    nicConfigurations: vm.nicConfigurations
    osDisk: vm.osDisk
    osType: vm.osType
    vmSize: vm.vmSize
    additionalUnattendContent:vm.additionalUnattendContent
    adminPassword: vmpasswords.outputs.passwordsArray[index]
    allowExtensionOperations:vm.allowExtensionOperations
    availabilitySetResourceId:vm.availabilitySetResourceId
    availabilityZone:vm.availabilityZone
    bootDiagnostics:vm.bootDiagnostics
    bootDiagnosticStorageAccountName:vm.bootDiagnosticStorageAccountName
    bootDiagnosticStorageAccountUri:vm.bootDiagnosticStorageAccountUri
    certificatesToBeInstalled:vm.certificatesToBeInstalled
    computerName:vm.computerName
    customData:vm.customData
    dataDisks:vm.dataDisks
    dedicatedHostId:vm.dedicatedHostId
    disablePasswordAuthentication:vm.disablePasswordAuthentication
    enableAutomaticUpdates:vm.enableAutomaticUpdates
    enableEvictionPolicy:vm.enableEvictionPolicy
    encryptionAtHost:vm.encryptionAtHost
    licenseType:vm.licenseType
    location:vm.location
    name:vm.name
    patchAssessmentMode:vm.patchAssessmentMode
    patchMode:vm.patchMode
    plan:vm.plan
    priority:vm.priority
    provisionVMAgent:vm.provisionVMAgent
    proximityPlacementGroupResourceId:vm.proximityPlacementGroupResourceId
    publicKeys:vm.publicKeys
    secureBootEnabled:vm.secureBootEnabled
    securityType:vm.securityType
    tags:vm.tags
    timeZone:vm.timeZone
    ultraSSDEnabled:vm.ultraSSDEnabled
    vTpmEnabled: vm.vTpmEnabled
  }
}]
