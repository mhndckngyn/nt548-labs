variable "project_name" {
  description = "lab01"
  type        = string
}

variable "ami_id" {
  description = "ID of the AMI to use for the instances"
  type        = string
}

variable "instance_type" {
  description = "Type of instance to launch"
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

variable "public_security_group_id" {
  description = "ID of the public security group"
  type        = string
}

variable "private_security_group_id" {
  description = "ID of the private security group"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for instance access"
  type        = string
} 