resource "azurerm_linux_web_app" "main" {
  name                = "app-${var.workload}-002"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = var.plan_id

  public_network_access_enabled = true
  https_only                    = true

  site_config {
    always_on         = true
    health_check_path = "/"

    application_stack {
      docker_image_name = "index.docker.io/nginx:latest"
    }
  }

  app_settings = {
    DOCKER_ENABLE_CI = true
    WEBSITES_PORT    = "80"
  }
}
