variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}

variable "private_key_file" {
  description = "ssh private key"
}

variable "app_disk_image" {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable "subnet_id" {
  description = "Subnets for modules"
}

variable "database_url" {
  description = "Database url"
}

variable "use_provisioners" {
  description = "Use provisioners"
}
