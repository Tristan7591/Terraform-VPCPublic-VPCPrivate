variable "az"{
    description = "az location"
    default = ["us-west-2a"]
}

variable "region"{
    description = "region location"
    default = ["us-west-2"]
}

variable "asn"{
    description = "amazon side asn"
    type = number
    default = 64512
}