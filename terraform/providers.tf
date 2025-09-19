terraform {
  required_providers {
    ovh       = { source = "ovh/ovh", version = "~> 0.45" }
    openstack = { source = "terraform-provider-openstack/openstack", version = "~> 1.50" }
  }
  required_version = ">= 1.0.0"
}

provider "ovh" {
  endpoint           = var.ovh_endpoint
  application_key    = var.ovh_application_key
  application_secret = var.ovh_application_secret
  consumer_key       = var.ovh_consumer_key
}

provider "openstack" {
  auth_url            = var.os_auth_url
  username            = var.os_username
  password            = var.os_password
  user_domain_name    = var.os_user_domain_name
  project_name        = var.os_project_name
  project_domain_name = var.os_project_domain_name
  region              = var.instance_region
}
