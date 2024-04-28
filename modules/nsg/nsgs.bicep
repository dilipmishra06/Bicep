@description('NSG details like name, location and securityRules')
param nsgDetails array


module networkSecurityGroups 'single_nsg.bicep/nsg.bicep' =  [ for (nsg,index) in nsgDetails : {
  name: 'nsgs-deployment-${uniqueString(deployment().name)}-${index}'
  params: {
    name: nsg.name
    location: nsg.location
    securityRules: nsg.securityRules
  }
}]
