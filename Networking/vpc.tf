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