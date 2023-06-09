variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}

variable "private_key_file" {
  description = "ssh private key"
}

variable "db_disk_image" {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable "subnet_id" {
  description = "Subnets for modules"
}

variable "use_provisioners" {
  description = "Use provisioners"
}
