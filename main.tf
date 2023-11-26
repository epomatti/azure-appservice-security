terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.81.0"
    }
  }
}

locals {
  workload = "bigfactory"
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.workload}"
  location = var.location
}

module "vnet" {
  source              = "./modules/vnet"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

# resource "azurerm_log_analytics_workspace" "default" {
#   name                = "log-${local.workload}"
#   location            = azurerm_resource_group.default.location
#   resource_group_name = azurerm_resource_group.default.name
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
# }

resource "azurerm_cdn_frontdoor_profile" "default" {
  name                = "afd-${local.workload}"
  resource_group_name = azurerm_resource_group.default.name
  sku_name            = "Standard_AzureFrontDoor"
}

module "webapp" {
  source              = "./modules/webapp"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  sku_name            = var.webapp_plan_sku_name
  default_subnet_id   = module.vnet.default_subnet_id
  front_door_id       = azurerm_cdn_frontdoor_profile.default.resource_guid
}
