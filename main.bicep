//SubScription and RG settings
targetScope = 'subscription'
param resourceGroup1 string = 'Arth_Practice'
param SubscriptionID1 string = 'd1d9f15f-e441-4343-a4e5-b0c262beb066'

//App Service Plan 1
param asp1_name string = 'Bicep-test-asp1'
param asp1_code string = 'F1'
param location1 string = 'eastus'

//App Service Plan 2
param asp2_name string = 'Bicep-test-asp2'
param asp2_code string = 'F1'
param location2 string = 'westindia'

//Webapp deatils
param webapp1_name string = 'akpwebapp1'
param webapp1_dotnetversion string = 'v6.0'

param webapp2_name string = 'akpwebapp2'
param webapp2_dotnetversion string = 'v6.0'

//Azure FrontDoor
param Frontdoor_name string = 'Bicep-frontdoor'
param Frontdoor_sku string = 'Standard_AzureFrontDoor'
param Frontdoor_Endpoint_name string = 'Bicep-frontdoor-endpoint'
param Frontdoor_Origin_Group_Profile_name string = 'Bicep-frontdoor-Origingroup'
param Frontdoor_Origin1_name string = 'Webapp1'
param Frontdoor_Origin2_name string = 'Webapp2'
param Frontdoor_route1_name string = 'htmlwebsite'

module createasp1 'createasp.bicep' ={
  name: 'AppServicePlan1-Create'
  scope: resourceGroup(SubscriptionID1,resourceGroup1)
  params: {
    location: location1
    name:asp1_name
    skucode:asp1_code
  }
}

var AppServicePlan1id= createasp1.outputs.aspid

module createwebapp1 'createwebapp.bicep' = {
  name : 'Webapp1-create'
  scope: resourceGroup(SubscriptionID1,resourceGroup1)
  params: {
    webappName : webapp1_name
    location: location1
    serverFarmId : AppServicePlan1id
    dotnetversion : webapp1_dotnetversion
  }
}


module createasp2 'createasp.bicep' ={
  name: 'AppServicePlan2-Create'
  scope: resourceGroup(SubscriptionID1,resourceGroup1)
  params: {
    location:location2
    name:asp2_name
    skucode:asp2_code
  }
}

var AppServicePlan2id= createasp2.outputs.aspid

module createwebapp2 'createwebapp.bicep' = {
  name : 'Webapp2-create'
  scope: resourceGroup(SubscriptionID1,resourceGroup1)
  params: {
    webappName : webapp2_name
    location: location2
    serverFarmId : AppServicePlan2id
    dotnetversion : webapp2_dotnetversion
  }
} 


module CreateFrontDoor 'CreateFrontd.bicep' = {
  name: 'Frontdoor-create'
  scope: resourceGroup(SubscriptionID1,resourceGroup1)
  params: {
    name: Frontdoor_name
    sku: Frontdoor_sku
    endpoint_name: Frontdoor_Endpoint_name
    Origin_Group_Profile:Frontdoor_Origin_Group_Profile_name
    Origin1:Frontdoor_Origin1_name
    webapp1_name: webapp1_name
    Origin2: Frontdoor_Origin2_name
    webapp2_name: webapp2_name
    Route_name: Frontdoor_route1_name
    subid:SubscriptionID1
    RG: resourceGroup1
  }
}
