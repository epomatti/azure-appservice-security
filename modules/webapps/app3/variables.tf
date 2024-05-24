variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "workload" {
  type = string
}

variable "plan_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "deploy_from_acr" {
  type = bool
}

variable "docker_image_name" {
  type = string
}

variable "docker_registry_url" {
  type = string
}

variable "acr_username" {
  type = string
}

variable "acr_password" {
  type      = string
  sensitive = true
}

variable "env_app_path" {
  type = string
}
