# VPC Configuration
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24"]
private_subnet_cidrs = ["10.0.2.0/24"]
azs                  = ["ap-southeast-1a"]

# EC2 Configuration
allowed_ssh_cidr = "0.0.0.0/0"
instance_type    = "t2.medium"
ami_id           = "ami-02c7683e4ca3ebf58"
