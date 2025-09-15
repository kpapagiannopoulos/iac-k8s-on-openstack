output "instance_ips" {
  value = [for instance in openstack_compute_instance_v2.instance : instance.access_ip_v4]
}

output "instance_details" {
  value = [
    for idx, instance in openstack_compute_instance_v2.instance : {
      name        = instance.name
      floating_ip = openstack_networking_floatingip_v2.floatingip[idx].address
      private_ip  = instance.access_ip_v4
      key_path    = "${var.key_directory}/${var.ssh_key_name}.pem"
      key_name    = "${var.ssh_key_name}.pem"
    }
  ]
}
