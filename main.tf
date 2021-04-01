module "vpc" {
  source               = "./TerraformModules/Networking/"
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = false
  subnets = [
    {
      cidr_block        = "10.0.0.0/24"
      availability_zone = "us-east-1a"
      name              = "front-end-a"
      public_ip_on_launch = true
    },
    {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1b"
      name              = "front-end-b"
      public_ip_on_launch = true
    },
    {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1a"
      name              = "back-end-a"
      public_ip_on_launch = false
    },
    {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-1b"
      name              = "back-end-b"
      public_ip_on_launch = false
    },
    {
      cidr_block        = "10.0.4.0/28"
      availability_zone = "us-east-1b"
      name              = "database-1"
      public_ip_on_launch = false
    },
    {
      cidr_block        = "10.0.4.16/28"
      availability_zone = "us-east-1a"
      name              = "database-2"
      public_ip_on_launch = false
    },
    {
      cidr_block        = "10.0.4.32/28"
      availability_zone = "us-east-1a"
      name              = "bastion-host"
      public_ip_on_launch = true
    }
  ]
}
module "BastionHost" {
  source     = "./TerraformModules/BastionHost"
  vpc_id     = module.vpc.vpc_id
  depends_on = [module.vpc]
}

module "front_load_balancer" {
  source               = "./TerraformModules/LoadBalancing/"
  loadBalancerName     = "Front-load-balancer"
  BackloadBalancerName = "Back-end-balancer"
  VPC_id               = module.vpc.vpc_id
  depends_on           = [module.BastionHost]
}

module "Database" {
  source     = "./TerraformModules/RDS"
  user       = var.RDS_user
  password   = var.RDS_password
  db_subnet  = module.vpc.aws_db_subnet
  vpc_id = module.vpc.vpc_id
  ingress_cidr = ["10.0.2.0/24", "10.0.3.0/24"]
  depends_on = [module.vpc]
}

module "Project_ASG" {
  source                     = "./TerraformModules/AutoScalingGroup"
  Front_Name                 = "front-end-machines"
  Back_Name                  = "back-end-machines"
  LT_Front_AMI               = "ami-013f17f36f8b1fefb"
  LT_Front_Instance_Size     = "t2.small"
  ASG_Front_Subnets          = [module.vpc.VPC_Subnets_id[0], module.vpc.VPC_Subnets_id[1]]
  ASG_Front_Desired_Capacity = 2
  ASG_Front_Max_Size         = 100
  ASG_Front_Min_Size         = 1
  ASG_Back_Subnets           = [module.vpc.VPC_Subnets_id[2], module.vpc.VPC_Subnets_id[3]]
  ASG_Back_Desired_Capacity  = 2
  ASG_Back_Max_Size          = 100
  ASG_Back_Min_Size          = 1
  key_name = module.BastionHost.key_name
  vpc_id = module.vpc.vpc_id
  BackTargetGroupARN = module.front_load_balancer.TG_Back_Group_ARN
  FrontTargetGroupARN = module.front_load_balancer.TG_Front_Group_ARN
  depends_on = [module.BastionHost]
}
