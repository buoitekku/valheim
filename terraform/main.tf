# Konfiguracja providera OVHCloud
terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "~> 0.45"
    }
  }
}

# Konfiguracja providera OVH
provider "ovh" {
  endpoint           = var.ovh_endpoint
  application_key    = var.ovh_application_key
  application_secret = var.ovh_application_secret
  consumer_key       = var.ovh_consumer_key
}

# Klucz SSH
resource "ovh_cloud_project_sshkey_v2" "valheim_key" {
  service_name = var.ovh_service_name
  name         = "valheim-server-key"
  public_key   = file(var.ssh_public_key_path)
}

# Security group dla Valheim
resource "ovh_cloud_project_securitygroup_v2" "valheim_sg" {
  service_name = var.ovh_service_name
  region       = var.instance_region
  name         = "valheim-sg"
  description  = "Security group dla serwera Valheim"
}

# Reguły dla portów Valheim (2456-2458 UDP)
resource "ovh_cloud_project_securitygroup_rule_v2" "valheim_udp" {
  count         = 3
  service_name  = var.ovh_service_name
  region        = var.instance_region
  security_group_id = ovh_cloud_project_securitygroup_v2.valheim_sg.id

  direction     = "ingress"
  ethertype     = "IPv4"
  protocol      = "udp"
  port_range_min = 2456 + count.index
  port_range_max = 2456 + count.index
  remote_ip_prefix = "0.0.0.0/0"
}

# Reguła dla SSH (port 22 TCP)
resource "ovh_cloud_project_securitygroup_rule_v2" "ssh" {
  service_name  = var.ovh_service_name
  region        = var.instance_region
  security_group_id = ovh_cloud_project_securitygroup_v2.valheim_sg.id

  direction     = "ingress"
  ethertype     = "IPv4"
  protocol      = "tcp"
  port_range_min = 22
  port_range_max = 22
  remote_ip_prefix = "0.0.0.0/0"
}

# Tworzenie instancji Valheim
resource "ovh_cloud_project_instance_v2" "valheim_server" {
  service_name = var.ovh_service_name
  name         = "valheim-server"
  flavor_name  = var.instance_flavor
  image_name   = var.instance_image
  region       = var.instance_region

  ssh_key_id       = ovh_cloud_project_sshkey_v2.valheim_key.id
  security_group_id = ovh_cloud_project_securitygroup_v2.valheim_sg.id

  user_data = base64encode(templatefile("${path.module}/../scripts/cloud-init.yml", {
    valheim_server_name = var.valheim_server_name
    valheim_world_name  = var.valheim_world_name
    valheim_password    = var.valheim_password
  }))
}

# Output z adresem IP
output "server_ip" {
  value       = ovh_cloud_project_instance_v2.valheim_server.ipv4
  description = "Publiczny adres IP serwera Valheim"
}

output "ssh_command" {
  value       = "ssh -i ${var.ssh_private_key_path} ubuntu@${ovh_cloud_project_instance_v2.valheim_server.ipv4}"
  description = "Komenda SSH do połączenia z serwerem"
}
