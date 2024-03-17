/*

``````````````````````````````
Types for Network Module

``````````````````````````````

*/

type subnetOptions = ({

  @description('Name of the subnet')
  name: string

  @description('Address range of the subnet')
  addressPrefix: string

  @description('Name of NetworkSecurity Groups to be attached for the subnet')
  nsgName: string

})[]

type nsgOptions = ({

   @description('Name of the networkSecurityGroup')
   nsgName: string

  @description('Security rules to be applied to the networkSecurityGroup')
   securityRules: array
})[]

/*

``````````````````````````````
Parameters for Network Module

``````````````````````````````

*/
@description('Azure region of the deployment for the Network')
param location string

@description('Virtual Network name')
param virtualNetworkName string 

@description('VirtualNetwork AddressPrefix')
param virtualNetworkAddressPrefix string

@description('Object Array containing subnet details')
param subnets subnetOptions 

@description('Object Array containing networkSecurityGroup details')
param networkSecurityGroups nsgOptions

/*

``````````````````````````````
Resources for Network Module

``````````````````````````````

*/
resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-09-01' = [
  for nsg in networkSecurityGroups : {
    name: nsg.nsgName
    location: location
    properties: {
      securityRules: nsg.securityRules
    }
  }
]

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetworkAddressPrefix
      ]
    }
    subnets:[ for (subnet, index) in subnets : {
    name: subnet.name
    properties:{
      addressPrefix: subnet.addressPrefix
      networkSecurityGroup: subnet.nsgName != '' ? {
        id: resourceId('Microsoft.Network/networkSecurityGroups',subnet.nsgName) } : null
        }
    }]
  }
}

