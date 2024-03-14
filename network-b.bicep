@description('Azure region of the deployment')
param location string = resourceGroup().location


var virtualNetworkName = 'Network-b'
var virtualNetworkAddressPrefix = '192.168.0.0/16'
var subnet1Name = 'Network-b-subnet-1'
var subnet1AddressPrefix = '192.168.1.0/24'
var subnet2Name = 'Network-b-subnet-2'
var subnet2AddressPrefix = '192.168.2.0/24'
var nsg1Name =  'Network-b-nsg-1'
var nsg2Name = 'Network-b-nsg-2'


resource nsg1 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: nsg1Name
  location: location
  properties: {
    securityRules:[
       {
        name: 'Allow_RDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          priority: 300
        }
      }
    ]
  }
}

resource nsg2 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: nsg2Name
  location: location
  properties: {
    securityRules:[
       {
        name: 'Allow_RDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
           priority: 199
        }
      }
      {
        name: 'Allow_http_80_port'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          priority: 200
        }
      }
    ]
  }
}


resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetworkAddressPrefix
      ]
    }
    subnets: [
      { 
        name: subnet1Name
        properties: {
          addressPrefix: subnet1AddressPrefix
          networkSecurityGroup: {
            id: nsg1.id
          }
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: subnet2AddressPrefix
          networkSecurityGroup: {
            id: nsg2.id
          }
        }
      }
    ]
  }
}
output subnetid string = virtualNetwork.properties.subnets[0].id

