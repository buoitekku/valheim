# === Provider & OVH API ===
variable "ovh_endpoint" {
  description = "Endpoint OVH API (np. ovh-eu)"
  type        = string
  default     = "ovh-eu"
}

variable "ovh_application_key" {
  description = "Application Key wygenerowany w OVH API"
  type        = string
  sensitive   = true
}

variable "ovh_application_secret" {
  description = "Application Secret wygenerowany w OVH API"
  type        = string
  sensitive   = true
}

variable "ovh_consumer_key" {
  description = "Consumer Key wygenerowany w OVH API"
  type        = string
  sensitive   = true
}

variable "ovh_service_name" {
  description = "Nazwa projektu OVH Cloud (service_name)"
  type        = string
}

# === Parametry instancji ===
variable "instance_flavor" {
  description = "Typ maszyny (np. s1-2, b2-7, c2-15 itp.)"
  type        = string
}

variable "instance_image" {
  description = "Obraz systemu (np. Ubuntu 22.04)"
  type        = string
}

variable "instance_region" {
  description = "Region OVH (np. GRA11, BHS5, WAW1)"
  type        = string
}

# === SSH ===
variable "ssh_public_key_path" {
  description = "Ścieżka do publicznego klucza SSH (np. ~/.ssh/id_rsa.pub)"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Ścieżka do prywatnego klucza SSH (np. ~/.ssh/id_rsa)"
  type        = string
}

# === Parametry serwera Valheim ===
variable "valheim_server_name" {
  description = "Nazwa serwera Valheim (wyświetlana w grze)"
  type        = string
  default     = "Valheim Server"
}

variable "valheim_world_name" {
  description = "Nazwa świata Valheim"
  type        = string
  default     = "DedicatedWorld"
}

variable "valheim_password" {
  description = "Hasło do serwera Valheim"
  type        = string
  sensitive   = true
}
