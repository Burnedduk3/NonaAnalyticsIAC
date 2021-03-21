data "aws_subnet" "front1" {
  filter {
    name   = "tag:Name"
    values = ["front-end-a"]
  }
}

data "aws_subnet" "front2" {
  filter {
    name   = "tag:Name"
    values = ["front-end-b"]
  }
}

data "aws_subnet" "back1" {
  filter {
    name   = "tag:Name"
    values = ["back-end-a"]
  }
}

data "aws_subnet" "back2" {
  filter {
    name   = "tag:Name"
    values = ["back-end-b"]
  }
}