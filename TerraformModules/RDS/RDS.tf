resource "aws_db_instance" "default" {
  allocated_storage    = 100
  engine               = "postgres"
  instance_class       = "db.t2.small"
  name                 = "${terraform.workspace}LifeProjectDatabase"
  username             = var.user
  password             = var.password
  db_subnet_group_name = var.db_subnet
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
}

resource "aws_security_group" "db_security_group" {
  name        = "RDS Security Group"
  description = "RDS Host security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 5432
    protocol = "tcp"
    to_port = 5432
    cidr_blocks = var.ingress_cidr
  }
}
