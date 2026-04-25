
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# ─────────────────────────────────────────────────
# FIX 1: Reserve a STATIC external IP so it never
# changes when the VM restarts
# ─────────────────────────────────────────────────
resource "google_compute_address" "static_ip" {
  name   = "voice-app-static-ip"
  region = var.region
}


# FIX 4: Define the service account that the
# google_project_iam_member resource references

resource "google_service_account" "voice_sa" {
  account_id   = "voice-app-sa"
  display_name = "Voice App Service Account"
  project      = var.project_id
}

# Give the SA permission to call Speech-to-Text API

resource "google_project_iam_member" "speech_access" {
  project = var.project_id
  role    = "roles/speech.client"
  member  = "serviceAccount:${google_service_account.voice_sa.email}"
}


# FIX 5: Firewall rule to allow HTTP on port 80
# Without this, your app is unreachable even with
# a public IP — GCP blocks all inbound by default


resource "google_compute_firewall" "allow_http" {
  name    = "voice-app-allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["voice-app"]
}

# Allow SSH so you can debug the VM if needed
resource "google_compute_firewall" "allow_ssh" {
  name    = "voice-app-allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["voice-app"]
}


# THE VM — all 5 bugs fixed

resource "google_compute_instance" "vm" {
  name         = "voice-app-vm"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
      type  = "pd-balanced"
    }
  }

  network_interface {
    network = "default"

    access_config {
      # FIX 1: bind the static IP instead of a random dynamic one
      nat_ip = google_compute_address.static_ip.address
    }
  }

  # FIX 4: attach the service account so the VM can call GCP APIs
  service_account {
    email  = google_service_account.voice_sa.email
    scopes = ["cloud-platform"]
  }

  # FIX 5: tag must match the firewall rule's target_tags
  tags = ["voice-app"]

  # FIX 2: correct attribute — metadata block, not metadata_startup_script
  metadata = {
    startup-script = <<-SCRIPT
      #!/bin/bash
      set -euo pipefail

      # Log everything so you can debug with:
      # gcloud compute instances get-serial-port-output voice-app-vm
      exec > /var/log/startup.log 2>&1

      echo "=== Starting setup at $(date) ==="

      apt-get update -y
      apt-get install -y docker.io

      systemctl start docker
      systemctl enable docker

      # Wait for Docker to be ready
      sleep 5

      # Pull from Docker Hub
      docker pull satyareddy9/voice-app:latest

      # Stop old container if it exists (safe on first boot)
      docker stop voice-app 2>/dev/null || true
      docker rm   voice-app 2>/dev/null || true

      # Run container: your app listens on 8085 inside,
      # we expose it on port 80 of the host VM
      docker run -d \
        --name voice-app \
        --restart always \
        -p 80:8085 \
        satyareddy9/voice-app:latest

      echo "=== Setup done at $(date) ==="
    SCRIPT
  }

  labels = {
    app = "voice-converter"
    env = "prod"
  }

  # FIX 3: this closing brace was missing in your original code
}