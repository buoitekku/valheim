resource "openstack_networking_network_v2" "valheim_net" {
  name = var.network_name
}

resource "openstack_networking_subnet_v2" "valheim_subnet" {
  name       = "${var.network_name}-subnet"
  network_id = openstack_networking_network_v2.valheim_net.id
  cidr       = "10.0.0.0/24"
  ip_version = 4
}

resource "openstack_networking_router_v2" "valheim_router" {
  name                 = "valheim-router"
  external_network_id  = var.external_network_name
}

resource "openstack_networking_router_interface_v2" "router_iface" {
  router_id = openstack_networking_router_v2.valheim_router.id
  subnet_id = openstack_networking_subnet_v2.valheim_subnet.id
}
