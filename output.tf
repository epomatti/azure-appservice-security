output "app1_default_hostname" {
  value = module.app1.default_hostname
}

output "frontdoor_endpoint_host_name" {
  value = module.frontdoor.endpoint_host_name
}

output "vm_public_ip" {
  value = module.vm_linux.public_ip
}

output "acr_name" {
  value = module.acr.name
}
