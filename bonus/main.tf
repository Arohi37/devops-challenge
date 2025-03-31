provider "google" {
  project = var.project
  region  = var.region
}

resource "google_compute_autoscaler" "autoscaler" {
  provider = google

  name   = "${var.name}-autoscaler"
  zone   = var.zone
  target = google_compute_instance_group_manager.appserver.id

  dynamic "autoscaling_policy"{
    for_each = var.autoscaler
    content{
      max_replicas    = autoscaling_policy.value.max_replicas
      min_replicas    = autoscaling_policy.value.min_replicas
      cooldown_period = autoscaling_policy.value.cooldown_period
      cpu_utilization {
        target = autoscaling_policy.value.target
      }
    }
  }
  
}

resource "google_compute_health_check" "autohealing" {
  provider = google
  name                = "${var.name}-health-check"
  
  healthy_threshold   = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold

  http_health_check {
    request_path = "/healthz"
    port         = "8080"
  }
}

resource "google_compute_instance_group_manager" "appserver" {
  name = "${var.name}-appserver"

  zone               = var.zone

  version {
    instance_template  = google_compute_instance_template.appserver-template.self_link_unique
  }

  base_instance_name = "${var.name}-instance"

  target_size  = var.target_size

  dynamic "named_port" {
    for_each = var.named_port
    content {
    name = named_port.value.name
    port = named_port.value.port
  }
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 300
  }
}



resource "google_compute_instance_template" "appserver-template" {
  provider = google

  name           = "${var.name}-instance-template"
  machine_type   = var.machine_type
  can_ip_forward = false

  tags = ["foo", "bar"]

  dynamic "disk"{
    for_each = var.disk
    content{
      source_image = disk.value.source_image  
      auto_delete       = disk.value.auto_delete
      boot              = disk.value.boot
    }
  }
  

  metadata_startup_script = var.startup_script
  network_interface {
    network = "default"
    access_config {}
  }


  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
