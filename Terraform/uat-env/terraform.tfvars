# instance_name               = "vm-tf"
worker_instance_name        = "k8s-worker"
master_instance_name        = "k8s-master"
# image_id                    = "6f7b298b-d713-4d13-831e-783083a458fc" #ubuntu 22.04
image_id                    = "a2a33db3-0d56-4e2e-bcae-033cd7840724"  #ubuntu 24.04
flavor_id                   = "m1.medium"
internal_network_name       = "kpapagias"
external_network_name       = "external-1759"
volume_size                 = 20
key_directory               = "./.ssh"
master_count                = 1
worker_count                = 1
worker_metadata             = {"role" = "worker"}               
master_metadata             = {"role" = "control_plane"}
master_user_data_template   = "../templates/cloud-init-master.yaml"  
worker_user_data_template   = "../templates/cloud-init-worker.yaml" 
ansible_data_template       = "../templates/ansible-host-file.tpl"   
security_group_name         = "uat-security-group"
ethertype                   = "IPv4"
environment_name            = "uat-env"
security_rule_direction     = "ingress"
ssh_key_name                = "k8s-shared-key"