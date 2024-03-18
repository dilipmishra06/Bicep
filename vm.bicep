/*

`````````````````````````````````````
Types used for VirtualMachine Module

`````````````````````````````````````

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
        adminUsername: vm.adminUsername
        adminPassword: vm.adminPassword
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
          managedDisk: {
            storageAccountType: vm.osDiskStorageAccountType
          }
        }
        dataDisks: [
          {
            diskSizeGB: dataDiskSizeGB
            lun: dataDiskLogicalUnitNumber
            createOption: dataDiskCreateOption
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
    dependsOn: vm.allocatePublicIP ? [publicIps] : []
  }
]
