@description('Name of the Service Bus namespace')
param serviceBusNamespaceName string

@description('Name of the Queue')
param serviceBusQueueName string

@description('Name of the Topic')
param serviceBusTopicName string

@description('Location for all resources.')
param location string = resourceGroup().location

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2022-01-01-preview' = {
  name: serviceBusNamespaceName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {}
}

resource serviceBusQueue 'Microsoft.ServiceBus/namespaces/queues@2022-01-01-preview' = {
  parent: serviceBusNamespace
  name: serviceBusQueueName
  properties: {
    lockDuration: 'PT5M'
    maxSizeInMegabytes: 1024
    requiresDuplicateDetection: false
    requiresSession: false
    defaultMessageTimeToLive: 'P10675199DT2H48M5.4775807S'
    deadLetteringOnMessageExpiration: false
    duplicateDetectionHistoryTimeWindow: 'PT10M'
    maxDeliveryCount: 10
    autoDeleteOnIdle: 'P10675199DT2H48M5.4775807S'
    enablePartitioning: false
    enableExpress: false
  }
}

resource serviceBusTopics 'Microsoft.ServiceBus/namespaces/topics@2024-01-01' = {
  parent: serviceBusNamespace
  name: serviceBusTopicName
  properties: {
    autoDeleteOnIdle: 'P10675199DT2H48M5.4775807S'
    defaultMessageTimeToLive: 'P14D'
    duplicateDetectionHistoryTimeWindow: 'PT10M'  //Must be between 20 seconds and 7 days
    enableBatchedOperations: true     //Enables batched send/receive
    enableExpress: false    //Only valid for Standard tier
    enablePartitioning: false
    maxMessageSizeInKilobytes: 1024     // Only valid for Premium tier
    maxSizeInMegabytes: 1024     // Valid values: 1024, 2048, 3072, ..., 81920 (Basic/Standard), 1024–81920 (Premium)
    requiresDuplicateDetection: false
    status: 'Active' // Valid: Active | Disabled | SendDisabled | ReceiveDisabled
    supportOrdering: true                         //	Maintains message order

  }
}

