
@description('Azure region of the deployment for the Network')
param location string

@description('Virtual Network name')
param virtualNetworkName string 

@description('VirtualNetwork AddressPrefix')
param virtualNetworkAddressPrefix string

@description('Object Array containing subnet details')
param subnets array 

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetworkAddressPrefix
      ]
    }
    subnets: [for subnet in subnets: {
      name: subnet.name
      properties: {
      addressPrefix: subnet.addressPrefix
      networkSecurityGroup: subnet.nsgName != '' ? {
        id: resourceId('Microsoft.Network/networkSecurityGroups',subnet.nsgName) } : null
        }
      }]
  }
}
