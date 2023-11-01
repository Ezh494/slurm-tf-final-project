data "yandex_vpc_subnet" "public" {
  for_each = toset(var.az)
  name = each.key
}

locals {
  preffix = "slurm"
  availability_zone_subnets = {
    for s in data.yandex_vpc_subnet.public : s.zone => s.subnet_id...
  }
}

