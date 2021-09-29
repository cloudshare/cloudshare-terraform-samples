resource "google_compute_instance" "windows-vm" {
  name         = "gcp-windows"
  machine_type = "f1-micro"
  zone         = "us-east1-b"

  boot_disk {
    initialize_params {      
      image = "windows-cloud/windows-2012-r2"
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
