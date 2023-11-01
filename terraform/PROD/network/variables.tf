variable "env_name" {
  type = string
  description = "Name ENV of the virtual machine"
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
variable "az" {
  type = list(string)
  default = [
    "ru-central1-a",
    "ru-central1-b",
    "ru-central1-c"
  ]
  description = "Availability Zones"
}
variable "labels" {
  type = map(string)
  description = "Labels to add to resourses"
}
variable "group_labels" {
  type = map(string)
  description = "Labels to add to resourses"
}