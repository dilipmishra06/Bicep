/*

`````````````````````````````````````
Types used for VirtualMachine Module

`````````````````````````````````````

*/

type virtualMachineDetails = ({

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

    @description('Allocate static IP for the VM.')
    allocatePublicIP: bool

    @description('OsDisk Storage Account type for the VM')
    osDiskStorageAccountType : string 

})[]

/*

`````````````````````````````````````
Parameters for VirtualMachine Module

`````````````````````````````````````

*/

@description('Object array containing VM details')
param virtualMachines virtualMachineDetails

@description('Prefix of Keyvault to store VM passwords')
param keyVaultNamePrefix string


/*

````````````````````````````````````
Variables for VirtualMachine Module

`````````````````````````````````````

*/

var privateIPAllocationMethod = 'Dynamic'
var publicIPAllocationMethod = 'Dynamic'
var publicIpSku = 'Basic'


var osDiskCreateOption = 'FromImage'

var dataDiskSizeGB = 1024
var dataDiskCreateOption = 'Empty'
var dataDiskLogicalUnitNumber = 0

var imageReferencePublisher = 'MicrosoftWindowsServer'
var imageReferenceOffer = 'WindowsServer'
var imageReferenceVersion = 'latest'

var keyVaultName = '${keyVaultNamePrefix}-${substring(uniqueString(resourceGroup().id),0,5)}'
var vmDetailsLength = length(virtualMachines)


/*

````````````````````````````````````
Resources for Virtual Network Module

````````````````````````````````````

*/
resource publicIps 'Microsoft.Network/publicIPAddresses@2022-05-01' = [
  for (vm,index) in virtualMachines : if (vm.allocatePublicIP) {
    name: 'public-vm-${index+1}'
    location: vm.location
    sku: {
      name: publicIpSku
    }
    properties: {
      publicIPAllocationMethod: publicIPAllocationMethod
      dnsSettings: {
        domainNameLabel: toLower('vm-${index+1}-${uniqueString(resourceGroup().id)}')
      }
    }
  }
]

resource nics 'Microsoft.Network/networkInterfaces@2022-05-01' = [
  for (vm,index) in virtualMachines : {
    name: 'nic-vm-${index+1}'
    location: vm.location
    properties: {
      ipConfigurations: [
        {
          name: 'ipconfig-${index+1}'
          properties: {
            privateIPAllocationMethod: privateIPAllocationMethod
            publicIPAddress: vm.allocatePublicIP ? {
              id: resourceId('Microsoft.Network/publicIPAddresses','public-vm-${index+1}')
            } : null
            subnet: {
              id: resourceId('Microsoft.Network/virtualNetworks/subnets',vm.virtualNetworkName,vm.subnetName)
            }
          }
        }
      ]
    }
    dependsOn: vm.allocatePublicIP ? [publicIps] : []
  }
]


module vmpasswords 'passwordGenerator.bicep' = {
  name: 'vm-passwords-deployment-script'
  params: {
    count: vmDetailsLength
    location: resourceGroup().location
  }
}

resource keyvault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = [for index in range(0, vmDetailsLength):{
  parent: keyvault
  name: 'vm-${index+1}-es'
  properties: {
    value: vmpasswords.outputs.passwordsArray[index]
  }
  dependsOn:[vmpasswords]
}]



resource vm 'Microsoft.Compute/virtualMachines@2022-03-01' = [
  for (vm,index) in virtualMachines : {
    name: 'vm-${index+1}'
    location: vm.location

    properties: {
      hardwareProfile: {
        vmSize: vm.vmSize
      }
      osProfile: {
        computerName: 'vm-${index+1}'
        adminUsername: 'vm-${index+1}-es'
        adminPassword:  vmpasswords.outputs.passwordsArray[index]
      }
      storageProfile: {
        imageReference: {
          publisher: imageReferencePublisher
          offer: imageReferenceOffer
          sku: vm.OSVersion
          version: imageReferenceVersion
        }
        osDisk: {
          createOption: osDiskCreateOption
          deleteOption:'Delete'
          managedDisk: {
            storageAccountType: vm.osDiskStorageAccountType
          }
        }
        dataDisks: [
          {
            diskSizeGB: dataDiskSizeGB
            lun: dataDiskLogicalUnitNumber
            createOption: dataDiskCreateOption
            deleteOption:'Delete'
          }
        ]
      }
      networkProfile: {
        networkInterfaces: [
          {
            id: nics[index].id
          }
        ]
      }
    }
    dependsOn: vm.allocatePublicIP ? [publicIps, secret] : [secret]
  }
]
