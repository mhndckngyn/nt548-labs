terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# IAM Role for EC2 instances
resource "aws_iam_role" "ec2_role" {
  name = "lab01-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "lab01-ec2-role"
  }
}

# IAM Instance Profile for EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "lab01-ec2-profile"
  role = aws_iam_role.ec2_role.name

  tags = {
    Name = "lab01-ec2-profile"
  }
}

# Basic policy for EC2 (CloudWatch logs, Systems Manager)
resource "aws_iam_role_policy_attachment" "ec2_cloudwatch" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Security Group for Public EC2
resource "aws_security_group" "public" {
  name        = "lab01-public-ec2-sg"
  description = "Security group for public EC2 instance"
  vpc_id      = var.vpc_id

  # Allow SSH from specific IP
  ingress {
    description = "SSH from specific IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    description = "HTTPS outbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTP outbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "SSH to private instances"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.private.id]
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
    description     = "SSH from public security group"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public.id]
  }

  egress {
    description = "HTTPS outbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTP outbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lab01-private-ec2-sg"
  }
}

resource "aws_instance" "public" {
  count = var.create_public_instance ? 1 : 0

  ami                     = var.ami_id
  instance_type           = var.instance_type
  subnet_id               = var.public_subnet_id
  key_name                = var.key_name
  iam_instance_profile    = aws_iam_instance_profile.ec2_profile.name
  monitoring              = true # Enable detailed monitoring
  ebs_optimized          = true  # Enable EBS optimization

  vpc_security_group_ids = [aws_security_group.public.id]

  # Enable IMDSv2 only
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
    http_put_response_hop_limit = 1
  }

  # Root volume encryption
  root_block_device {
    encrypted   = true
    volume_type = "gp3"
    volume_size = 20
  }

  tags = {
    Name = "lab01-public-ec2"
  }
}

resource "aws_instance" "private" {
  count = var.create_private_instance ? 1 : 0

  ami                     = var.ami_id
  instance_type           = var.instance_type
  subnet_id               = var.private_subnet_id
  key_name                = var.key_name
  iam_instance_profile    = aws_iam_instance_profile.ec2_profile.name
  monitoring              = true # Enable detailed monitoring
  ebs_optimized          = true  # Enable EBS optimization

  vpc_security_group_ids = [aws_security_group.private.id]

  # Enable IMDSv2 only
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
    http_put_response_hop_limit = 1
  }

  # Root volume encryption
  root_block_device {
    encrypted   = true
    volume_type = "gp3"
    volume_size = 20
  }

  tags = {
    Name = "lab01-private-ec2"
  }
}