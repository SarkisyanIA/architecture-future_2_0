variable "yc_service_account_key_file" {
  description = "Path to authorized service account key JSON file."
  type        = string
  sensitive   = true
}

variable "yc_endpoint" {
  description = "Yandex Cloud API endpoint. For Kazakhstan cloud use the endpoint from yc config list."
  type        = string
  default     = "api.yandexcloud.kz:443"
}

variable "yc_cloud_id" {
  description = "Yandex Cloud ID."
  type        = string
}

variable "yc_folder_id" {
  description = "Yandex Cloud folder ID."
  type        = string
}

variable "default_zone" {
  description = "Availability zone for the training deployment."
  type        = string
  default     = "ru-central1-a"
}

variable "project_name" {
  description = "Project name used in resource names and labels."
  type        = string
  default     = "future20"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "demo"
}

variable "subnet_cidr" {
  description = "CIDR for the single simplified subnet."
  type        = string
  default     = "10.20.10.0/24"
}

variable "admin_cidr_blocks" {
  description = "CIDR blocks allowed to connect to VMs via SSH and portal HTTP/HTTPS."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ssh_user" {
  description = "Linux user for SSH access."
  type        = string
  default     = "ubuntu"
}

variable "public_ssh_key" {
  description = "Public SSH key content for VM metadata."
  type        = string
}

variable "create_clinics" {
  description = "Create VM and disk for clinics domain."
  type        = bool
  default     = true
}

variable "create_ai_services" {
  description = "Create VM and disk for AI services domain."
  type        = bool
  default     = false
}

variable "create_fintech" {
  description = "Create VM and disk for fintech domain."
  type        = bool
  default     = false
}

variable "create_head_office" {
  description = "Create VM and disk for head office domain."
  type        = bool
  default     = false
}

variable "create_partners" {
  description = "Create VM and disk for partners domain."
  type        = bool
  default     = false
}

variable "create_data_platform" {
  description = "Create VM and disk for data platform domain."
  type        = bool
  default     = true
}

variable "vm_image_family" {
  description = "Base OS image family."
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "vm_platform_id" {
  description = "Yandex Compute platform ID."
  type        = string
  default     = "standard-v3"
}

variable "vm_cores" {
  description = "CPU cores for each domain VM."
  type        = number
  default     = 2
}

variable "vm_memory_gb" {
  description = "RAM in GB for each domain VM."
  type        = number
  default     = 2
}

variable "disk_type" {
  description = "Disk type for boot and data disks."
  type        = string
  default     = "network-hdd"
}

variable "boot_disk_size_gb" {
  description = "Boot disk size for each domain VM."
  type        = number
  default     = 15
}

variable "domain_disk_size_gb" {
  description = "Additional persistent disk size for each domain VM."
  type        = number
  default     = 20
}
