@description('Name of the Private Endpoint')
param privateEndpointName string

@description('Location for the Private Endpoint')
param location string = resourceGroup().location

@description('Name of the subnet to connect the Private Endpoint')
param subnetId string

@description('Resource ID of the target Azure service (e.g., Storage, SQL, Event Hub)')
param targetResourceId string

@description('Subresource type (e.g., blob, table, sqlServer, namespace, etc.)')
param subresourceName string

// @description('Name of the Private DNS Zone Group')
// param dnsZoneGroupName string = 'default'

// @description('Private DNS zone resource IDs to associate with the endpoint')
// param privateDnsZoneIds array = []

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-05-01' = {
  name: privateEndpointName
  location: location
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: '${privateEndpointName}-link'
        properties: {
          privateLinkServiceId: targetResourceId
          groupIds: [
            subresourceName
          ]
        }
      }
    ]
  }
}

// resource dnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-05-01' = if (length(privateDnsZoneIds) > 0) {
//   name: dnsZoneGroupName
//   parent: privateEndpoint
//   properties: {
//     privateDnsZoneConfigs: [for zoneId in privateDnsZoneIds: {
//       name: last(split(zoneId, '/'))
//       properties: {
//         privateDnsZoneId: zoneId
//       }
//     }]
//   }
// }
