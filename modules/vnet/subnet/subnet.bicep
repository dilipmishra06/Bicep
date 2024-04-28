
@description('Virtual Network name')
param virtualNetworkName string 

@description('Optional. The Name of the subnet resource.')
param name string

@description('Required. The address prefix for the subnet.')
param addressPrefix string

@description('Optional. The resource ID of the network security group to assign to the subnet.')
param networkSecurityGroupId string = ''

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: virtualNetworkName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' = {
    name: name
    parent: virtualNetwork
    properties:{
      addressPrefix: addressPrefix
      networkSecurityGroup: networkSecurityGroupId != '' ? {
        id: resourceId('Microsoft.Network/networkSecurityGroups',networkSecurityGroupId) } : null
        }}
