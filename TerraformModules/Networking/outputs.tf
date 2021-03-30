output "vpc_arn" {
  value = aws_vpc.mainVPC.arn
}

output "vpc_id" {
  value = aws_vpc.mainVPC.id
}

output "vpc_cidr_block" {
  value = aws_vpc.mainVPC.cidr_block
}

output "aws_db_subnet" {
  value = aws_db_subnet_group.db_subnet.id
}

output "VPC_Subnets_id" {
  value = aws_subnet.subnet[*].id
}