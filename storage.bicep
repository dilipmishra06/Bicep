param location string = resourceGroup().location


var storageAccountName = 'bootdiags${uniqueString(resourceGroup().id)}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}

output storageAccountURI string = storageAccount.properties.primaryEndpoints.blob
