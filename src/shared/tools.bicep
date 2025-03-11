@export()
func resolveResourceId(resourceId string) string => 
  trim(startsWith(toLower(resourceId), '/subscriptions/') ? resourceId 
  : startsWith(toLower(resourceId), '/resourcegroups/') ? '/subscriptions/${subscription().subscriptionId}${resourceId}'
  : startsWith(toLower(resourceId), '/providers/') ? '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}${resourceId}'
  : '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/${resourceId}')
