
# variable "instance_name" {
#   description = "instance name"
#   type        = string
# }

variable "master_instance_name" {
  description = "instance name"
  type        = string
}


variable "worker_instance_name" {
  description = "instance name"
  type        = string
}

# Variables for the root module
variable "key_directory" {
  description = "Path to save the private key files"
  type        = string
}




variable "image_id" {
  description = "ID of the image to use"
  type        = string
}

variable "flavor_id" {
  description = "ID of the flavor to use"
  type        = string
}



variable "volume_size" {
  description = "Size of the volume in GB"
  type        = number
}

variable "internal_network_name" {
  description = "Name of the network to attach the instance to"
  type        = string
}

variable "external_network_name" {
  description = "Name of the external network for floating IPs"
  type        = string
}

variable "master_count" {
  description = "Number of master nodes"
  type        = number
  default     = 1
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 1
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
}

variable "ethertype" {
  type        = string
}


variable "secgroup_rules" {
  description = "List of security group rules"
  type = list(object({
    protocol        = string
    port_range_min  = number
    port_range_max  = number
    remote_ip_prefix = string
    remote_group_id  = string
    
  }))
  default = [
    {
      protocol        = "tcp"
      port_range_min  = 22
      port_range_max  = 22
      remote_ip_prefix = "0.0.0.0/0"
      remote_group_id  = ""
    },
    {
      protocol        = "tcp"
      port_range_min  = 1
      port_range_max  = 65535
      remote_ip_prefix = "10.0.0.0/16"
      remote_group_id  = null
    }
  ]
}


variable "worker_metadata" {
  description = "Metadata for the instances"
  type        = map(string)
  default     = {}
}

variable "master_metadata" {
  description = "Metadata for the instances"
  type        = map(string)
  default     = {}
}


variable "master_user_data_template" {
  description = "Path to the cloud-init template for master nodes"
  type        = string
}

variable "worker_user_data_template" {
  description = "Path to the cloud-init template for worker nodes"
  type        = string
}

variable "environment_name" {
  description = "environment name, keep the same as the terraform root"
  type        = string
}


variable "security_rule_direction" {
  type        = string
}


variable "ansible_data_template" {
  type        = string
}

variable "ssh_key_name" {
  description = "Name of the shared SSH keypair"
  type        = string
  default     = "k8s-shared-key"  # or set it without default and define in tfvars
}

