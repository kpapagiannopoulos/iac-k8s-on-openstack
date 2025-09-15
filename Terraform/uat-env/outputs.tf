# Output the IP addresses of the master instances
output "master_ips" {
  value = module.k8s-master-nodes.instance_ips
}

# Output the IP addresses of the worker instances
output "worker_ips" {
  value = module.k8s-worker-nodes.instance_ips
}

# Output instance details per group
output "master_instance_details" {
  value = module.k8s-master-nodes.instance_details
}

output "worker_instance_details" {
  value = module.k8s-worker-nodes.instance_details
}

# Combined instance details
output "instance_details" {
  value = {
    master_nodes = module.k8s-master-nodes.instance_details
    worker_nodes = module.k8s-worker-nodes.instance_details
  }
}

# Save combined instance details to YAML file
resource "local_file" "combined_instance_details" {
  content = templatefile("${path.module}/instance_details.tpl", {
    master_nodes     = module.k8s-master-nodes.instance_details
    worker_nodes     = module.k8s-worker-nodes.instance_details
    ssh_key_name     = var.ssh_key_name
    environment_name = var.environment_name
  })
  filename = "${path.root}/instance_details.yaml"
}

# Save hosts.ini for Ansible
resource "local_file" "ansible_host_file" {
  content = templatefile(var.ansible_data_template, {
    master_nodes     = module.k8s-master-nodes.instance_details
    worker_nodes     = module.k8s-worker-nodes.instance_details
    ssh_key_name     = var.ssh_key_name
    environment_name = var.environment_name
  })
  filename = "../../Ansible/inventories/${var.environment_name}/hosts.ini"
}
