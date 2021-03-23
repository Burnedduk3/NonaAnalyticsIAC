variable "user" {
    sensitive = true
    type=string
}

variable "password" {
    sensitive = true
    type=string
}

variable "db_subnet"{}