[control_plane_nodes]
%{ for instance in master_nodes ~}
%{ if instance == master_nodes[0] ~}
${instance.floating_ip} ansible_user=k8s ansible_ssh_private_key_file=../Terraform/${environment_name}/.ssh/${ssh_key_name}.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no'
%{ else ~}
${instance.private_ip} ansible_user=k8s ansible_ssh_private_key_file=../Terraform/${environment_name}/.ssh/${ssh_key_name}.pem ansible_ssh_common_args='-o ProxyCommand="ssh -i ../Terraform/${environment_name}/.ssh/${ssh_key_name}.pem -W %h:%p -q k8s@${master_nodes[0].floating_ip}"'
%{ endif ~}
%{ endfor ~}

[worker_nodes]
%{ for instance in worker_nodes ~}
${instance.private_ip} ansible_user=k8s ansible_ssh_private_key_file=../Terraform/${environment_name}/.ssh/${ssh_key_name}.pem ansible_ssh_common_args='-o ProxyCommand="ssh -i ../Terraform/${environment_name}/.ssh/${ssh_key_name}.pem -W %h:%p -q k8s@${master_nodes[0].floating_ip}"'
%{ endfor ~}
