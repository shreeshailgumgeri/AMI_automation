provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

data "aws_ami" "latest_linux" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["linux-base-*"]
  }
}

resource "aws_instance" "linux" {
  ami           = data.aws_ami.latest_linux.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  tags = {
    Name = var.instance_name
    Environment = var.environment
  }
}