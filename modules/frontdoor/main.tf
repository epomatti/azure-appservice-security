resource "azurerm_cdn_frontdoor_profile" "default" {
  name                = "afd-${var.workload}"
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "nginx" {
  name                     = "webapp-nginx"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.default.id
}
