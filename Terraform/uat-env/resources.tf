
resource "tls_private_key" "ssh_key_tls" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "openstack_compute_keypair_v2" "key_pair" {
  name       = var.ssh_key_name
  public_key = tls_private_key.ssh_key_tls.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key_tls.private_key_pem
  filename        = "${var.key_directory}/${var.ssh_key_name}.pem"
  file_permission = "0600"
}



# Create security group
resource "openstack_networking_secgroup_v2" "secgroup_tf" {
  name        = var.security_group_name

}

# Add rules to the security group
resource "openstack_networking_secgroup_rule_v2" "secgroup_rules" {
  count             = length(var.secgroup_rules)
  direction         = var.security_rule_direction
  ethertype         = var.ethertype
  protocol          = var.secgroup_rules[count.index].protocol
  port_range_min    = var.secgroup_rules[count.index].port_range_min
  port_range_max    = var.secgroup_rules[count.index].port_range_max
  remote_ip_prefix  = var.secgroup_rules[count.index].remote_ip_prefix
  security_group_id = openstack_networking_secgroup_v2.secgroup_tf.id
  }


# Call the module for master nodes
module "k8s-master-nodes" {
  source                = "./../modules/k8s-nodes"
  key_directory         = var.key_directory
  ssh_key_name          = var.ssh_key_name
  key_pair_name         = openstack_compute_keypair_v2.key_pair.name
  public_ssh_key        = tls_private_key.ssh_key_tls.public_key_openssh
  secgroup_name         = openstack_networking_secgroup_v2.secgroup_tf.name
  instance_count        = var.master_count
  instance_name         = var.master_instance_name
  image_id              = var.image_id
  flavor_id             = var.flavor_id
  volume_size           = var.volume_size
  internal_network_name = var.internal_network_name
  external_network_name = var.external_network_name
  metadata              = var.master_metadata
  user_data_template    = file(var.master_user_data_template)
}

# Call the module for worker nodes
module "k8s-worker-nodes" {
  source                = "./../modules/k8s-nodes"
  key_directory         = var.key_directory
  ssh_key_name          = var.ssh_key_name
  key_pair_name        = openstack_compute_keypair_v2.key_pair.name
  public_ssh_key        = tls_private_key.ssh_key_tls.public_key_openssh
  secgroup_name         = openstack_networking_secgroup_v2.secgroup_tf.name
  instance_count        = var.worker_count
  instance_name         = var.worker_instance_name
  image_id              = var.image_id
  flavor_id             = var.flavor_id
  volume_size           = var.volume_size
  internal_network_name = var.internal_network_name
  external_network_name = var.external_network_name
  metadata              = var.worker_metadata
  user_data_template    = file(var.worker_user_data_template)
  
}


