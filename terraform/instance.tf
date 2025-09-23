resource "openstack_compute_keypair_v2" "valheim_key" {
  name       = "valheim-server-key"
  public_key = file(var.ssh_public_key_path)
}

resource "openstack_compute_instance_v2" "valheim_server" {
  name        = "valheim-server"
  flavor_name = var.instance_flavor
  image_name  = var.instance_image
  region      = var.instance_region

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

  timeouts {
    create = "30m"
    delete = "30m"
  }
}

resource "openstack_networking_floatingip_v2" "fip" {
  pool = var.external_network_name
}

resource "openstack_compute_floatingip_associate_v2" "fip_assoc" {
  instance_id    = openstack_compute_instance_v2.valheim_server.id
  floating_ip_id = openstack_networking_floatingip_v2.fip.id
}
