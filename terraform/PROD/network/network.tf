resource "yandex_vpc_network" "this" {
  name = "${local.preffix}-${var.env_name}-main"
}

resource "yandex_vpc_subnet" "this" {
  for_each       = toset(var.az) // for_each {key:value} - toset из списка создает set

  name           = "${each.value}"
  zone           = each.value
  network_id     = var.vpc_id != "" ? var.vpc_id : yandex_vpc_network.this.id
  v4_cidr_blocks = var.cidr_blocks[index(var.az, each.value)]
  labels         = merge(var.labels, var.group_labels)
}
