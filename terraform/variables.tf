variable "service_account_key_file" {
  description = "key .json"
}
variable "cloud_id" {
  description = "Cloud"
}
variable "folder_id" {
  description = "Folder"
}
variable "zone" {
  description = "Zone"
  default     = "ru-central1-a"
}
variable "access_key" {
  default = "Access key"
}
variable "secret_key" {
  default = "Secret key"
}
variable "bucket_name" {
  description = "Bucket name"
}
