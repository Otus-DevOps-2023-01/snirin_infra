terraform {
  backend "s3" {
    endpoint          = "storage.yandexcloud.net"
    bucket            = "otus-terraform-object-storage"
    region            = "ru-central1"
    key               = "stage-terraform.tfstate"
    dynamodb_endpoint = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gfae6au5sb54i1vhac/etnco5dm30jj3bg3p6en"
    dynamodb_table    = "state-lock-table"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
