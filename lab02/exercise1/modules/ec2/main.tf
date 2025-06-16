terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Security Group for Public EC2
resource "aws_security_group" "public" {
  name        = "lab01-public-ec2-sg"
  description = "Security group for public EC2 instance"
  vpc_id      = var.vpc_id

  # Allow SSH from specific IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lab01-public-ec2-sg"
  }
}

# Security Group for Private EC2
resource "aws_security_group" "private" {
  name        = "lab01-private-ec2-sg"
  description = "Security group for private EC2 instance"
  vpc_id      = var.vpc_id

  # Allow SSH from Public EC2
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lab01-private-ec2-sg"
  }
}

resource "aws_instance" "public" {
  count = var.create_public_instance ? 1 : 0
  
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id
  key_name      = var.key_name
  
  vpc_security_group_ids = [aws_security_group.public.id]

  tags = {
    Name = "lab01-public-ec2"
  }
}

resource "aws_instance" "private" {
  count = var.create_private_instance ? 1 : 0
  
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_id
  key_name      = var.key_name
  
  vpc_security_group_ids = [aws_security_group.private.id]

  tags = {
    Name = "lab01-private-ec2"
  }
}