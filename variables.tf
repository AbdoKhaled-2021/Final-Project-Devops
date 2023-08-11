variable "region"{
    type = string
}

variable "cidr"{
    type = string
}

variable "private-us-east-1a-cidr"{
    type = string
}

variable "private-us-east-1b-cidr"{
    type = string
}

variable "public-us-east-1a-cidr"{
    type = string
}

variable "public-us-east-1b-cidr"{
    type = string
}

variable "instance-type"{
    type = string
}

variable "capacity_type"{
    type = string
}

variable "ecr_name"{
    type = any
}

variable "tags"{
    type = map(string)
}