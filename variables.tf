variable "subnetwork" {
  description = "The name of the subnetwork create this instance in."
  default     = ""
}

variable "subnetwork_project" {
  description = "The project of the subnetwork."
  default     = ""
}

variable "service_account" {
  description = "The service account to be used by the instance."
  default     = ""
}

variable "project_id" {
  description = "The project to create the instance in."
  default     = ""
}

variable "target_size" {
  description = "The number of nodes to create."
  default     = "1"
}

variable "region" {
  description = "The region to create the instance in."
  default     = "us-central1"
}

variable "zone" {
  description = "The zone to create the instance in."
  default     = "europe-west1-b"
}

variable "hostname" {
  description = "The hostname to use for the instance."
  default     = ""
}

variable "image" {
  description = "The image to use for the instance."
  default     = "ubuntu-1604-xenial-v20180208"
}

variable "min_replicas" {
  description = "The minimum number of replicas to maintain."
  default     = "1"
}

variable "disk_size_gb" {
  description = "The size of the disk to create."
  default     = "100"
}

variable "disk_type" {
  description = "The type of disk to create."
  default     = "pd-standard"
}

variable "labels" {
  description = "The labels to apply to the instance."
  default     = ""
}

variable "machine_type" {
  description = "The machine type to use for the instance."
  default     = "n1-standard-1"
}

variable "name_prefix" {
  description = "The prefix to use for the instance name."
  default     = "terraform-test"
}

variable "preemptible" {
  description = "Whether the instance is preemptible."
  default     = "false"

}

variable "source_image_family" {
  description = "The source image family to use for the instance."
}

variable "source_image_project" {
  description = "The source image project to use for the instance."
}

variable "metadata" {
  description = "The metadata to apply to the instance."
  default     = ""
}

variable "additional_metadata" {
  description = "The additional metadata to apply to the instance."
  default     = {}
}

variable "container_args" {
  description = "The container args to apply to the instance."
  default     = []
}

variable "container_volumes" {
  description = "The container volumes to apply to the instance."
}

variable "container_volume_mounts" {
  description = "The container volume mounts to apply to the instance."
}

variable "container_security_context" {
  description = "The container security context to apply to the instance."
}

variable "container_disk_size_gb" {
  description = "The container disk size to apply to the instance."
}

variable "distribution_policy_zones" {
  description = "The distribution policy zones to apply to the instance."
}

variable "container_command" {
  description = "The container command to apply to the instance."
}