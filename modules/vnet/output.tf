output "vnet_id" {
  value = azurerm_virtual_network.default.id
}

output "default_subnet_id" {
  value = azurerm_subnet.default.id
}

output "compute_subnet_id" {
  value = azurerm_subnet.compute.id
}
