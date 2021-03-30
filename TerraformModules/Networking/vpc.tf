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
    map_public_ip_on_launch = var.subnets[count.index].public_ip_on_launch
  tags = {
        "Environment" = terraform.workspace
        "Name" = "${terraform.workspace}-${var.subnets[count.index].name}"
    }
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "db_subnet"

  subnet_ids = [
    aws_subnet.subnet[4].id,
    aws_subnet.subnet[5].id,
  ]

    tags = {
        "Environment" = terraform.workspace
        "Name" = "${terraform.workspace}-db-group"
    }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.mainVPC.id

  tags = {
    Name = "main"
  }
}

resource "aws_eip" "Natgateway-elastic-ip" {
  vpc              = true
}

resource "aws_nat_gateway" "NatGateway" {
  allocation_id = aws_eip.Natgateway-elastic-ip.id
  subnet_id     =     aws_subnet.subnet[6].id
}

resource "aws_default_route_table" "route_table" {
  default_route_table_id = aws_vpc.mainVPC.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${terraform.workspace}-public-subnet"
  }
}

resource "aws_route_table" "r" {
  vpc_id     = aws_vpc.mainVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NatGateway.id
  }

  tags = {
    Name = "${terraform.workspace}-private-subnet"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet[0].id
  route_table_id = aws_default_route_table.route_table.id
}

resource "aws_route_table_association" "ab" {
  subnet_id      = aws_subnet.subnet[1].id
  route_table_id = aws_default_route_table.route_table.id
}

resource "aws_route_table_association" "ac" {
  subnet_id      = aws_subnet.subnet[2].id
  route_table_id = aws_route_table.r.id
}

resource "aws_route_table_association" "ad" {
  subnet_id      = aws_subnet.subnet[3].id
  route_table_id = aws_route_table.r.id
}

resource "aws_route_table_association" "ae" {
  subnet_id      = aws_subnet.subnet[6].id
  route_table_id = aws_default_route_table.route_table.id
}
