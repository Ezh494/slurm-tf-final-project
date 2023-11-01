output "private_ssh_key" {
  value = var.public_ssh_key_path == "" ? tls_private_key.yandex-ssh-key[0].private_key_openssh : ""
  sensitive = true
}
output "private_ip" {
  value = yandex_compute_instance_group.this.instances[*].network_interface.0.ip_address
}
output "external_ip" {
  value = yandex_compute_instance_group.this.instances[*].network_interface.0.nat_ip_address
}
//output "external_ip_lb" {
//  value = yandex_lb_network_load_balancer.this.listener.*.external_address_spec[0].*.address
//}
output "alb_load_balancer_public_ips" {
  description = "ALB public IPs"
  value       = "${yandex_alb_load_balancer.alb-1.listener[0].endpoint[0].address[0].external_ipv4_address[0].address}"
}

output "alb_dns_record_cname" {
  description = "ALB DNS record with external IP address"
  value       = [ 
    "${yandex_dns_recordset.rs-1.name}",
    "${yandex_dns_recordset.rs-2.name}.${yandex_dns_recordset.rs-1.name}" 
  ]
}

//output "subnets" {
// value = local.availability_zone_subnets
//}

output "image_family" {
  value = data.yandex_compute_image.this.family
}
