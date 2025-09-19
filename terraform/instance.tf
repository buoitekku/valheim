resource "openstack_compute_keypair_v2" "valheim_key" {
  name       = "valheim-key"
  public_key = file(var.ssh_public_key_path)
}

resource "openstack_compute_instance_v2" "valheim_server" {
  name            = var.valheim_server_name
  flavor_name     = var.instance_flavor
  image_name      = var.instance_image
  key_pair        = openstack_compute_keypair_v2.valheim_key.name
  security_groups = [openstack_networking_secgroup_v2.valheim_sg.name]

  network {
    uuid = openstack_networking_network_v2.valheim_net.id
  }

  metadata = {
    valheim_world = var.valheim_world_name
    valheim_pass  = var.valheim_password
  }
}