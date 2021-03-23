resource "aws_db_instance" "default" {
  allocated_storage    = 100
  engine               = "postgres"
  instance_class       = "db.t2.small"
  name                 = "${terraform.workspace}LifeProjectDatabase"
  username             = var.user
  password             = var.password
  db_subnet_group_name = var.db_subnet
  skip_final_snapshot  = true
}