resource "openstack_networking_secgroup_v2" "valheim_server_sg" {
  name        = "valheim-sg"
  description = "Security group dla serwera Valheim"
}

resource "openstack_networking_secgroup_rule_v2" "valheim_udp_rule" {
  security_group_id = openstack_networking_secgroup_v2.valheim_server_sg.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 2456
  port_range_max    = 2458
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "ssh_rule" {
  security_group_id = openstack_networking_secgroup_v2.valheim_server_sg.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.ssh_allowed_cidr
}
