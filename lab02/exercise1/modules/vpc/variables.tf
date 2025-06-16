variable "vpc_cidr" {
  description = "CIDR block sử dụng bên trong VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Danh sách public subnet (CIDR block)"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Danh sách private subnet (CIDR block)"
  type        = list(string)
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
}
