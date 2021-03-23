resource "aws_vpc" "mainVPC" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = var.enable_dns_support
    enable_dns_hostnames = var.enable_dns_hostnames

    tags = {
      "Environment" = terraform.workspace
      "Name" = "${terraform.workspace}-life-project-vpc"
    }
}

resource "aws_subnet" "subnet" {
    count = "${length(var.subnets)}"
    vpc_id     = aws_vpc.mainVPC.id
    cidr_block = "${var.subnets[count.index].cidr_block}"
    availability_zone = "${var.subnets[count.index].availability_zone}"

    tags = {
        "Environment" = terraform.workspace
        "Name" = "${terraform.workspace}-${var.subnets[count.index].name}"  
    }
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "main"

  subnet_ids = [
    aws_subnet.subnet[4].id,
    aws_subnet.subnet[5].id,
  ]

    tags = {
        "Environment" = terraform.workspace
        "Name" = "${terraform.workspace}-db-group"  
    }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.mainVPC.id

  tags = {
    "Name" = "${terraform.workspace}-internet-gateway"  
  }
}

resource "aws_default_route_table" "route_table" {
  default_route_table_id = aws_vpc.mainVPC.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }


  tags = {
    "Name" = "${terraform.workspace}-internet-gateway"  
  }
}