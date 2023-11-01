data "yandex_dns_zone" "this" {
  name    = "${var.dns_zone_name}"
}

resource "yandex_dns_recordset" "rs-1" {
  zone_id = data.yandex_dns_zone.this.id
  name    = "${var.domain}.${var.dns_zone}."
  ttl     = 600
  type    = "A"
  data    = [yandex_alb_load_balancer.alb-1.listener[0].endpoint[0].address[0].external_ipv4_address[0].address]
}

resource "yandex_dns_recordset" "rs-2" {
  zone_id = data.yandex_dns_zone.this.id
  name    = "www"
  ttl     = 600
  type    = "CNAME"
  data    = [ "${var.domain}.${var.dns_zone}" ]
}
