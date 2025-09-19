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
  endpoint          = var.ovh_endpoint
  application_key   = var.ovh_application_key
  application_secret = var.ovh_application_secret
  consumer_key      = var.ovh_consumer_key
}

# Tworzenie VPS
resource "ovh_cloud_project_instance" "valheim_server" {
  service_name = var.ovh_service_name
  name         = "valheim-server"
  flavor_name  = var.instance_flavor
  image_name   = var.instance_image
  region       = var.instance_region
  
  # Klucz SSH
  ssh_keys_ids = [ovh_cloud_project_ssh_key.valheim_key.id]
  
  # Skrypt inicjalizacyjny
  user_data = base64encode(templatefile("${path.module}/../scripts/cloud-init.yml", {
    valheim_server_name = var.valheim_server_name
    valheim_world_name  = var.valheim_world_name
    valheim_password    = var.valheim_password
  }))
}

# Klucz SSH
resource "ovh_cloud_project_ssh_key" "valheim_key" {
  service_name = var.ovh_service_name
  name         = "valheim-server-key"
  public_key   = file(var.ssh_public_key_path)
}

# Note: Valheim ports (2456-2458 UDP) should be opened via OVH control panel or cloud-init script

# Output z adresem IP
output "server_ip" {
  value = ovh_cloud_project_instance.valheim_server.access_ipv4
  description = "Publiczny adres IP serwera Valheim"
}

output "ssh_command" {
  value = "ssh -i ${var.ssh_private_key_path} ubuntu@${ovh_cloud_project_instance.valheim_server.access_ipv4}"
  description = "Komenda SSH do połączenia z serwerem"
}