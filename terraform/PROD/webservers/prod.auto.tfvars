public_ssh_key_path = "~/.ssh/id_rsa.pub"
vm_name = "nginx"
vm_count = 5
vm_resource = {
  vm_cpu = 4
  vm_ram = 8
  vm_sysdisk_size = 25
  vm_secdisk_count = 2
  vm_secdisk_type = "network-ssd"
  vm_secdisk_size = 10
}
group_labels = {
  "app" = "nginx"
}
domain = "nginx"
