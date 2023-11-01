variable "env_name" {
  type = string
  description = "Name ENV of the virtual machine"
}
variable "dns_zone_name" {
  type      = string
}
variable "dns_zone" {
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