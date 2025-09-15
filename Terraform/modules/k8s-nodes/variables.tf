####################### SSH Key Info #######################

variable "ssh_key_name" {
  description = "The name of the shared SSH keypair (used in file names and outputs)"
  type        = string
}

variable "key_pair_name" {
  description = "The name of the keypair as registered in OpenStack"
  type        = string
}

variable "public_ssh_key" {
  description = "The public SSH key to inject into instances via cloud-init"
  type        = string
}

variable "key_directory" {
  description = "Path to the directory where the SSH private key is stored"
  type        = string
}

####################### Instance Configuration #######################

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
}

variable "instance_name" {
  description = "Base name to assign to each instance"
  type        = string
}

variable "image_id" {
  description = "ID of the image to use when booting the instance"
  type        = string
}

variable "flavor_id" {
  description = "ID of the flavor to use for the instance"
  type        = string
}

variable "volume_size" {
  description = "Size of the volume to attach to the instance (in GB)"
  type        = number
}

####################### Networking #######################

variable "secgroup_name" {
  description = "Name of the OpenStack security group"
  type        = string
}

variable "internal_network_name" {
  description = "Name of the internal network to attach instances to"
  type        = string
}

variable "external_network_name" {
  description = "Name of the external network for floating IPs"
  type        = string
}

####################### Metadata / Templates #######################

variable "metadata" {
  description = "Metadata to associate with the instance"
  type        = map(string)
  default     = {}
}

variable "user_data_template" {
  description = "User data template content for cloud-init"
  type        = string
}
