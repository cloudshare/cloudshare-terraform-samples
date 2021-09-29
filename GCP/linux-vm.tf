resource "google_compute_instance" "ubuntu-vm" {
  name         = "gcp-ubuntu"
  machine_type = "f1-micro"
  zone         = "us-east1-b"

  boot_disk {
    initialize_params {      
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network = "default"
  }

  scheduling {
    preemptible = true
    automatic_restart = false
  }
}
