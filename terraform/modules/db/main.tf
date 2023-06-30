terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

resource "random_integer" "postfix" {
  min = 100
  max = 999
}

resource "yandex_compute_instance" "db" {
  name = "reddit-db-${random_integer.postfix.result}"
  labels = {
    tags = "reddit-db"
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.db_disk_image
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    host        = yandex_compute_instance.db.network_interface.0.nat_ip_address
    user        = "ubuntu"
    agent       = false
    private_key = file(var.private_key_file)
  }

  provisioner "file" {
    source      = "${path.module}/files/mongodb.conf"
    destination = var.use_provisioners ? "/tmp/mongodb.conf" : "/dev/null"
  }

  provisioner "remote-exec" {
    script = var.use_provisioners ? "${path.module}/files/setup_mongo.sh" : "../files/empty_scrypt.sh"
  }
}
