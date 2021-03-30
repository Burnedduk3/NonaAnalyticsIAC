resource "aws_security_group" "front_host_gp" {
  name        = "${terraform.workspace}-FrontEnd-Security-Group"
  description = "FrontEnd Host security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.4.32/28"]
  }

  ingress {
    description = "Salt "
    from_port   = 4505
    to_port     = 4506
    protocol    = "tcp"
    cidr_blocks = ["10.0.4.32/28"]
  }

  ingress {
    description = "react-app"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3500
    to_port     = 3500
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24", "10.0.3.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = terraform.workspace
    Name = "${terraform.workspace}-Front-End-SG"
  }
}

resource "aws_security_group" "back_host_gp" {
  name        = "${terraform.workspace}-BackEnd-Security-Group"
  description = "BackEnd Host security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.4.32/28"]
  }

  ingress {
    description = "Salt "
    from_port   = 4505
    to_port     = 4506
    protocol    = "tcp"
    cidr_blocks = ["10.0.4.32/28"]
  }

  ingress {
    description = "apollo-server app"
    from_port   = 3500
    to_port     = 3500
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24", "10.0.3.0/24"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.4.0/28", "10.0.4.16/28"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = terraform.workspace
    Name = "${terraform.workspace}-Front-End-SG"
  }
}

resource "aws_launch_template" "launchTemplateFront" {
  name_prefix   = "${terraform.workspace}-${var.Front_Name}"
  image_id      = var.LT_Front_AMI
  instance_type = var.LT_Front_Instance_Size
  key_name = var.key_name
  user_data = filebase64("${path.module}/minions.sh")
  vpc_security_group_ids = [aws_security_group.front_host_gp.id]
}

resource "aws_launch_template" "launchTemplateBackend" {
  name_prefix   = "${terraform.workspace}-${var.Back_Name}"
  image_id      = var.LT_Front_AMI
  instance_type = var.LT_Front_Instance_Size
  key_name = var.key_name
  user_data = filebase64("${path.module}/minions.sh")
  vpc_security_group_ids = [aws_security_group.back_host_gp.id]
}

resource "aws_autoscaling_group" "Front-AutoScaling-group" {
  vpc_zone_identifier = var.ASG_Front_Subnets
  desired_capacity   = var.ASG_Front_Desired_Capacity
  max_size           = var.ASG_Front_Max_Size
  min_size           = var.ASG_Front_Min_Size

  launch_template {
    id      = aws_launch_template.launchTemplateFront.id
    version = "$Latest"
  }

    tags = [{
      Environment = "${terraform.workspace}"
      Name = "${terraform.workspace}${var.Front_Name}"
  }]
}

resource "aws_autoscaling_group" "Back-AutoScaling-group" {
  vpc_zone_identifier = var.ASG_Back_Subnets
  desired_capacity   = var.ASG_Back_Desired_Capacity
  max_size           = var.ASG_Back_Max_Size
  min_size           = var.ASG_Back_Min_Size

  launch_template {
    id      = aws_launch_template.launchTemplateBackend.id
    version = "$Latest"
  }
  tags = [{
    Environment = "${terraform.workspace}"
    Name = "${terraform.workspace}-${var.Back_Name}"
  }]
}

resource "aws_autoscaling_attachment" "asg_attachment_Front" {
  autoscaling_group_name = aws_autoscaling_group.Front-AutoScaling-group.id
  alb_target_group_arn   = var.FrontTargetGroupARN
}

resource "aws_autoscaling_attachment" "asg_attachment_Back" {
  autoscaling_group_name = aws_autoscaling_group.Back-AutoScaling-group.id
  alb_target_group_arn   = var.BackTargetGroupARN
}

