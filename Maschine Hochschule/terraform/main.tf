terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("ecstatic-pod-334509-7bbcb6d3e043.json")

  project = "ecstatic-pod-334509"
  region  = "europe-west3"
  zone    = "europe-west3-b"
}



resource "google_compute_instance" "vm_instance" {
  allow_stopping_for_update = true
  count			                = 3
  machine_type              = "f1-micro"
  name                      = "knoten-${count.index}"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  metadata = {
    ssh-keys = "bruno:${file("~/.ssh/id_rsa.pub")}"
  }


  network_interface {
    network = "terraform-network"
    access_config {
    }
  }
}

resource "google_compute_firewall" "ssh" {
  project     = "ecstatic-pod-334509"
  name        = "ssh-firewall"
  network     = "terraform-network"
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol  = "tcp"
    ports     = ["22"]
  }

  allow {
    protocol  = "icmp"
  }
}

resource "google_compute_firewall" "k3s" {
  project     = "ecstatic-pod-334509"
  name        = "k3s"
  network     = "terraform-network"

  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }

}


# generate inventory file for Ansible
resource "local_file" "gcp_hosts_cfg" {
  content = templatefile("${path.module}/inventory.tftpl",
    {
      gcp_nodes =google_compute_instance.vm_instance[*].network_interface[0].access_config[0].nat_ip
    }
  )
  file_permission = 660
  filename = "${path.module}/gcp_hosts.cfg"
}
