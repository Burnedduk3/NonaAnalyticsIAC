variable "user" {
    sensitive = true
    type=string
}

variable "password" {
    sensitive = true
    type=string
}

variable "db_subnet"{}

variable "vpc_id" {}

variable "ingress_cidr" {
    type = list(string)
}
