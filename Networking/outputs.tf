output "vpc_arn" {
  value = aws_vpc.mainVPC.arn
}

output "vpc_id" {
  value = aws_vpc.mainVPC.id
}

output "vpc_cidr_block" {
  value = aws_vpc.mainVPC.cidr_block
}