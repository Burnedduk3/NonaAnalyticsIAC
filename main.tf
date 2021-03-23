module "vpc" {
  source = "./TerraformModules/Networking/"
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
    },
    {
      cidr_block = "10.0.4.0/28"
      availability_zone = "us-east-1b"
      name = "database-1"
    },
    {
      cidr_block = "10.0.4.16/28"
      availability_zone = "us-east-1a"
      name = "database-2"
    },
    {
      cidr_block = "10.0.4.32/28"
      availability_zone = "us-east-1a"
      name = "bastion-host"
    }
  ]
}

module "front_load_balancer" {
  source = "./TerraformModules/LoadBalancing/"
  loadBalancerName = "Front-load-balancer"
  BackloadBalancerName = "Back-end-balancer"
  VPC_id = module.vpc.vpc_id
  depends_on = [module.vpc]
}

module "BastionHost" {
  source = "./TerraformModules/BastionHost"
  vpc_id = module.vpc.vpc_id
  depends_on = [module.vpc]
}

module "Database" {
  source = "./TerraformModules/RDS"
  user = var.RDS_user
  password = var.RDS_password
  db_subnet = module.vpc.aws_db_subnet
  depends_on = [module.vpc]
}