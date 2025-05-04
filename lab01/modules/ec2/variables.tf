variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to connect to public EC2 via SSH"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "public_subnet_id" {
  description = "ID of the public subnet"
  type        = string
}

variable "private_subnet_id" {
  description = "ID of the private subnet"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = null
}

variable "ssh_public_key" {
  description = "Public key material for SSH key pair"
  type        = string
  default     = null
}

variable "create_public_instance" {
  description = "Whether to create public EC2 instance"
  type        = bool
  default     = true
}

variable "create_private_instance" {
  description = "Whether to create private EC2 instance"
  type        = bool
  default     = true
} 