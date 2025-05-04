terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}

module "ec2" {
  source = "./modules/ec2"

  vpc_id                = module.vpc.vpc_id
  public_subnet_id      = module.vpc.public_subnets[0]
  private_subnet_id     = module.vpc.private_subnets[0]
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  key_name              = "lab01-keypair"
  allowed_ssh_cidr      = var.allowed_ssh_cidr
  create_public_instance  = true
  create_private_instance = true
}
