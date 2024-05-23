terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.104.2"
    }
  }
}

locals {
  workload = "bigfactory"

  docker_image_name   = var.webapp_deploy_from_acr ? "app:latest" : "nginx:latest"
  docker_registry_url = var.webapp_deploy_from_acr ? "https://${module.acr.name}.azurecr.io" : "https://index.docker.io"
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
  sku_name            = var.frontdoor_sku_name
}

module "plan" {
  source              = "./modules/webapps/plan"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  sku_name            = var.webapp_plan_sku_name
}

module "acr" {
  source              = "./modules/acr"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "app1" {
  source              = "./modules/webapps/app1"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  plan_id             = module.plan.plan_id
  subnet_id           = module.vnet.webapps_subnet_id
  docker_image_name   = local.docker_image_name
  docker_registry_url = local.docker_registry_url
  deploy_from_acr     = var.webapp_deploy_from_acr
  acr_username        = module.acr.admin_username
  acr_password        = module.acr.admin_password
  env_app_path        = var.app1_path
  front_door_id       = azurerm_cdn_frontdoor_profile.default.resource_guid
}

module "frontdoor" {
  source                = "./modules/frontdoor"
  frontdoor_id          = azurerm_cdn_frontdoor_profile.default.id
  app1_default_hostname = module.app1.default_hostname
  location              = var.location
  app1_id               = module.app1.appservice_id
  app1_path             = var.app1_path
}

module "vm_linux" {
  source              = "./modules/vm"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  subnet_id           = module.vnet.virtual_machines_subnet_id
  size                = var.vm_linux_size
  image_sku           = var.vm_linux_image_sku
}

# module "private_endpoints" {
#   source                      = "./modules/private-link"
#   resource_group_name         = azurerm_resource_group.default.name
#   location                    = azurerm_resource_group.default.location
#   vnet_id                     = module.vnet.vnet_id
#   appservice_id               = module.webapp.appservice_id
#   private_endpoints_subnet_id = module.vnet.private_endpoints_subnet_id
# }
