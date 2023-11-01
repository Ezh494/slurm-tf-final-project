data "yandex_compute_image" "this" { 
  family  = "${local.preffix}-${var.env_name}-${var.vm_name}-${var.vm_image_family}"
  folder_id = "${var.YC_FOLDER_ID}"
}

data "yandex_vpc_network" "this" {
  name = "${local.preffix}-${var.env_name}-main"
}

//resource "yandex_compute_disk" "secdisk" {
//count = "${var.vm_resource.vm_secdisk_count*var.vm_count}"
//
//  name   = "${local.preffix}-${var.env_name}-${var.vm_name}${floor(count.index/var.vm_resource.vm_secdisk_count) % var.vm_count}-disk${(count.index % var.vm_resource.vm_secdisk_count)+1}"
//  type   = var.vm_resource.vm_secdisk_type
//  zone   = var.az[floor(count.index/var.vm_resource.vm_secdisk_count) % length(var.az)]
//  size   = var.vm_resource.vm_secdisk_size
//  labels         = merge(var.labels, var.group_labels)
//}

resource "yandex_compute_instance_group" "this" {
  name                = "nging-ig"
  folder_id           = "${var.YC_FOLDER_ID}"
  service_account_id  = "${yandex_iam_service_account.ig-sa.id}"
  labels         = merge(var.labels, var.group_labels)
  deletion_protection = false
  instance_template {
    name = "${local.preffix}-${var.env_name}-${var.vm_name}{instance.index}"  //{instance.short_id} or {instance.index}
    platform_id = "standard-v1"
    resources {
      memory = var.vm_resource.vm_ram
      cores  = var.vm_resource.vm_cpu
    }
  
   boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "${data.yandex_compute_image.this.id}"
        size     = var.vm_resource.vm_sysdisk_size
      }
    }

  network_interface {
      subnet_ids = "${data.yandex_vpc_network.this.subnet_ids}"
      nat = true
    }
  metadata = {
      user-data = templatefile("${path.module}/user_data.yaml.tftpl", { public_ssh_key = var.public_ssh_key_path == "" ? "${tls_private_key.yandex-ssh-key[0].public_key_openssh}" : "${file(var.public_ssh_key_path)}"})
      serial-port-enable = 1
    }
    network_settings {
      type = "STANDARD"
    }
  }
  variables = {
    test_key1 = "test_value1"
    test_key2 = "test_value2"
  }
  scale_policy {
    fixed_scale {
      size = var.vm_count
    }
  }

  allocation_policy {
    zones = "${var.az[*]}"
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 5
    max_expansion   = 2
    max_deleting    = 5
  }
  
  application_load_balancer {
    target_group_name = "alb-tg"
  }
  depends_on = [
    yandex_resourcemanager_folder_iam_member.editor
  ]
}
