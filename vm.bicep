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



resource storeSecretKeyVault 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'createKeyVaultSecret'
  location: resourceGroup().location
  kind: 'AzurePowerShell'
  
  properties: {
    
    azPowerShellVersion:  '10.0' 
    arguments: '-keyVaultName ${keyVaultName} -vmArrayLength ${vmDetailsLength}'
    scriptContent: '''

       param([string] $keyVaultName, [int] $vmArrayLength)
       $passwordArray = New-Object string[] $vmArrayLength
       $indices = 0..($vmArrayLength - 1)

      foreach ($index in $indices) {
        $username = "vm-$($index + 1)-es"
        $pass1word = -join ((65..90 + 97..122 + 48..57 + 33 + 35..38 + 42 + 64 + 95) | Get-Random -Count 8 | ForEach-Object {[char]$_}) 
        $pass2word = -join ((33..34 + 35..38 + 42 + 64 + 95) | Get-Random -Count 1 | ForEach-Object {[char]$_})
        $pass3word = -join ((65..90) | Get-Random -Count 1 | ForEach-Object {[char]$_})
        $pass4word = -join ((97..122) | Get-Random -Count 1 | ForEach-Object {[char]$_})
        $pass5word = -join ((48..57) | Get-Random -Count 1 | ForEach-Object {[char]$_})
        $password = "$pass1word$pass2word$pass3word$pass4word$pass5word"
        $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
        $passwordArray[$index] = $password
      }
        $DeploymentScriptOutputs = @{}
        $DeploymentScriptOutputs['password'] = $passwordArray

    '''
    retentionInterval: 'PT1H'

  }
}

resource keyvault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = [for index in range(0, vmDetailsLength):{
  parent: keyvault
  name: 'vm-${index+1}-es'
  properties: {
    value:storeSecretKeyVault.properties.outputs.password[index]
  }
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
        adminPassword: storeSecretKeyVault.properties.outputs.password[index]
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
