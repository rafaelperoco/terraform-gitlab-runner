module "vm" {
  source  = "terraform-google-modules/vm/google"
  version = "~> 7.5.0"
}

module "mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "~> 7.5.0"

  project_id                = var.project_id
  region                    = var.region
  target_size               = var.target_size
  hostname                  = var.hostname
  instance_template         = module.instance_template.self_link
  min_replicas              = var.min_replicas
  subnetwork                = var.subnetwork
  subnetwork_project        = var.subnetwork_project
  distribution_policy_zones = var.distribution_policy_zones
}

module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "7.5.0"

  project_id           = var.project_id
  subnetwork           = var.subnetwork
  service_account      = var.service_account
  subnetwork_project   = var.project_id
  disk_size_gb         = var.disk_size_gb
  disk_type            = var.disk_type
  labels               = var.labels
  machine_type         = var.machine_type
  name_prefix          = var.name_prefix
  preemptible          = var.preemptible
  region               = var.region
  source_image_family  = var.source_image_family
  source_image_project = var.source_image_project
  source_image         = reverse(split("/", module.gce-advanced-container.source_image))[0]
  metadata             = merge(try(var.additional_metadata, null), { "gce-container-declaration" = module.gce-advanced-container.metadata_value })
}

module "gce-advanced-container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 3.0.0"
  container = {
    image           = var.image
    command         = var.container_command
    args            = var.container_args
    securityContext = var.container_security_context
    volumeMounts    = var.container_volume_mounts
  }
  volumes = var.container_volumes
}