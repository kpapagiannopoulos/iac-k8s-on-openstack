# Define required providers
terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
}





# # Generate a single SSH key pair
# resource "tls_private_key" "ssh_key_tls" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

# # Register the public key in OpenStack
# resource "openstack_compute_keypair_v2" "key_pair" {
#   name       = var.ssh_key_name
#   public_key = tls_private_key.ssh_key_tls.public_key_openssh
# }

# # Save the private key locally
# resource "local_file" "private_key" {
#   content         = tls_private_key.ssh_key_tls.private_key_pem
#   filename        = "${var.key_directory}/${var.ssh_key_name}.pem"
#   file_permission = "0600"
# }


# Generate user data with hostname
data "template_file" "user_data" {
  count    = var.instance_count
  template = var.user_data_template
  vars = {
    hostname     = "${var.instance_name}-${count.index}"
    ssh_key      = var.public_ssh_key
    ssh_key_path = "${var.key_directory}/${var.key_pair_name}.pem"
  }
}



# Create volumes
resource "openstack_blockstorage_volume_v3" "volume" {
  count       = var.instance_count
  name        = "${var.instance_name}-volume-${count.index}"
  size        = var.volume_size
  image_id    = var.image_id
  timeouts {
    create = "60m"
    delete = "60m"
  }
}



# Create instances
resource "openstack_compute_instance_v2" "instance" {
  count           = var.instance_count
  name            = "${var.instance_name}-${count.index}"
  flavor_id       = var.flavor_id
  key_pair        = var.key_pair_name


  security_groups = [var.secgroup_name]


  network {
    name = var.internal_network_name
  }

  metadata = var.metadata

  user_data = data.template_file.user_data[count.index].rendered

  block_device {
  uuid                   = openstack_blockstorage_volume_v3.volume[count.index].id
  source_type            = "volume"
  destination_type       = "volume"
  volume_size            = var.volume_size
  boot_index             = 0
  delete_on_termination  = true
  }

  timeouts {
    create = "20m"  # Increase this value if needed
  }

  depends_on = [openstack_blockstorage_volume_v3.volume] 
}

# Create floating IPs
resource "openstack_networking_floatingip_v2" "floatingip" {
  count = var.instance_count
  pool  = var.external_network_name
}

# Associate floating IPs with instances
resource "openstack_compute_floatingip_associate_v2" "floatingip_associate" {
  count       = var.instance_count
  floating_ip = openstack_networking_floatingip_v2.floatingip[count.index].address
  instance_id = openstack_compute_instance_v2.instance[count.index].id
}
