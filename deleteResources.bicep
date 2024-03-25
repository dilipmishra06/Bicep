/*

Azure Bicep doesn't provide inherent functionality to delete particular resource.

Use deploymentstacks to deploy resources as a single logical unit.

New-AzResourceGroupDeploymentStack `
>>   -Name "demo-deploy-stack" `
>>   -ResourceGroupName "exampleRG" `
>>   -TemplateFile "main.bicep" `
>>   -DenySettingsMode "none" `
>>   -TemplateParameterFile "main.bicepparam" `
>>   -DeleteResources

Comment out the resource to be deleted and reapply the above command to delete any particular resource.

*/
