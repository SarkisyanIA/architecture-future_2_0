terraform {
  required_version = ">= 1.0.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.130"
    }
  }
}

provider "yandex" {
  endpoint                 = var.yc_endpoint
  service_account_key_file = var.yc_service_account_key_file
  cloud_id                 = var.yc_cloud_id
  folder_id                = var.yc_folder_id
  zone                     = var.default_zone
}

# Базовый образ ОС для всех виртуальных машин.
data "yandex_compute_image" "ubuntu" {
  family = var.vm_image_family
}

# Единая сеть учебного проекта.
resource "yandex_vpc_network" "future20_network" {
  name        = "${var.project_name}-${var.environment}-network"
  description = "Network for Future 2.0 domain infrastructure"
}

# Единая подсеть для всех доменных VM.
resource "yandex_vpc_subnet" "future20_subnet" {
  name           = "${var.project_name}-${var.environment}-subnet"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.future20_network.id
  v4_cidr_blocks = [var.subnet_cidr]
}

# Общая security group для учебной схемы.
# Разрешает SSH для проверки apply, HTTP/HTTPS для прототипа портала
# и внутренний трафик между VM в одной подсети.
resource "yandex_vpc_security_group" "future20_security_group" {
  name        = "${var.project_name}-${var.environment}-sg"
  description = "Common security group for Future 2.0 training infrastructure"
  network_id  = yandex_vpc_network.future20_network.id

  ingress {
    description    = "SSH"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = var.admin_cidr_blocks
  }

  ingress {
    description    = "HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = var.admin_cidr_blocks
  }

  ingress {
    description    = "HTTPS"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = var.admin_cidr_blocks
  }

  ingress {
    description    = "Internal traffic between domain VMs"
    protocol       = "ANY"
    v4_cidr_blocks = [var.subnet_cidr]
  }

  egress {
    description    = "Outbound access"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Отдельный диск для домена клиник.
resource "yandex_compute_disk" "clinics_disk" {
  count       = var.create_clinics ? 1 : 0
  name        = "${var.project_name}-${var.environment}-clinics-disk"
  description = "Persistent disk for clinics domain data"
  zone        = var.default_zone
  type        = var.disk_type
  size        = var.domain_disk_size_gb
}

# Отдельный диск для домена ИИ-сервисов.
resource "yandex_compute_disk" "ai_services_disk" {
  count       = var.create_ai_services ? 1 : 0
  name        = "${var.project_name}-${var.environment}-ai-services-disk"
  description = "Persistent disk for AI services domain data"
  zone        = var.default_zone
  type        = var.disk_type
  size        = var.domain_disk_size_gb
}

# Отдельный диск для финтех-домена.
resource "yandex_compute_disk" "fintech_disk" {
  count       = var.create_fintech ? 1 : 0
  name        = "${var.project_name}-${var.environment}-fintech-disk"
  description = "Persistent disk for fintech domain data"
  zone        = var.default_zone
  type        = var.disk_type
  size        = var.domain_disk_size_gb
}

# Отдельный диск для домена головного офиса.
resource "yandex_compute_disk" "head_office_disk" {
  count       = var.create_head_office ? 1 : 0
  name        = "${var.project_name}-${var.environment}-head-office-disk"
  description = "Persistent disk for head office domain data"
  zone        = var.default_zone
  type        = var.disk_type
  size        = var.domain_disk_size_gb
}

# Отдельный диск для партнерского домена.
resource "yandex_compute_disk" "partners_disk" {
  count       = var.create_partners ? 1 : 0
  name        = "${var.project_name}-${var.environment}-partners-disk"
  description = "Persistent disk for partners domain data"
  zone        = var.default_zone
  type        = var.disk_type
  size        = var.domain_disk_size_gb
}

# Отдельный диск для домена платформы данных.
resource "yandex_compute_disk" "data_platform_disk" {
  count       = var.create_data_platform ? 1 : 0
  name        = "${var.project_name}-${var.environment}-data-platform-disk"
  description = "Persistent disk for data platform metadata and demo datasets"
  zone        = var.default_zone
  type        = var.disk_type
  size        = var.domain_disk_size_gb
}

# VM домена клиник.
resource "yandex_compute_instance" "clinics_instance" {
  count       = var.create_clinics ? 1 : 0
  name        = "${var.project_name}-${var.environment}-clinics"
  hostname    = "${var.project_name}-${var.environment}-clinics"
  description = "Домен клиник: приемы, назначения и операционные процессы"
  platform_id = var.vm_platform_id
  zone        = var.default_zone

  resources {
    cores  = var.vm_cores
    memory = var.vm_memory_gb
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      type     = var.disk_type
      size     = var.boot_disk_size_gb
    }
  }

  secondary_disk {
    disk_id     = yandex_compute_disk.clinics_disk[0].id
    auto_delete = false
    device_name = "clinics"
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.future20_subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.future20_security_group.id]
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.public_ssh_key}"
  }
}

# VM домена ИИ-сервисов.
resource "yandex_compute_instance" "ai_services_instance" {
  count       = var.create_ai_services ? 1 : 0
  name        = "${var.project_name}-${var.environment}-ai-services"
  hostname    = "${var.project_name}-${var.environment}-ai-services"
  description = "Домен ИИ-сервисов: анализ медицинских данных и снимков"
  platform_id = var.vm_platform_id
  zone        = var.default_zone

  resources {
    cores  = var.vm_cores
    memory = var.vm_memory_gb
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      type     = var.disk_type
      size     = var.boot_disk_size_gb
    }
  }

  secondary_disk {
    disk_id     = yandex_compute_disk.ai_services_disk[0].id
    auto_delete = false
    device_name = "ai-services"
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.future20_subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.future20_security_group.id]
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.public_ssh_key}"
  }
}

# VM финтех-домена.
resource "yandex_compute_instance" "fintech_instance" {
  count       = var.create_fintech ? 1 : 0
  name        = "${var.project_name}-${var.environment}-fintech"
  hostname    = "${var.project_name}-${var.environment}-fintech"
  description = "Финтех-домен: счета, платежи, кредиты и банковские продукты"
  platform_id = var.vm_platform_id
  zone        = var.default_zone

  resources {
    cores  = var.vm_cores
    memory = var.vm_memory_gb
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      type     = var.disk_type
      size     = var.boot_disk_size_gb
    }
  }

  secondary_disk {
    disk_id     = yandex_compute_disk.fintech_disk[0].id
    auto_delete = false
    device_name = "fintech"
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.future20_subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.future20_security_group.id]
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.public_ssh_key}"
  }
}

# VM домена головного офиса.
resource "yandex_compute_instance" "head_office_instance" {
  count       = var.create_head_office ? 1 : 0
  name        = "${var.project_name}-${var.environment}-head-office"
  hostname    = "${var.project_name}-${var.environment}-head-office"
  description = "Домен головного офиса: HR, финансы, инвентаризация и управленческий учет"
  platform_id = var.vm_platform_id
  zone        = var.default_zone

  resources {
    cores  = var.vm_cores
    memory = var.vm_memory_gb
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      type     = var.disk_type
      size     = var.boot_disk_size_gb
    }
  }

  secondary_disk {
    disk_id     = yandex_compute_disk.head_office_disk[0].id
    auto_delete = false
    device_name = "head-office"
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.future20_subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.future20_security_group.id]
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.public_ssh_key}"
  }
}

# VM партнерского домена.
resource "yandex_compute_instance" "partners_instance" {
  count       = var.create_partners ? 1 : 0
  name        = "${var.project_name}-${var.environment}-partners"
  hostname    = "${var.project_name}-${var.environment}-partners"
  description = "Партнерский домен: фармацевтика и медицинская электроника"
  platform_id = var.vm_platform_id
  zone        = var.default_zone

  resources {
    cores  = var.vm_cores
    memory = var.vm_memory_gb
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      type     = var.disk_type
      size     = var.boot_disk_size_gb
    }
  }

  secondary_disk {
    disk_id     = yandex_compute_disk.partners_disk[0].id
    auto_delete = false
    device_name = "partners"
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.future20_subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.future20_security_group.id]
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.public_ssh_key}"
  }
}

# VM домена платформы данных.
resource "yandex_compute_instance" "data_platform_instance" {
  count       = var.create_data_platform ? 1 : 0
  name        = "${var.project_name}-${var.environment}-data-platform"
  hostname    = "${var.project_name}-${var.environment}-data-platform"
  description = "Домен платформы данных: lakehouse, каталог, витрины и портал самообслуживания"
  platform_id = var.vm_platform_id
  zone        = var.default_zone

  resources {
    cores  = var.vm_cores
    memory = var.vm_memory_gb
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      type     = var.disk_type
      size     = var.boot_disk_size_gb
    }
  }

  secondary_disk {
    disk_id     = yandex_compute_disk.data_platform_disk[0].id
    auto_delete = false
    device_name = "data-platform"
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.future20_subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.future20_security_group.id]
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.public_ssh_key}"
  }
}
