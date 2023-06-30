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

resource "yandex_compute_instance" "app" {

  name = "reddit-app-${random_integer.postfix.result}"
  labels = {
    tags = "reddit-app"
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.app_disk_image
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
    host        = yandex_compute_instance.app.network_interface.0.nat_ip_address
    user        = "ubuntu"
    agent       = false
    private_key = file(var.private_key_file)
  }

  provisioner "file" {
    content     = templatefile("${path.module}/files/puma.service.tmpl", { database_url = var.database_url })
    destination = var.use_provisioners ? "/tmp/puma.service" : "/dev/null"
  }

  provisioner "remote-exec" {
    script = var.use_provisioners ? "${path.module}/files/deploy.sh" : "../files/empty_scrypt.sh"
  }
}
