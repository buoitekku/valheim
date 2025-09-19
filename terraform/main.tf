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
  ssh_key_name = ovh_cloud_project_sshkey.valheim_key.name
  
  # Skrypt inicjalizacyjny
  user_data = base64encode(templatefile("${path.module}/../scripts/cloud-init.yml", {
    valheim_server_name = var.valheim_server_name
    valheim_world_name  = var.valheim_world_name
    valheim_password    = var.valheim_password
  }))

  tags = [
    "valheim",
    "gameserver",
    "automated"
  ]
}

# Klucz SSH
resource "ovh_cloud_project_sshkey" "valheim_key" {
  service_name = var.ovh_service_name
  name         = "valheim-server-key"
  public_key   = file(var.ssh_public_key_path)
}

# Otwieranie portów w firewall
resource "ovh_cloud_project_instance_interface" "valheim_interface" {
  service_name = var.ovh_service_name
  instance_id  = ovh_cloud_project_instance.valheim_server.id
  type         = "public"
}

# Output z adresem IP
output "server_ip" {
  value = ovh_cloud_project_instance.valheim_server.ip_address
  description = "Publiczny adres IP serwera Valheim"
}

output "ssh_command" {
  value = "ssh -i ${var.ssh_private_key_path} ubuntu@${ovh_cloud_project_instance.valheim_server.ip_address}"
  description = "Komenda SSH do połączenia z serwerem"
}