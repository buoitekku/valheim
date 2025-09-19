variable "ovh_endpoint" {
  type    = string
  default = "ovh-eu"
}

variable "ovh_application_key" {
  type      = string
  sensitive = true
  default   = ""
}

variable "ovh_application_secret" {
  type      = string
  sensitive = true
  default   = ""
}

variable "ovh_consumer_key" {
  type      = string
  sensitive = true
  default   = ""
}

variable "os_auth_url" {
  type = string
}

variable "os_username" {
  type = string
}

variable "os_password" {
  type      = string
  sensitive = true
}

variable "os_user_domain_name" {
  type    = string
  default = "Default"
}

variable "os_project_name" {
  type = string
}

variable "os_project_domain_name" {
  type    = string
  default = "Default"
}

variable "instance_region" {
  type = string
}

variable "instance_flavor" {
  type = string
}

variable "instance_image" {
  type = string
}

variable "network_name" {
  type = string
}

variable "external_network_name" {
  type = string
}

variable "ssh_public_key_path" {
  type = string
}

variable "ssh_private_key_path" {
  type = string
}

variable "valheim_server_name" {
  type    = string
  default = "Valheim Server"
}

variable "valheim_world_name" {
  type    = string
  default = "DedicatedWorld"
}

variable "valheim_password" {
  type      = string
  sensitive = true
}

variable "ssh_allowed_cidr" {
  type    = string
  default = "0.0.0.0/0"
}
