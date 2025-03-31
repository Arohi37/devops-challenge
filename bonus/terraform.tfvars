name = "devops"
project = "disco-ivy-454320-u0"
region = "us-central1"

autoscaler=[{
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 60
    target = 0.5
}]

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

zone = "us-central1-a"

named_port = [{
    name = "customhttp"
    port = 8888
}]

disk = [{
    source_image = "ubuntu-os-cloud/ubuntu-2004-lts"
    auto_delete       = true
    boot              = true
}]

machine_type = "e2-medium"

healthy_threshold = 2
unhealthy_threshold = 10

target_size = 1