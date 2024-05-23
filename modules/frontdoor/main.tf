resource "azurerm_cdn_frontdoor_endpoint" "webapps" {
  name                     = "webapps"
  cdn_frontdoor_profile_id = var.frontdoor_id
}

resource "azurerm_cdn_frontdoor_origin_group" "app1" {
  name                     = "app1"
  cdn_frontdoor_profile_id = var.frontdoor_id
  session_affinity_enabled = false

  # restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 10

  health_probe {
    interval_in_seconds = 100
    path                = "/"
    protocol            = "Https"
    request_type        = "GET" # Prefer HEAD for production
  }

  load_balancing {
    successful_samples_required        = 3
    sample_size                        = 4
    additional_latency_in_milliseconds = 50
  }
}

resource "azurerm_cdn_frontdoor_origin" "app1" {
  name                           = "app1"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.app1.id
  enabled                        = true
  certificate_name_check_enabled = true

  host_name          = var.app1_default_hostname
  http_port          = 80
  https_port         = 443
  origin_host_header = var.app1_default_hostname
  priority           = 1
  weight             = 1000

  # private_link {
  #   request_message        = "Request access for Private Link Origin CDN Frontdoor"
  #   target_type            = "web"
  #   location               = var.location
  #   private_link_target_id = var.appservice_id
  # }
}

resource "azurerm_cdn_frontdoor_route" "app1" {
  name                   = "app1"
  enabled                = true
  link_to_default_domain = true

  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.webapps.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.app1.id
  cdn_frontdoor_origin_ids      = []

  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true
  patterns_to_match      = ["/*"]
  supported_protocols    = ["Http", "Https"]

  depends_on = [azurerm_cdn_frontdoor_origin.app1]
}
