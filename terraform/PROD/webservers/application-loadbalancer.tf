resource "yandex_vpc_security_group" "alb-sg" {
  name        = "alb-sg"
  network_id  = data.yandex_vpc_network.this.id
  labels         = merge(var.labels, var.group_labels)
  
  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 1
    to_port        = 65535
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-http"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-https"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  ingress {
    protocol          = "TCP"
    description       = "healthchecks"
    predefined_target = "loadbalancer_healthchecks"
    port              = 30080
  }
}

resource "yandex_vpc_security_group" "alb-vm-sg" {
  name        = "alb-vm-sg"
  network_id  = data.yandex_vpc_network.this.id
  labels         = merge(var.labels, var.group_labels)
  
  ingress {
    protocol          = "TCP"
    description       = "balancer"
    security_group_id = yandex_vpc_security_group.alb-sg.id
    port              = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "ssh"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }
}

resource "yandex_alb_backend_group" "alb-bg" {
  name                     = "alb-bg"
  labels         = merge(var.labels, var.group_labels)

  http_backend {
    name                   = "backend-1"
    port                   = 80
    target_group_ids       = [yandex_compute_instance_group.this.application_load_balancer.0.target_group_id]
    load_balancing_config {
      locality_aware_routing_percent = 0
      mode = "ROUND_ROBIN"
      panic_threshold = 0
      strict_locality = false
    }
    healthcheck {
      timeout              = "10s"
      interval             = "2s"
      healthcheck_port     = 80
      http_healthcheck {
        path               = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "this" {
  name   = "alb-router"
  labels         = merge(var.labels, var.group_labels)
}

resource "yandex_alb_virtual_host" "this" {
  name           = "alb-host"
  http_router_id = yandex_alb_http_router.this.id
  authority      = ["${var.domain}.${var.dns_zone}", "www.${var.domain}.${var.dns_zone}", ]
  route {
    name = "route-1"
    http_route {
      http_match {
        http_method = []
        path {
          prefix = "/"
        }
    }
      http_route_action {
        backend_group_id = yandex_alb_backend_group.alb-bg.id
      }
    }
  }
}

resource "yandex_alb_load_balancer" "alb-1" {
  name               = "alb-1"
  network_id         = data.yandex_vpc_network.this.id
  security_group_ids = [yandex_vpc_security_group.alb-sg.id]
  labels         = merge(var.labels, var.group_labels)
  
  allocation_policy {
    dynamic "location" {
      for_each = tomap(local.availability_zone_subnets)
        content {
          zone_id   = location.key
          subnet_id = location.value[0]
        }
    }
  }
  listener {
    name = "alb-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.this.id
      }
    }
  }
  depends_on = [
    yandex_compute_instance_group.this,
    yandex_resourcemanager_folder_iam_member.editor
  ]
}

