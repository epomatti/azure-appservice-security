resource "azurerm_cdn_frontdoor_endpoint" "nginx" {
  name                     = "webapp-nginx"
  cdn_frontdoor_profile_id = var.frontdoor_id
}

resource "azurerm_cdn_frontdoor_origin_group" "nginx" {
  name                     = "nginx"
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
  name                          = "app1"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.nginx.id
  enabled                       = true

  certificate_name_check_enabled = false

  host_name          = var.webapp_default_hostname
  http_port          = 80
  https_port         = 443
  origin_host_header = var.webapp_default_hostname
  priority           = 1
  weight             = 1000
}

resource "azurerm_cdn_frontdoor_route" "appservice_nginx" {
  name                   = "appservice-nginx"
  enabled                = true
  link_to_default_domain = true

  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.nginx.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.nginx.id
  cdn_frontdoor_origin_ids      = []

  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true
  patterns_to_match      = ["/*"]
  supported_protocols    = ["Http", "Https"]
}
