# Zmienne OVHCloud
variable "ovh_endpoint" {
  description = "Endpoint API OVHCloud"
  type        = string
  default     = "ovh-eu"
}

variable "ovh_application_key" {
  description = "Klucz aplikacji OVHCloud"
  type        = string
  sensitive   = true
}

variable "ovh_application_secret" {
  description = "Sekret aplikacji OVHCloud"
  type        = string
  sensitive   = true
}

variable "ovh_consumer_key" {
  description = "Klucz konsumenta OVHCloud"
  type        = string
  sensitive   = true
}

variable "ovh_service_name" {
  description = "Nazwa projektu OVHCloud"
  type        = string
}

# Zmienne instancji
variable "instance_flavor" {
  description = "Typ instancji VPS"
  type        = string
  default     = "s1-2"  # 1 vCPU, 2GB RAM - wystarczające dla małego serwera Valheim
}

variable "instance_image" {
  description = "Obraz systemu operacyjnego"
  type        = string
  default     = "Ubuntu 22.04"
}

variable "instance_region" {
  description = "Region datacenter"
  type        = string
  default     = "GRA11"  # Gravelines, Francja - dobra lokalizacja dla Polski
}

# Zmienne SSH
variable "ssh_public_key_path" {
  description = "Ścieżka do publicznego klucza SSH"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_private_key_path" {
  description = "Ścieżka do prywatnego klucza SSH"
  type        = string
  default     = "~/.ssh/id_rsa"
}

# Zmienne serwera Valheim
variable "valheim_server_name" {
  description = "Nazwa serwera Valheim"
  type        = string
  default     = "Mój Serwer Valheim"
}

variable "valheim_world_name" {
  description = "Nazwa świata Valheim"
  type        = string
  default     = "MojSwiat"
}

variable "valheim_password" {
  description = "Hasło do serwera Valheim"
  type        = string
  sensitive   = true
}