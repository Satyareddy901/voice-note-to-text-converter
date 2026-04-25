# variables.tf — declarations only, no real values here

variable "project_id" {
  description = "Your GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "asia-south1"
}

variable "zone" {
  description = "GCP zone within the region"
  type        = string
  default     = "asia-south1-a"
}

variable "machine_type" {
  description = "VM machine type. e2-medium = 2vCPU 4GB RAM"
  type        = string
  default     = "e2-medium"
}