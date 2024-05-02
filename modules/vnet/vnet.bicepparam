using './vnet.bicep'

param location = 'East US'
param name = 'vnet-1'
param addressPrefixes = ['192.168.0.0/16']
param subnets = [
  {
    name: 'vnet-1-subnet-1'
    addressPrefix: '192.168.1.0/24'
    nsgName: 'NSG-1'
  }
  {
    name: 'vnet-1-subnet-2'
    addressPrefix: '192.168.2.0/24'
    nsgName: 'NSG-3'
  }
  {
    name: 'vnet-1-subnet-3'
    addressPrefix: '192.168.3.0/24'
    nsgName: ''
  }
]

param ddosProtectionPlanId = ''
param dnsServers = []
param flowTimeoutInMinutes =  0
param tags = {
  env : 'dev'
}
param vnetEncryption = false
param vnetEncryptionEnforcement = 'AllowUnencrypted'
