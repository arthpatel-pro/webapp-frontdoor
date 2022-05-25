param name string
param sku string
param endpoint_name string
param Origin_Group_Profile string
param Origin1 string
param webapp1_name string
param Origin2 string
param webapp2_name string
param Route_name string
param subid string
param RG string




resource Bicep_frontdoor 'Microsoft.Cdn/Profiles@2021-06-01' = {
  name: name
  location: 'Global'
  properties: {
        originResponseTimeoutSeconds: 60
  }
  tags: {}
  sku: {
    name: sku
  }
}

resource Bicep_frontdoor_Bicep_frontdoor_endpoint 'Microsoft.Cdn/Profiles/AfdEndpoints@2021-06-01' = {
  parent: Bicep_frontdoor
  name: endpoint_name
  location: 'Global'
  properties: {
    enabledState: 'Enabled'
  }
}

resource Bicep_frontdoor_webapps 'Microsoft.Cdn/Profiles/OriginGroups@2021-06-01' = {
  parent: Bicep_frontdoor
  name: Origin_Group_Profile
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
      additionalLatencyInMilliseconds: 50
    }
    healthProbeSettings: {
      probePath: '/'
      probeRequestType: 'HEAD'
      probeProtocol: 'Http'
      probeIntervalInSeconds: 100
    }
    trafficRestorationTimeToHealedOrNewEndpointsInMinutes: null
    sessionAffinityState: 'Disabled'
    }
}

resource Bicep_frontdoor_webapps_webapp1 'Microsoft.Cdn/Profiles/OriginGroups/Origins@2021-06-01' = {
  parent: Bicep_frontdoor_webapps
  name: Origin1
  properties: {
    hostName: '${webapp1_name}.azurewebsites.net'
    httpPort: 80
    httpsPort: 443
    originHostHeader: '${webapp1_name}.azurewebsites.net'
    priority: 1
    weight: 1000
    enforceCertificateNameCheck: true
    sharedPrivateLinkResource: null
    enabledState: 'Enabled'
    
  }
}

resource Bicep_frontdoor_webapps_webapp2 'Microsoft.Cdn/Profiles/OriginGroups/Origins@2021-06-01' = {
  parent: Bicep_frontdoor_webapps
  name: Origin2
  properties: {
    hostName: '${webapp2_name}.azurewebsites.net'
    httpPort: 80
    httpsPort: 443
    originHostHeader: '${webapp2_name}.azurewebsites.net'
    priority: 1
    weight: 1000
    enforceCertificateNameCheck: true
    sharedPrivateLinkResource: null
    enabledState: 'Enabled'
    
  }
}

resource Bicep_frontdoor_Bicep_frontdoor_endpoint_basic 'Microsoft.Cdn/Profiles/AfdEndpoints/Routes@2021-06-01' = {
  parent: Bicep_frontdoor_Bicep_frontdoor_endpoint
  name: Route_name
  properties: {
    customDomains: []
    originGroup: {
      id: '/subscriptions/${subid}/resourceGroups/${RG}/providers/Microsoft.Cdn/profiles/${name}/originGroups/${Origin_Group_Profile}'
    }
    originPath: null
    ruleSets: []
    supportedProtocols: [
      'Http'
      'Https'
    ]
    patternsToMatch: [
      '/*'
    ]
    forwardingProtocol: 'MatchRequest'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
    enabledState: 'Enabled'

    cacheConfiguration: null
  }
  dependsOn: [
    Bicep_frontdoor_webapps
    Bicep_frontdoor_webapps_webapp1
    Bicep_frontdoor_webapps_webapp2
  ]
}
