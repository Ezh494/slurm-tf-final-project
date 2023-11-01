// Create New DNS zone
resource "yandex_dns_zone" "this" {
  name        = "${var.dns_zone_name}"
  description = "Public zone"
  zone        = "${var.dns_zone}."
  public      = true
  labels      = merge(var.labels, var.group_labels)
}

// Create DNS records
//resource "yandex_dns_recordset" "rs-1" {
//  zone_id = yandex_dns_zone.this.id
//  name    = "${var.domain}.${var.dns_zone}."
//  ttl     = 600
//  type    = "A"
//  data    = [yandex_alb_load_balancer.alb-1.listener[0].endpoint[0].address[0].external_ipv4_address[0].address]
//}
//
//resource "yandex_dns_recordset" "rs-2" {
//  zone_id = yandex_dns_zone.this.id
//  name    = "www"
//  ttl     = 600
//  type    = "CNAME"
//  data    = [ "${var.domain}.${var.dns_zone}" ]
//}
