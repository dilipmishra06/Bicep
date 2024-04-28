@description('Required. The name of the security rule.')
param name string

@description('Conditional. The name of the parent network security group to deploy the security rule into. Required if the template is used in a standalone deployment.')
param networkSecurityGroupName string


@sys.description('Optional. Whether network traffic is allowed or denied.')
@allowed([
  'Allow'
  'Deny'
])
param access string = 'Deny'

@description('Optional. A description for this rule.')
@maxLength(140)
param description_rule string = ''

@description('Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used.')
param destinationAddressPrefix string = ''

@description('Optional. The destination address prefixes. CIDR or destination IP ranges.')
param destinationAddressPrefixes array = []

@description('Optional. The application security group specified as destination.')
param destinationApplicationSecurityGroups array = []

@description('Optional. The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.')
param destinationPortRange string = ''

@description('Optional. The destination port ranges.')
param destinationPortRanges array = []

@description('Required. The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic.')
@allowed([
  'Inbound'
  'Outbound'
])
param direction string

@description('Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.')
param priority int

@description('Required. Network protocol this rule applies to.')
@allowed([
  '*'
  'Ah'
  'Esp'
  'Icmp'
  'Tcp'
  'Udp'
])
param protocol string

@description('Optional. The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from.')
param sourceAddressPrefix string = ''

@description('Optional. The CIDR or source IP ranges.')
param sourceAddressPrefixes array = []

@description('Optional. The application security group specified as source.')
param sourceApplicationSecurityGroups array = []

@description('Optional. The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.')
param sourcePortRange string = ''

@description('Optional. The source port ranges.')
param sourcePortRanges array = []


resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-04-01' existing = {
  name: networkSecurityGroupName
}

resource securityRule 'Microsoft.Network/networkSecurityGroups/securityRules@2023-04-01' = {
  name: name
  parent: networkSecurityGroup
  properties: {
    access:access
    description: description_rule
    destinationAddressPrefix: destinationAddressPrefix
    destinationAddressPrefixes: destinationAddressPrefixes
    destinationApplicationSecurityGroups: destinationApplicationSecurityGroups
    destinationPortRange: destinationPortRange
    destinationPortRanges: destinationPortRanges
    direction: direction
    priority: priority
    protocol: protocol
    sourceAddressPrefix: sourceAddressPrefix
    sourceAddressPrefixes: sourceAddressPrefixes
    sourceApplicationSecurityGroups: sourceApplicationSecurityGroups
    sourcePortRange: sourcePortRange
    sourcePortRanges: sourcePortRanges
  }
}
