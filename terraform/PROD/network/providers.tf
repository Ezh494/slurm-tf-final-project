terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "~> 0.80"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.1"
    }
  }
  required_version = ">= 0.13"
}

variable YC_TOKEN {}
variable YC_CLOUD_ID {}
variable YC_FOLDER_ID {}


provider "yandex" {
  token     = "${var.YC_TOKEN}"
  cloud_id  = "${var.YC_CLOUD_ID}"
  folder_id = "${var.YC_FOLDER_ID}"
}
