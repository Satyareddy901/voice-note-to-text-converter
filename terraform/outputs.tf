# outputs.tf — values printed after terraform apply

output "vm_ip" {
  description = "The STATIC public IP of your VM. Point your DNS here."
  value       = google_compute_address.static_ip.address
}

output "app_url" {
  description = "Open this in your browser to reach your voice app"
  value       = "http://${google_compute_address.static_ip.address}"
}

output "ssh_command" {
  description = "SSH into the VM to check Docker logs"
  value       = "gcloud compute ssh voice-app-vm --zone=${var.zone}"
}

output "service_account_email" {
  description = "Service account used by the VM"
  value       = google_service_account.voice_sa.email
}