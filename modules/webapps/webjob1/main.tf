# Required configuration applied from:
# https://learn.microsoft.com/en-us/azure/app-service/quickstart-webjobs
resource "azurerm_linux_web_app" "main" {
  name                = "app-${var.workload}-webjob1"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = var.plan_id

  public_network_access_enabled = true
  https_only                    = true

  site_config {
    # Required for WebJobs
    always_on = true

    application_stack {
      docker_image_name   = "nginx:latest"
      docker_registry_url = "https://index.docker.io"
    }
  }

  app_settings = {
    # Required for WebJobs
    # https://learn.microsoft.com/en-us/azure/app-service/quickstart-webjobs
    WEBSITE_SKIP_RUNNING_KUDUAGENT = false

    # DOCKER_ENABLE_CI = true
    # WEBSITES_PORT    = "80"
    # APP_PATH         = var.env_app_path
  }
}
