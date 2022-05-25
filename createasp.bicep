param name string
param skucode string
param location string 



resource asp 'Microsoft.Web/serverfarms@2018-11-01' = {
  name: name
  location: location
  kind: ''   // "kind": "linux" 
  properties: {
    name: name
    reserved: false 
  }
  sku: {
    Name: skucode
  }
}

output aspid string = asp.id
