variable "YC_TOKEN" {
  type = string
  default = env("TF_VAR_YC_TOKEN")
}
variable "YC_ZONE" {
  type = string
  default = "ru-central1-a" //env("YC_ZONE")
}
variable "YC_FOLDER_ID" {
  type = string
  default = env("TF_VAR_YC_FOLDER_ID")
}
variable "YC_SUBNET_ID" {
  type = string
  default = "e9btd00urj09dt6crdmu" //env("YC_SUBNET_ID")
}
variable "labels" {
  type = map(string)
  default = {
    "project" = "slurm"
    "team" = "my-team"
    "app" = "nginx"
  }
}
variable "prefix" {
  type = string
  default = "slurm"
}
variable "env_name" {
  type = string
  default = "prod"
}
variable "image_name" {
  type = string
  default = "nginx"
}
variable "source_image_family" {
  type = string
  default = "ubuntu-2004-lts"
}
variable "new_image_family" {
  type = string
  default = "ubuntu20"
}
variable "image_tag" {
  type = string
}

source "yandex" "nginx" {
  folder_id           = "${var.YC_FOLDER_ID}"
  source_image_family = "${var.source_image_family}"
  ssh_username        = "ubuntu"
  use_ipv4_nat        = "true"
  image_description   = "Slurm NGINX image"
  image_family        = "${var.prefix}-${var.env_name}-${var.image_name}-${var.new_image_family}"
  subnet_id           = "${var.YC_SUBNET_ID}"
  token               = "${var.YC_TOKEN}"
  disk_type           = "network-hdd"
  disk_size_gb        = 10
  zone                = "${var.YC_ZONE}"
  image_labels        = var.labels
  // ssh_private_key_file = "~/.ssh/id_rsa"

  
  image_name          = "${var.image_name}-${var.image_tag}"
}

build {
  sources = ["source.yandex.nginx"]
  
  provisioner "ansible" {
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ANSIBLE_REMOTE_TMP=/tmp/.ansible-ubuntu/tmp" 
   ]
    user = "ubuntu"
    playbook_file = "ansible/playbook.yml"

  }
}
