resource "tls_private_key" "yandex-ssh-key" {
  count = var.public_ssh_key_path == "" ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}
