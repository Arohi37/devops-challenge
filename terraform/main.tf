resource "google_compute_instance" "vm_instance" {
  name         = "${var.name}-instance"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = google_compute_network.custom-test.id
    subnetwork = google_compute_subnetwork.network-with-private-secondary-ip-ranges.id
    access_config {}
  }

  metadata_startup_script = var.startup_script

}

resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = "${var.name}-subnetwork"
  ip_cidr_range = var.ip_cidr_range
  region        = var.region
  network       = google_compute_network.custom-test.id

}

resource "google_compute_network" "custom-test" {
  name                    = "${var.name}-network"
  auto_create_subnetworks = false
}

resource "google_compute_firewall" "test-firewall" {
  name    = "${var.name}-firewall"
  network = google_compute_network.custom-test.name

  
  dynamic "allow"{
    for_each = var.allow
    content{
       protocol = lookup(allow.value,"protocol", null)
      ports = lookup(allow.value,"ports",null)
    }
   
  }
  source_ranges = var.source_ranges
}

resource "google_monitoring_uptime_check_config" "flask_uptime" {
  display_name = "${var.name}-flask-uptime-check"

  monitored_resource {
    type = "uptime_url"
    labels = {
      host       = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
    }
  }

  dynamic "http_check" {
    for_each = var.http_check
    content { 
    path = http_check.value.path
    port = http_check.value.port
  }
  }

  timeout = var.timeout
  period  = var.period

}

resource "google_monitoring_alert_policy" "high_cpu_alert" {
  display_name = "${var.name}-High CPU Usage on Flask VM"

  combiner = var.combiner

  dynamic "conditions" {
    for_each = var.conditions
    content {
    display_name = conditions.value.display_name
    condition_threshold {
      filter     = conditions.value.filter
      duration   = conditions.value.duration
      comparison = conditions.value.comparison
      threshold_value = conditions.value.threshold_value

    aggregations {
      alignment_period   = conditions.value.alignment_period
      per_series_aligner = conditions.value.per_series_aligner
    }
    }
  }
  }
  

  notification_channels = []
  enabled               = true
}