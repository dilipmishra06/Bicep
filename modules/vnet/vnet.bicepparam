using './vnet.bicep'

param location = 'East US'
param virtualNetworkName = 'vnet-1'
param virtualNetworkAddressPrefix = '192.168.0.0/16'
param subnets = [
  {
    name: 'vnet-1-subnet-1'
    addressPrefix: '192.168.1.0/24'
    nsgName: 'NSG-1'
  }
  {
    name: 'vnet-1-subnet-2'
    addressPrefix: '192.168.2.0/24'
    nsgName: 'NSG-2'
  }
  {
    name: 'vnet-1-subnet-3'
    addressPrefix: '192.168.3.0/24'
    nsgName: ''
  }
]

