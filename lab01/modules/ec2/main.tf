terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_key_pair" "main" {
  key_name   = "${var.project_name}-key"
  public_key = var.ssh_public_key
}

resource "aws_instance" "public" {
  count = var.create_public_instance ? 1 : 0
  
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.public_security_group_id]
  key_name               = var.key_name != null ? var.key_name : aws_key_pair.main.key_name
  
  tags = {
    Name = "${var.project_name}-public-instance"
  }
}

resource "aws_instance" "private" {
  count = var.create_private_instance ? 1 : 0
  
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.private_security_group_id]
  key_name               = var.key_name != null ? var.key_name : aws_key_pair.main.key_name
  
  tags = {
    Name = "${var.project_name}-private-instance"
  }
}