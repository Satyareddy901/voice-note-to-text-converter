resource "google_compute_instance" "vm" {
  name         = "voice-app-vm"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash

    apt-get update
    apt-get install -y docker.io

    systemctl start docker
    systemctl enable docker

    # Pull from Docker Hub
    docker pull <your-dockerhub-username>/voice-app:latest

    # Run container
    docker run -d -p 80:8085 <your-dockerhub-username>/voice-app:latest
}
resource "google_project_iam_member" "speech_access" {
  project = var.project_id
  role    = "roles/speech.client"
  member  = "serviceAccount:${google_service_account.voice_sa.email}"
}