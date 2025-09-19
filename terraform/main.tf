resource "openstack_compute_keypair_v2" "valheim_key" {
  name       = "valheim-server-key"
  public_key = file(var.ssh_public_key_path)
}

resource "openstack_networking_secgroup_v2" "valheim_sg" {
  name        = "valheim-sg"
  description = "Security group dla serwera Valheim"
}

resource "openstack_networking_secgroup_rule_v2" "valheim_udp" {
  security_group_id = openstack_networking_secgroup_v2.valheim_sg.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 2456
  port_range_max    = 2458
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  security_group_id = openstack_networking_secgroup_v2.valheim_sg.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.ssh_allowed_cidr
}

resource "openstack_compute_instance_v2" "valheim_server" {
  name            = "valheim-server"
  flavor_name     = var.instance_flavor
  image_name      = var.instance_image
  region          = var.instance_region

  network {
    name = var.network_name
  }

  key_pair       = openstack_compute_keypair_v2.valheim_key.name
  security_groups = [openstack_networking_secgroup_v2.valheim_sg.name]

  user_data = templatefile("${path.module}/../scripts/cloud-init.yml", {
    valheim_server_name = var.valheim_server_name
    valheim_world_name  = var.valheim_world_name
    valheim_password    = var.valheim_password
  })

  create_timeout = "30m"
  delete_timeout = "30m"
}

resource "openstack_networking_floatingip_v2" "fip" {
  pool = var.external_network_name
}

resource "openstack_compute_floatingip_associate_v2" "fip_assoc" {
  server_id   = openstack_compute_instance_v2.valheim_server.id
  floating_ip = openstack_networking_floatingip_v2.fip.address
}
