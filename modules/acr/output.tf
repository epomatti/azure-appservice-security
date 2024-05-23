output "name" {
  value = azurerm_container_registry.default.name
}

output "admin_username" {
  value = azurerm_container_registry.default.admin_username
}

output "admin_password" {
  value     = azurerm_container_registry.default.admin_password
  sensitive = true
}
