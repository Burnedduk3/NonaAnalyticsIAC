variable "cidr_block" {}

variable "enable_dns_support" {}

variable "enable_dns_hostnames" {}

variable "subnets"{
    type = list(object({
        cidr_block = string
        availability_zone = string
        name = string
        public_ip_on_launch = bool
    }))
}
