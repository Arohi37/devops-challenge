variable "name" {
  type        = string
  description = "Name of the resources"
}

variable "machine_type"{
    type = string
    description = "The machine type to create"
}

variable "zone"{
    type = string
    description = "The zone that the machine should be created in"
}

variable "image"{
    type = string
    description = "The image from which to initialize the boot disk."
}

variable "startup_script"{
    type = string
    description = "The startup script"
}

variable "ip_cidr_range"{
    type = string
    description = "The range of internal addresses that are owned by this subnetwork."
}

variable "region"{
    type = string
    description = " The GCP region for this subnetwork."
}

variable "allow"{
    type = any
    description = "The list of ALLOW rules specified by this firewall. "
}

variable "source_ranges"{
    type = list(string)
    description = "If source ranges are specified, the firewall will apply only to traffic that has source IP address in these ranges"

}

variable "conditions"{
    type = any
    description = "A list of conditions for the policy. The conditions are combined by AND or OR according to the combiner field"
}

variable "combiner"{
    type = string
    description = " How to combine the results of multiple conditions to determine if an incident should be opened."
}

variable "http_check"{
    type = any
    description = "Contains information needed to make an HTTP or HTTPS check. "
}

variable "timeout"{
    type = string
    description = "The maximum amount of time to wait for the request to complete"
}

variable "period"{
    type = string
    description = "How often, in seconds, the uptime check is performed."
}