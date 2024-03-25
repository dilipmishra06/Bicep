param count int
param location string

resource storeSecretKeyVault 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'createKeyVaultSecret'
  location: location
  kind: 'AzurePowerShell'
  
  properties: {
    
    azPowerShellVersion:  '10.0' 
    arguments: '-count ${count}'
    scriptContent: '''

       param([int] $count)
       $passwordArray = New-Object string[] $count
       $indices = 0..($count - 1)

      foreach ($index in $indices) {
        $pass1word = -join ((65..90 + 97..122 + 48..57 + 33 + 35..38 + 42 + 64 + 95) | Get-Random -Count 8 | ForEach-Object {[char]$_}) 
        $pass2word = -join ((33..34 + 35..38 + 42 + 64 + 95) | Get-Random -Count 1 | ForEach-Object {[char]$_})
        $pass3word = -join ((65..90) | Get-Random -Count 1 | ForEach-Object {[char]$_})
        $pass4word = -join ((97..122) | Get-Random -Count 1 | ForEach-Object {[char]$_})
        $pass5word = -join ((48..57) | Get-Random -Count 1 | ForEach-Object {[char]$_})
        $password = "$pass1word$pass2word$pass3word$pass4word$pass5word"
        $passwordArray[$index] = $password
      }
        $DeploymentScriptOutputs = @{}
        $DeploymentScriptOutputs['password'] = $passwordArray

    '''
    retentionInterval: 'PT1H'

  }
}

output passwordsArray array = storeSecretKeyVault.properties.outputs.password
