output "default_hostname" {
  value = azurerm_linux_web_app.main.default_hostname
}

output "appservice_id" {
  value = azurerm_linux_web_app.main.id
}
