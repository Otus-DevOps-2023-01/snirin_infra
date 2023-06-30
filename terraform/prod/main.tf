terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

module "db" {
  source           = "../modules/db"
  public_key_path  = var.public_key_path
  private_key_file = var.private_key_file
  db_disk_image    = var.db_disk_image
  subnet_id        = var.subnet_id
  use_provisioners = true
}

module "app" {
  source           = "../modules/app"
  public_key_path  = var.public_key_path
  private_key_file = var.private_key_file
  app_disk_image   = var.app_disk_image
  subnet_id        = var.subnet_id
  database_url     = module.db.external_ip_address_db
  use_provisioners = true
}
