output "vnet_id" {
  value = azurerm_virtual_network.default.id
}

output "webapps_subnet_id" {
  value = azurerm_subnet.webapps.id
}

output "virtual_machines_subnet_id" {
  value = azurerm_subnet.virtual_machines.id
}

output "private_endpoints_subnet_id" {
  value = azurerm_subnet.private_endpoints.id
}
