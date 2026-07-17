output "network_id" {
  description = "Created VPC network ID."
  value       = yandex_vpc_network.future20_network.id
}

output "subnet_id" {
  description = "Created subnet ID."
  value       = yandex_vpc_subnet.future20_subnet.id
}

output "security_group_id" {
  description = "Created security group ID."
  value       = yandex_vpc_security_group.future20_security_group.id
}

output "clinics_public_ip" {
  description = "Public IP address of clinics domain VM."
  value       = var.create_clinics ? yandex_compute_instance.clinics_instance[0].network_interface[0].nat_ip_address : null
}

output "ai_services_public_ip" {
  description = "Public IP address of AI services domain VM."
  value       = var.create_ai_services ? yandex_compute_instance.ai_services_instance[0].network_interface[0].nat_ip_address : null
}

output "fintech_public_ip" {
  description = "Public IP address of fintech domain VM."
  value       = var.create_fintech ? yandex_compute_instance.fintech_instance[0].network_interface[0].nat_ip_address : null
}

output "head_office_public_ip" {
  description = "Public IP address of head office domain VM."
  value       = var.create_head_office ? yandex_compute_instance.head_office_instance[0].network_interface[0].nat_ip_address : null
}

output "partners_public_ip" {
  description = "Public IP address of partners domain VM."
  value       = var.create_partners ? yandex_compute_instance.partners_instance[0].network_interface[0].nat_ip_address : null
}

output "data_platform_public_ip" {
  description = "Public IP address of data platform domain VM."
  value       = var.create_data_platform ? yandex_compute_instance.data_platform_instance[0].network_interface[0].nat_ip_address : null
}

output "clinics_disk_id" {
  description = "Persistent disk ID for clinics domain VM."
  value       = var.create_clinics ? yandex_compute_disk.clinics_disk[0].id : null
}

output "ai_services_disk_id" {
  description = "Persistent disk ID for AI services domain VM."
  value       = var.create_ai_services ? yandex_compute_disk.ai_services_disk[0].id : null
}

output "fintech_disk_id" {
  description = "Persistent disk ID for fintech domain VM."
  value       = var.create_fintech ? yandex_compute_disk.fintech_disk[0].id : null
}

output "head_office_disk_id" {
  description = "Persistent disk ID for head office domain VM."
  value       = var.create_head_office ? yandex_compute_disk.head_office_disk[0].id : null
}

output "partners_disk_id" {
  description = "Persistent disk ID for partners domain VM."
  value       = var.create_partners ? yandex_compute_disk.partners_disk[0].id : null
}

output "data_platform_disk_id" {
  description = "Persistent disk ID for data platform domain VM."
  value       = var.create_data_platform ? yandex_compute_disk.data_platform_disk[0].id : null
}
