variable "name"{
    type = string
    description = "The name of the resource"
}

variable "startup_script"{
    type = string
    description = "The startup script"
}

variable "zone"{
    type = string
    description = "The zone"
}

variable "region"{
    type = string
    description = "The region in which the resources are created in"
}

variable "project"{
    type = string
    description = "The project in which the resources are created in"
}

variable "autoscaler"{
    type = any
    description = "The autoscaler"
}

variable "target_size"{
    type = number
    description = "The target size"
}


variable "named_port"{
    type = any
    description = "The named port configuration"
}

variable "machine_type"{
    type = string
    description = "The machine type to create"
}

variable "disk"{
    type = any
    description = "The Disk configuration"
}

variable "healthy_threshold"{
    type = number
    description = " A so-far unhealthy instance will be marked healthy after this many consecutive successes. The default value is 2."
}

variable "unhealthy_threshold"{
    type = number
    description = "A so-far healthy instance will be marked unhealthy after this many consecutive failures. The default value is 10."
}
