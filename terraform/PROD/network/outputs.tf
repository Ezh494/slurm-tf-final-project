

output "yandex_vpc_network" {
  value = ["${yandex_vpc_network.this.name}" , "${yandex_vpc_network.this.id}"]
}

output "yandex_vpc_subnet" {
  value = "${yandex_vpc_subnet.this[*]}"
}
