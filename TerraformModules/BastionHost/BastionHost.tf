resource "aws_security_group" "bastion_host_gp" {
  name        = "BastionHost Security Group"
  description = "Bastion Host security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Salt "
    from_port   = 4505
    to_port     = 4506
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "${terraform.workspace}"
    Name = "${terraform.workspace}-BastionHost-SG"
      }
}

resource "aws_instance" "BastionHost" {
  ami           = "ami-013f17f36f8b1fefb"
  instance_type = "t2.medium"

  key_name = aws_key_pair.BastionHost.key_name

  associate_public_ip_address = true

  security_groups = [aws_security_group.bastion_host_gp.id]

  subnet_id = data.aws_subnet.BastionHostNet.id

  user_data = file("${path.module}/setup.sh")

  private_ip = "10.0.4.40"

  tags = {
    Environment = "${terraform.workspace}"
    Name = "${terraform.workspace}-BastionHost"
    }

  depends_on = [
      aws_key_pair.BastionHost
    ]
}

resource "aws_key_pair" "BastionHost" {
  key_name   = "${terraform.workspace}-BastionHost-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCjm+q8+H8vVG3bHUI/yXmW50k3Na5eN9I7wJdrTM9H0e3Tnrft+Xg6bH4buzmCRo082FIy77BZQUK5IOuWDSD9wjPYFYzbLj+ibSFcZLT6ATov3EY65RPMLaY8O6TnD2alosncL1camioEfUJB+IBzzVwELojd66UzT0VT30Z0XaFmiXM7OWkau1wW9Ab6IUAIs9tm0cRoBlAKtP23IhQ7ovL9WEe7CWYLt6rUsUbL0DVGCmSR9Xgmo3WagqE/PdP8upjkvoGJnAk3EiBPBM/KyX8oTDjyTXL5t0C10SYvewoIkIzshdqWoIc2vjNEkc/L3joAvervxGqRlA2s2vFR juand@DESKTOP-O461ERP"
}
