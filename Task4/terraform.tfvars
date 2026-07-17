yc_service_account_key_file = "./sa-key.json"
yc_endpoint                 = "api.yandexcloud.kz:443"
yc_cloud_id                 = "ao74pnhq76d2s3v***"
yc_folder_id                = "ao7j3hn6c8t4l88***"

project_name = "future20"
environment  = "demo"
default_zone = "kz1-a"

subnet_cidr = "10.20.10.0/24"

admin_cidr_blocks = ["0.0.0.0/0"]

ssh_user       = "ubuntu"
public_ssh_key = "ssh-ed25519 public_key future20@example"

create_clinics       = true
create_ai_services   = false
create_fintech       = false
create_head_office   = false
create_partners      = false
create_data_platform = true

vm_cores     = 2
vm_memory_gb = 2

disk_type           = "network-hdd"
boot_disk_size_gb   = 15
domain_disk_size_gb = 20
