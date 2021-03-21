resource "aws_lb" "test" {
  name               = "${terraform.workspace}-${var.loadBalancerName}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public.*.id

  enable_deletion_protection = true

  tags = {
    Environment = "${terraform.workspace}"
    Name = "${terraform.workspace}-${var.loadBalancerName}"
  }
}