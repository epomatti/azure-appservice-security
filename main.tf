terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.96.0"
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

module "monitor" {
  source              = "./modules/monitor"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

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

module "frontdoor" {
  source                  = "./modules/frontdoor"
  frontdoor_id            = azurerm_cdn_frontdoor_profile.default.id
  webapp_default_hostname = module.webapp.default_hostname
}

module "vm_linux" {
  source              = "./modules/vm"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  subnet_id           = module.vnet.compute_subnet_id
  size                = var.vm_linux_size
  image_sku           = var.vm_linux_image_sku
}

module "private_endpoints" {
  source                      = "./modules/private-link"
  resource_group_name         = azurerm_resource_group.default.name
  location                    = azurerm_resource_group.default.location
  vnet_id                     = module.vnet.vnet_id
  appservice_id               = module.webapp.appservice_id
  private_endpoints_subnet_id = module.vnet.private_endpoints_subnet_id
}
