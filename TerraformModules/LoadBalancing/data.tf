data "aws_subnet" "front1" {
  filter {
    name   = "tag:Name"
    values = ["${terraform.workspace}-front-end-a"]
  }
}

data "aws_subnet" "front2" {
  filter {
    name   = "tag:Name"
    values = ["${terraform.workspace}-front-end-b"]
  }
}

data "aws_subnet" "back1" {
  filter {
    name   = "tag:Name"
    values = ["${terraform.workspace}-back-end-a"]
  }
}

data "aws_subnet" "back2" {
  filter {
    name   = "tag:Name"
    values = ["${terraform.workspace}-back-end-b"]
  }
}
