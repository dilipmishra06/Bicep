
@description('Required. Name of the Network Security Group.')
param name string


@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Array of Security Rules to deploy to the Network Security Group. When not provided, an NSG including only the built-in roles will be deployed.')
param securityRules array = []


resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: name
  location: location
}


module networkSecurityGroup_securityRules '../security/security.bicep' = [for (securityRule, index) in securityRules: {
  name: '${uniqueString(deployment().name, location)}-securityRule-${index}'
  params: {
    name: securityRule.name
    networkSecurityGroupName: networkSecurityGroup.name
    protocol: securityRule.properties.protocol
    access: securityRule.properties.access
    priority: securityRule.properties.priority
    direction: securityRule.properties.direction
    description_rule: contains(securityRule.properties, 'description') ? securityRule.properties.description : ''
    sourcePortRange: contains(securityRule.properties, 'sourcePortRange') ? securityRule.properties.sourcePortRange : ''
    sourcePortRanges: contains(securityRule.properties, 'sourcePortRanges') ? securityRule.properties.sourcePortRanges : []
    destinationPortRange: contains(securityRule.properties, 'destinationPortRange') ? securityRule.properties.destinationPortRange : ''
    destinationPortRanges: contains(securityRule.properties, 'destinationPortRanges') ? securityRule.properties.destinationPortRanges : []
    sourceAddressPrefix: contains(securityRule.properties, 'sourceAddressPrefix') ? securityRule.properties.sourceAddressPrefix : ''
    destinationAddressPrefix: contains(securityRule.properties, 'destinationAddressPrefix') ? securityRule.properties.destinationAddressPrefix : ''
    sourceAddressPrefixes: contains(securityRule.properties, 'sourceAddressPrefixes') ? securityRule.properties.sourceAddressPrefixes : []
    destinationAddressPrefixes: contains(securityRule.properties, 'destinationAddressPrefixes') ? securityRule.properties.destinationAddressPrefixes : []
    sourceApplicationSecurityGroups: contains(securityRule.properties, 'sourceApplicationSecurityGroups') ? securityRule.properties.sourceApplicationSecurityGroups : []
    destinationApplicationSecurityGroups: contains(securityRule.properties, 'destinationApplicationSecurityGroups') ? securityRule.properties.destinationApplicationSecurityGroups : []

  }
}]
