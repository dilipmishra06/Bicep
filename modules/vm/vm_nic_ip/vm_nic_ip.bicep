param networkInterfaceName string
param virtualMachineName string
param location string
param tags object?
param enableIPForwarding bool = false
param enableAcceleratedNetworking bool = false
param dnsServers array = []

@description('Optional. The network security group (NSG) to attach to the network interface.')
param networkSecurityGroupResourceId string = ''

param ipConfigurations array


module networkInterface_publicIPAddresses '../../ip/ip.bicep' = [for (ipConfiguration, index) in ipConfigurations: if (contains(ipConfiguration, 'pipconfiguration')) {
  name: '${deployment().name}-publicIP-${index}'
  params: {
    name: '${virtualMachineName}${ipConfiguration.pipconfiguration.publicIpNameSuffix}'
    location: location
    publicIPAddressVersion: contains(ipConfiguration, 'publicIPAddressVersion') ? ipConfiguration.publicIPAddressVersion : 'IPv4'
    publicIPAllocationMethod: contains(ipConfiguration, 'publicIPAllocationMethod') ? ipConfiguration.publicIPAllocationMethod : 'Static'
    publicIPPrefixResourceId: contains(ipConfiguration, 'publicIPPrefixResourceId') ? ipConfiguration.publicIPPrefixResourceId : ''
    skuName: contains(ipConfiguration, 'skuName') ? ipConfiguration.skuName : 'Standard'
    skuTier: contains(ipConfiguration, 'skuTier') ? ipConfiguration.skuTier : 'Regional'
    tags: ipConfiguration.?tags ?? tags
    zones: contains(ipConfiguration, 'zones') ? ipConfiguration.zones : []
  }
}]

module networkInterface '../../network_interface/network_interface.bicep' = {
  name: '${deployment().name}-NetworkInterface'
  params: {
    name: networkInterfaceName
    ipConfigurations: [for (ipConfiguration, index) in ipConfigurations: {
      name: !empty(ipConfiguration.name) ? ipConfiguration.name : null
      primary: index == 0
      privateIPAllocationMethod: contains(ipConfiguration, 'privateIPAllocationMethod') ? (!empty(ipConfiguration.privateIPAllocationMethod) ? ipConfiguration.privateIPAllocationMethod : null) : null
      privateIPAddress: contains(ipConfiguration, 'privateIPAddress') ? (!empty(ipConfiguration.privateIPAddress) ? ipConfiguration.privateIPAddress : null) : null
      publicIPAddressResourceId: contains(ipConfiguration, 'pipconfiguration') ? resourceId('Microsoft.Network/publicIPAddresses', '${virtualMachineName}${ipConfiguration.pipconfiguration.publicIpNameSuffix}') : null
      subnetResourceId: resourceId('Microsoft.Network/virtualNetworks/subnets',ipConfiguration.virtualNetworkName,ipConfiguration.subnetName)
      loadBalancerBackendAddressPools: contains(ipConfiguration, 'loadBalancerBackendAddressPools') ? ipConfiguration.loadBalancerBackendAddressPools : null
      applicationSecurityGroups: contains(ipConfiguration, 'applicationSecurityGroups') ? ipConfiguration.applicationSecurityGroups : null
      applicationGatewayBackendAddressPools: contains(ipConfiguration, 'applicationGatewayBackendAddressPools') ? ipConfiguration.applicationGatewayBackendAddressPools : null
      gatewayLoadBalancer: contains(ipConfiguration, 'gatewayLoadBalancer') ? ipConfiguration.gatewayLoadBalancer : null
      loadBalancerInboundNatRules: contains(ipConfiguration, 'loadBalancerInboundNatRules') ? ipConfiguration.loadBalancerInboundNatRules : null
      privateIPAddressVersion: contains(ipConfiguration, 'privateIPAddressVersion') ? ipConfiguration.privateIPAddressVersion : null
      virtualNetworkTaps: contains(ipConfiguration, 'virtualNetworkTaps') ? ipConfiguration.virtualNetworkTaps : null
    }]
    location: location
    tags: tags
    dnsServers: !empty(dnsServers) ? dnsServers : []
    enableAcceleratedNetworking: enableAcceleratedNetworking
    enableIPForwarding: enableIPForwarding
    networkSecurityGroupResourceId: !empty(networkSecurityGroupResourceId) ? networkSecurityGroupResourceId : ''
  
  }
  dependsOn: [
    networkInterface_publicIPAddresses
  ]
}
