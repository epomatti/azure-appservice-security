resource "azurerm_linux_web_app" "main" {
  name                = "app-${var.workload}-001"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = var.plan_id

  public_network_access_enabled = true
  https_only                    = true

  # Only one is supported
  virtual_network_subnet_id = var.subnet_id

  site_config {
    always_on         = true
    health_check_path = "/"

    application_stack {
      docker_image_name        = var.docker_image_name
      docker_registry_url      = var.docker_registry_url
      docker_registry_username = var.deploy_from_acr ? var.acr_username : null
      docker_registry_password = var.deploy_from_acr ? var.acr_password : null
    }

    ip_restriction {
      action = "Allow"
      headers = [
        {
          x_azure_fdid = [
            "${var.front_door_id}",
          ]
          x_fd_health_probe = []
          x_forwarded_for   = []
          x_forwarded_host  = []
        }
      ]
      name        = "FrontDoor"
      priority    = 300
      service_tag = "AzureFrontDoor.Backend"
    }
  }

  app_settings = {
    DOCKER_ENABLE_CI = true
    WEBSITES_PORT    = "80"
    APP_PATH         = var.env_app_path
  }
}
