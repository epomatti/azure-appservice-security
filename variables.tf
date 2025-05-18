### General ###
variable "subscription_id" {
  type = string
}

variable "location" {
  type = string
}

### App Service ###
variable "webapp_plan_sku_name" {
  type = string
}

variable "webapp_deploy_from_acr" {
  type = bool
}

variable "app1_path" {
  type = string
}

variable "app2_path" {
  type = string
}

variable "app3_path" {
  type = string
}

### Front Door ###
variable "deploy_frontdoor" {
  type = bool
}

variable "frontdoor_sku_name" {
  type = string
}

### Virtual Machine ###
variable "vm_key_path" {
  type = string
}

variable "vm_linux_size" {
  type = string
}

variable "vm_linux_image_sku" {
  type = string
}
