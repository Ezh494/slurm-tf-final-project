output "dns_zone_id" {
  value       = [ 
    "name=${yandex_dns_zone.this.name}", 
    "zone=${yandex_dns_zone.this.zone}",
    "id=${yandex_dns_zone.this.id}" 
  ]
}
