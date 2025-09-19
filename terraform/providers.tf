terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "0.51.0"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.54"
    }
  }
}

provider "ovh" {
  endpoint           = var.ovh_endpoint
  application_key    = var.ovh_application_key
  application_secret = var.ovh_application_secret
  consumer_key       = var.ovh_consumer_key
}

provider "openstack" {
  auth_url             = var.os_auth_url
  username             = var.os_username
  password             = var.os_password
  domain_name          = var.os_user_domain_name
  project_name         = var.os_project_name
  project_domain_name  = var.os_project_domain_name
}
