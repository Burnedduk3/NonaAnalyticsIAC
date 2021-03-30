variable "Front_Name" {
  type = string
}

variable "key_name" {
  type = string
}

variable "vpc_id"{
  type = string
}

variable "Back_Name" {
  type = string
}

variable "LT_Front_AMI" {
    type = string
}
variable "LT_Front_Instance_Size" {
    type = string
}

variable "ASG_Front_Subnets" {
  type = list(string)
}

variable "ASG_Front_Desired_Capacity" {
  type=number
}

variable "ASG_Front_Max_Size" {
  type=number
}

variable "ASG_Front_Min_Size" {
  type=number
}

variable "ASG_Back_Subnets" {
  type = list(string)
}

variable "ASG_Back_Desired_Capacity" {
  type=number
}

variable "ASG_Back_Max_Size" {
  type=number
}

variable "ASG_Back_Min_Size" {
  type=number
}

variable "FrontTargetGroupARN" {}

variable "BackTargetGroupARN" {}
