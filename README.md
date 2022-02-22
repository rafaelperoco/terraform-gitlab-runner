# terraform-gitlab-runner
Terraform code to create GitLab Runners on Google Cloud Platform

## How to use:
1. [Create a Google Cloud Platform service account](https://cloud.google.com/iam/docs/creating-managing-service-accounts)
2. Get the service account key using this command:
```shell
cat service-account.json | jq -r '.private_key'
```
and change the YOUR_GOOGLE_APPLICATION_CREDENTIALS_KEY to it.
This key will be used to allow the Runner to access the Google Storage bucket.

3. Create your terraform.tfvars file with the following variables:
terraform.tfvars
```terraform
hostname    = "gitlab-runner"
project_id  = "your-google-project-id"
region      = "us-east1"
target_size = 1
zone        = "us-east1-b"

subnetwork         = "your-subnetwork-name"
subnetwork_project = "your-google-project-id"
service_account = {
  email = "gitlab-service-account@your-google-project-id.iam.gserviceaccount.com"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform"
  ]
}

disk_size_gb = 100
disk_type    = "pd-ssd"
labels = {
  "gitlab-runner" = "true"
}
machine_type         = "e2-highcpu-8"
name_prefix          = "gitlab-runner"
preemptible          = true
source_image_family  = "cos-stable"
source_image_project = "cos-cloud"
image                = "registry.gitlab.com/gitlab-org/gitlab-runner"

additional_metadata = {
  "google-logging-enabled" = "true"
  "startup-script" = <<EOT
#!/bin/bash
mkdir -p /etc/gitlab-runner
cat > /etc/gitlab-runner/config.toml <<EOF
concurrent = 1
check_interval = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name     = "your-gitlab-runner-name"
  url      = "https://gitlab.com/"
  token    = "YOUR_GITLAB_RUNNER_SECRET_TOKEN"
  executor = "docker"
  [runners.docker]
    tls_verify    = false
    image         = "docker:19.03.12"
    privileged    = true
    disable_cache = false
    volumes       = ["/var/run/docker.sock:/var/run/docker.sock"]
    shm_size      = 0
    disable_entrypoint_overwrite = false
  [runners.cache]
    Type = "gcs"
    Path = "gitlab"
    Shared = true
    [runners.cache.gcs]
      AccessID = "gitlab-service-account@your-google-project-id.iam.gserviceaccount.com"
      BucketName = "name-of-your-gitlab-runner-bucket-for-cache"
      PrivateKey = "YOUR_GOOGLE_APPLICATION_CREDENTIALS_KEY"
EOF
    docker run gitlab/gitlab-runner register --config /etc/gitlab-runner/config.toml
EOT
}

container_command = [
  "gitlab-runner", 
  "run"
]

container_volume_mounts = [
  {
    mountPath = "/etc/gitlab-runner"
    name      = "config"
    readOnly  = true
  },
  {
    mountPath = "/var/run/docker.sock"
    name      = "docker"
    readOnly  = false
  }
]

container_volumes = [
  {
    name = "config"
    hostPath = {
      path = "/etc/gitlab-runner"
    }
  },
  {
    name = "docker"
    hostPath = {
      path = "/var/run/docker.sock"
    }
  }
]

container_security_context = {
  privileged : true
}

container_disk_size_gb = 100

distribution_policy_zones = [
  "us-east1-b"
]
```

4. Initialize the Terraform state with the following command:
```shell
terraform init
```
5. Apply the Terraform configuration with the following command:
```shell
terraform apply
```