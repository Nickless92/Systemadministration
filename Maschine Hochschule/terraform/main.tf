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


resource "google_compute_instance" "vm_instance2" {
  name         = "knoten2"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "terraform-network"
    access_config {
    }
  }
}


resource "google_compute_instance" "vm_instance3" {
  name         = "knoten3"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "terraform-network"
    access_config {
    }
  }
}


resource "google_compute_firewall" "rules" {
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


#  source_tags = ["foo"]
#  target_tags = ["web"]
}



#data "template_file" "init" {
 # template = "${file("/home/dominic/Dokumente/Systemadministration/Maschine Hochschule/terraform/backends.tftpl")}"
  #vars = {
   # consul_address = "${aws_instance.consul.private_ip}"
  #}
#}




  module "cloud-nat" {
  source  = "terraform-google-modules/cloud-nat/google"
  version = "2.1.0"
  # insert the 4 required variables here
  
}

