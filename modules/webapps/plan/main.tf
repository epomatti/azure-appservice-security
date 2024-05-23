resource "azurerm_service_plan" "main" {
  name                = "plan-${var.workload}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku_name
}
