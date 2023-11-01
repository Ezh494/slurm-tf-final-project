env_name = "prod"
dns_zone_name = "test"
dns_zone = "test.ru"
vpc_id = ""
az = [
    "ru-central1-a",
    "ru-central1-b",
    "ru-central1-c"
]
cidr_blocks = [
  ["10.10.0.0/24",
   "10.10.10.0/24"
  ],
  ["10.20.0.0/24"],
  ["10.30.0.0/24"]
]
labels = {
  "project" = "slurm"
  "env" = "prod"
  "team" = "my-team"
}
