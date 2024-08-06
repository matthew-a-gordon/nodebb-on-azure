param prefix string = 'azure'

var servicePlanName = 'nodebb-sp-${uniqueString(resourceGroup().id)}'
var appName = 'nodebb-web-${prefix}${uniqueString(resourceGroup().id)}'
var redisName = 'nodebb-red-${prefix}${uniqueString(resourceGroup().id)}'

resource servicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: servicePlanName
  location: resourceGroup().location
  sku: {
    name: 'B1'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    targetWorkerSizeId: 0
    reserved: true
    hostingEnvironmentProfile: null
  }
}

resource app 'Microsoft.Web/sites@2021-02-01' = {
  name: appName
  location: resourceGroup().location
  properties: {
    serverFarmId: servicePlan.id
  }
}

resource appName_appsettings 'Microsoft.Web/sites/config@2021-02-01' = {
  parent: app
  name: 'appsettings'
  properties: {
    // DOCKER_CUSTOM_IMAGE_NAME: 'julienstroheker/nodebb-on-azure'
    // TODO: Replace with your own Docker image from the Pisteyo ACR.
    // DOCKER_REGISTRY_SERVER_URL: 'pisteyo.azurecr.io'
    // DOCKER_CUSTOM_IMAGE_NAME: 'adoptionapp-api'
    DOCKER_CUSTOM_IMAGE_RUN_COMMAND: ''
    PORT: '4567'
  }
}

resource redis 'Microsoft.Cache/Redis@2016-04-01' = {
  name: redisName
  location: resourceGroup().location
  properties: {
    sku: {
      name: 'Basic'
      family: 'C'
      capacity: 0
    }
    enableNonSslPort: true
    redisConfiguration: {}
  }
}
