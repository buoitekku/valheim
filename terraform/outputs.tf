output "instance_id" {
  value       = openstack_compute_instance_v2.valheim_server.id
  description = "ID instancji OpenStack"
}

output "server_private_ip" {
  value       = openstack_compute_instance_v2.valheim_server.access_ip_v4
  description = "Prywatny adres IP (jeśli dostępny)"
}

output "server_floating_ip" {
  value       = openstack_networking_floatingip_v2.fip.address
  description = "Publiczny (floating) IP przypisany do instancji"
}

output "ssh_command" {
  value       = "ssh -i ${var.ssh_private_key_path} ubuntu@${openstack_networking_floatingip_v2.fip.address}"
  description = "Komenda SSH do połączenia z serwerem"
}
