provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"

  name                 = "lab01"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  azs                  = ["us-east-1a", "us-east-1a"]
}

module "security_group" {
  source = "./modules/security_group"

  name   = "lab01"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source = "./modules/ec2"

  project_name           = "lab01"
  instance_type          = "t2.micro"
  ami_id                 = ""
  
  # Public instance
  public_subnet_id        = module.vpc.public_subnets[0]
  public_security_group_id = module.security_group.public_security_group_id
  create_public_instance  = true
  
  # Private instance
  private_subnet_id        = module.vpc.private_subnets[0]
  private_security_group_id = module.security_group.private_security_group_id
  create_private_instance  = true
}
