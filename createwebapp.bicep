param webappName string
param location string 
param serverFarmId string
param dotnetversion string





resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: webappName
  location: location
  properties: {
    serverFarmId: serverFarmId
    siteConfig: {
      netFrameworkVersion: dotnetversion
    }
  }
}
