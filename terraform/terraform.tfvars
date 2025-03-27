name         = "test-devops"
machine_type = "e2-medium"
zone         = "us-central1-a"
image = "ubuntu-os-cloud/ubuntu-2204-lts"
ip_cidr_range = "10.2.0.0/16"
region        = "us-central1"
source_ranges = ["71.179.235.193","0.0.0.0/0"]
startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y python3 python3-pip

    # Create the Flask app
    cat <<EOF > /home/ubuntu/app.py
    from flask import Flask
    app = Flask(__name__)

    @app.route('/')
    def hello():
        return "DevOps Challenge!"

    if __name__ == "__main__":
        app.run(host="0.0.0.0", port=80)
    EOF

    pip3 install flask
    nohup python3 /home/ubuntu/app.py &
  EOT

allow = [{
    protocol = "tcp"
    ports = ["80"]
},
{
    protocol = "tcp"
    ports = ["22"]
}]

conditions = [{
    display_name = "VM CPU usage > 80%"
    filter     = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\""
    duration   = "60s"
    comparison = "COMPARISON_GT"
    threshold_value = 0.8
    alignment_period   = "60s"
    per_series_aligner = "ALIGN_MEAN"
}]

combiner = "OR"

http_check = [{
    path = "/"
    port = 80
}]

timeout = "60s"
period = "60s"