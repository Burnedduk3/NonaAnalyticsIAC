module "vpc" {
  source = "./vpc/"
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = false
  subnets = [
    {
      cidr_block = "10.0.0.0/24"
      availability_zone = "us-east-1a"
      name = "front-end-a"
    },
    {
      cidr_block = "10.0.1.0/24"
      availability_zone = "us-east-1b"
      name = "front-end-b"
    },
    {
      cidr_block = "10.0.2.0/24"
      availability_zone = "us-east-1a"
      name = "back-end-a"
    },
    {
      cidr_block = "10.0.3.0/24"
      availability_zone = "us-east-1b"
      name = "back-end-b"
    }
  ]
}