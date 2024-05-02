using './vms.bicep'
param keyvaultName = 'vm-keyvault-example-wer'
param vmDetails = [
  {
    adminUsername: 'example-username'
    imageReference:  {
       publisher: 'MicrosoftWindowsServer'
       offer: 'WindowsServer'
       sku: '2022-datacenter-azure-edition'
       version: 'latest'
    }
    nicConfigurations: [
    { 
      nicSuffix: 'fjdlfl'
      enableAcceleratedNetworking : false
      dnsServers : []
      tags: {
        env : 'dev'
      }
      ipConfigurations:[
        {
          name: 'ip-config-1'
          virtualNetworkName: 'vnet-1'
          subnetName: 'vnet-1-subnet-1'
          privateIPAllocationMethod: 'Dynamic'
          privateIPAddressVersion: 'IPv4'
          skuName: 'Standard'
          skuTier: 'Regional'
          tags: {
            env : 'dev'
          }

        }
      ]

    }
    ]
    osDisk: {
        diskSizeGB: 200
        createOption: 'FromImage'
        deleteOption:'Delete'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
       }
    }
    osType: 'Windows'
    vmSize: 'Standard_B1s'
    additionalUnattendContent: []
    allowExtensionOperations: true
    availabilitySetResourceId: ''
    availabilityZone:0
    bootDiagnostics: false
    bootDiagnosticStorageAccountName: ''
    bootDiagnosticStorageAccountUri: ''
    certificatesToBeInstalled: []
    computerName:'example-vm'
    customData: ''
    dataDisks: [
       {
          diskSizeGB: 10
          lun: 0
          createOption: 'Empty'
          managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
          }
      }
    ]
    dedicatedHostId: ''
    disablePasswordAuthentication: false
    enableAutomaticUpdates: true
    enableEvictionPolicy: false
    encryptionAtHost: false
    licenseType: ''
    location: 'East US'
    name:'example-vm'
    patchAssessmentMode: 'ImageDefault'
    patchMode: ''
    plan: {}
    priority: 'Regular'
    provisionVMAgent: true
    proximityPlacementGroupResourceId: ''
    publicKeys: []
    secureBootEnabled: false
    securityType: ''
    tags:{
      env : 'dev'
    }
    timeZone:''
    ultraSSDEnabled: false
    vTpmEnabled: false
  }
  {
    adminUsername: 'example-username-2'
    imageReference:  {
       publisher: 'MicrosoftWindowsServer'
       offer: 'WindowsServer'
       sku: '2022-datacenter-azure-edition'
       version: 'latest'
    }
    nicConfigurations: [
    { 
      nicSuffix: 'ererqwer'
      enableAcceleratedNetworking : false
      dnsServers : []
      tags: {
        env : 'dev'
      }
      ipConfigurations:[
        {
          name: 'ip-config-2'
          virtualNetworkName: 'vnet-1'
          subnetName: 'vnet-1-subnet-2'
          privateIPAllocationMethod: 'Dynamic'
          privateIPAddressVersion: 'IPv4'
          pipconfiguration : {
            publicIpNameSuffix: 'wetrytr'
         }
          publicIPAddressVersion: 'IPv4'
          publicIPAllocationMethod: 'Static'
          skuName: 'Standard'
          skuTier: 'Regional'
          tags: {
          env : 'dev'
            }
        }
      ]

    }
    ]
    osDisk: {
        diskSizeGB: 200
        createOption: 'FromImage'
        deleteOption:'Delete'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
       }
    }
    osType: 'Windows'
    vmSize: 'Standard_B1s'
    additionalUnattendContent: []
    allowExtensionOperations: true
    availabilitySetResourceId: ''
    availabilityZone:0
    bootDiagnostics: false
    bootDiagnosticStorageAccountName: ''
    bootDiagnosticStorageAccountUri: ''
    certificatesToBeInstalled: []
    computerName:'example-vm-2'
    customData: ''
    dataDisks: [
       {
          diskSizeGB: 10
          lun: 0
          createOption: 'Empty'
          managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
          }
        }
    ]
    dedicatedHostId: ''
    disablePasswordAuthentication: false
    enableAutomaticUpdates: true
    enableEvictionPolicy: false
    encryptionAtHost: false
    licenseType: ''
    location: 'East US'
    name:'example-vm-2'
    patchAssessmentMode: 'ImageDefault'
    patchMode: ''
    plan: {}
    priority: 'Regular'
    provisionVMAgent: true
    proximityPlacementGroupResourceId: ''
    publicKeys: []
    secureBootEnabled: false
    securityType: ''
    tags:{
      env : 'dev'
    }
    timeZone:''
    ultraSSDEnabled: false
    vTpmEnabled: false
  }
]

