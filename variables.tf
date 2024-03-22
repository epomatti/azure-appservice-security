variable "location" {
  type    = string
  default = "eastus2"
}

variable "webapp_plan_sku_name" {
  type    = string
  default = "B2"
}

variable "vm_linux_size" {
  type    = string
  default = "Standard_B2ps_v2"
}

variable "vm_linux_image_sku" {
  type    = string
  default = "22_04-lts-arm64"
}

variable "create_private_endpoint_flag" {
  type    = bool
  default = false
}
