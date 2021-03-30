resource "aws_security_group" "frontEndLoadSecurityGroup" {
  name        = "frontLoadBalancer Security Group"
  description = "frontLoadBalancer security group"
  vpc_id      = var.VPC_id

  ingress {
    from_port         = 0
    to_port           = 65535
    protocol          = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port         = 0
    to_port           = 65535
    protocol          = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "backEndLoadSecurityGroup" {
  name        = "backLoadBalancer Security Group"
  description = "backLoadBalancer security group"
  vpc_id      = var.VPC_id

  ingress {
    from_port         = 0
    to_port           = 65535
    protocol          = "tcp"
    cidr_blocks = [data.aws_subnet.front1.cidr_block, data.aws_subnet.front2.cidr_block]
  }

  egress {
    from_port         = 0
    to_port           = 65535
    protocol          = "tcp"
    cidr_blocks = [data.aws_subnet.back1.cidr_block, data.aws_subnet.back2.cidr_block]
  }
}

resource "aws_lb" "front_lb" {
  name               = "${terraform.workspace}-${var.loadBalancerName}"
  internal           = false
  load_balancer_type = "application"
  # security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [data.aws_subnet.front1.id, data.aws_subnet.front2.id]

  enable_deletion_protection = false

  security_groups    = [aws_security_group.frontEndLoadSecurityGroup.id]

  tags = {
    Environment = "${terraform.workspace}"
    Name = "${terraform.workspace}-${var.loadBalancerName}"
  }
}

resource "aws_lb_target_group" "front-end-machines" {
  name     = "${terraform.workspace}-front-lb-group"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.VPC_id
}

resource "aws_lb_listener" "front_end_listener" {
  load_balancer_arn = aws_lb.front_lb.arn
  port              = "3000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front-end-machines.arn
  }
}

resource "aws_lb" "back_lb" {
  name               = "${terraform.workspace}-${var.BackloadBalancerName}"
  internal           = true
  load_balancer_type = "application"
  # security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [data.aws_subnet.back1.id, data.aws_subnet.back2.id]

  enable_deletion_protection = false

  security_groups    = [aws_security_group.backEndLoadSecurityGroup.id]

  tags = {
    Environment = "${terraform.workspace}"
    Name = "${terraform.workspace}-${var.BackloadBalancerName}"
  }
}

resource "aws_lb_target_group" "back-end-machines" {
  name     = "${terraform.workspace}-back-lb-group"
  port     = 3500
  protocol = "HTTP"
  vpc_id   = var.VPC_id
}

resource "aws_lb_listener" "back_end_listener" {
  load_balancer_arn = aws_lb.back_lb.arn
  port              = "3500"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.back-end-machines.arn
  }
}
