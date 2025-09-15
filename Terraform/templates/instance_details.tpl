master_nodes:
  %{ for instance in master_nodes }
  - name: ${instance.name}
    floating_ip: ${instance.floating_ip}
    private_ip: ${instance.private_ip}
    key_path: ../Terraform/${environment_name}/.ssh/${ssh_key_name}.pem
  %{ endfor }

worker_nodes:
  %{ for instance in worker_nodes }
  - name: ${instance.name}
    floating_ip: ${instance.floating_ip}
    private_ip: ${instance.private_ip}
    key_path: ../Terraform/${environment_name}/.ssh/${ssh_key_name}.pem
  %{ endfor }
