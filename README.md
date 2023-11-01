# YC configuration packer and terraform
## Presettings workstation
### Create YC access vars with help YC-Cli or manual!!!
* export TF_VAR_YC_FOLDER_ID=$(yc config get folder-id)
* export TF_VAR_YC_CLOUD_ID=$(yc config get cloud-id)
* export TF_VAR_YC_TOKEN=$(yc iam create-token)

## Packer information
## Create image from Ubuntu family with preinstalled NGINX
Change main vars: 

1. /packer/nginx.pkr.hcl:
* YC_SUBNET_ID - default/test subnet ID
* YC_ZONE - default/test zone
* image_name - full name image - "${image_name}-${image_tag}"
* source_image_family - source image (ansible-playbook work only Ubuntu)
* prefix - first part new image family name, new family - "${var.prefix}-${var.env_name}-${var.image_name}-${var.new_image_family}"
* env_name - second part new image family name
* new_image_family - last part new image family name

Init and start packer

* packer init
* packer build -var 'image_tag=1' nginx.pkr.hcl

## Terraform information
## Create webservers with application loadbalancer
## Create DNS zone for environment
Change main vars:

1. /terraform/PROD/prod.tfvars
* dns_zone_name - Name zone in the YC
* dns_zone - Domain zone, all domain name higher control that zone
2. /terraform/PROD/DNS/prod.auto.tfvars
* group_labels - extra labels for group DNS
* domain - for future add records(not need now!)

Init and start terraform 

* terraform init (inside folder - /terraform/PROD/DNS)
* terraform apply --var-file ../prod.tfvars
## Create networks for environment
Change main vars:

1. /terraform/PROD/prod.tfvars
* az - avalibility zone 
* cidr_blocks - lists subnets for avalibility zone 
2. /terraform/PROD/network/prod.auto.tfvars
* group_labels - extra labels for group network

Init and start terraform 

* terraform init (inside folder - /terraform/PROD/network)
* terraform apply --var-file ../prod.tfvars
## Create VM and alb
Change main vars:

1 . /terraform/PROD/webservers/prod.auto.tfvars
* public_ssh_key_path - SSH key for VM, if you write empty strings "", generation new ssh-key and show in the outputs 
* vm_name - name virtual machines, full name - "${local.preffix}-${var.env_name}-${var.vm_name}{instance.index}"
* vm_count - count virtual machines
* vm_resource(vm_cpu,vm_ram,vm_sysdisk_size) - Resources virtual machines (secdisk not works now!)
* group_labels - extra labels for group webservers
* domain - DNS A and CNAME "WWW" records for App

Init and start terraform 

* terraform init (inside folder - /terraform/PROD/webservers
* terraform apply --var-file ../prod.tfvars