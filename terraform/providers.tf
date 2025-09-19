terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.54"
    }
    ovh = {
      source  = "ovh/ovh"
      version = "~> 0.51"
    }
  }
}

provider "openstack" {
  auth_url    = var.os_auth_url
  user_name   = var.os_username
  password    = var.os_password
  tenant_name = var.os_project_name
  domain_name = var.os_project_domain_name
  region      = var.instance_region
}

provider "ovh" {
  endpoint          = var.ovh_endpoint
  application_key   = var.ovh_application_key
  application_secret= var.ovh_application_secret
  consumer_key      = var.ovh_consumer_key
}
