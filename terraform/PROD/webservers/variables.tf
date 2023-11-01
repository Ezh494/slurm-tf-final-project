variable "public_ssh_key_path" {
  type = string
  description = "SSH key path"
  default = ""
}
variable "env_name" {
  type = string
  description = "Name ENV of the virtual machine"
}
variable "az" {
  type = list(string)
  default = [
    "ru-central1-a",
    "ru-central1-b",
    "ru-central1-c"
  ]
  description = "Availability Zones"
}
variable "vpc_id" {
  type = string
  default = ""
  description = "VPC network id"
}
variable "cidr_blocks" {
  type = list(list(string))
  description = "List of IPv4 cidr blocks subnet-a"
}
variable "vm_name" {
  type = string
  description = "Name apps on the virtual machine"
}
variable "vm_count" {
  type = number
  description = "Count virtual machine"
}
variable "vm_image_family" {
  type = string
  default = "ubuntu20"
}
variable "vm_resource" {
  type = object({
    vm_cpu = number
    vm_ram = number
    vm_sysdisk_size = number
    vm_secdisk_count = number
    vm_secdisk_type = string
    vm_secdisk_size = number
  })
  description = "Resources VM"
  default = {
    vm_cpu = 2
    vm_ram = 4
    vm_sysdisk_size = 20
    vm_secdisk_count = 2
    vm_secdisk_type = "network-ssd"
    vm_secdisk_size = 10
  }
}
variable "dns_zone" {
  type      = string
}

variable "dns_zone_name" {
  type      = string
}

variable "domain" {
  type      = string
}
variable "labels" {
  type = map(string)
  description = "Labels to add to resourses"
}
variable "group_labels" {
  type = map(string)
  description = "Labels to add to resourses"
}





