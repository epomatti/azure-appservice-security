resource "azurerm_cdn_frontdoor_endpoint" "nginx" {
  name                     = "webapp-nginx"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.default.id
}
