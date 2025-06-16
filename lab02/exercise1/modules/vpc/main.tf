# VPC Flow Logs Role
resource "aws_iam_role" "vpc_flow_logs" {
  name = "lab01-vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "lab01-vpc-flow-logs-role"
  }
}

resource "aws_iam_role_policy" "vpc_flow_logs" {
  name = "lab01-vpc-flow-logs-policy"
  role = aws_iam_role.vpc_flow_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# CloudWatch Log Group for VPC Flow Logs
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/lab01-flow-logs"
  retention_in_days = 7

  tags = {
    Name = "lab01-vpc-flow-logs"
  }
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true # Giúp EC2 truy cập Internet bằng DNS
  enable_dns_hostnames = true # Hostname nội bộ cho EC2 để gọi nhau

  tags = {
    Name = "lab01-vpc"
  }
}

# VPC Flow Logs
resource "aws_flow_log" "vpc" {
  iam_role_arn    = aws_iam_role.vpc_flow_logs.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.this.id

  tags = {
    Name = "lab01-vpc-flow-logs"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "lab01-igw"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  count                   = length(var.public_subnet_cidrs)
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false # Disable auto-assign public IP for security

  tags = {
    Name = "lab01-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  count             = length(var.private_subnet_cidrs)
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "lab01-private-subnet-${count.index + 1}"
  }
}

resource "aws_eip" "nat" {
  count  = 1
  domain = "vpc" # EIP này được sử dụng trong VPC

  tags = {
    Name = "lab01-nat-eip"
  }

  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  subnet_id     = aws_subnet.public[0].id # Đặt ở 1 public subnet
  allocation_id = aws_eip.nat[0].id       # Gán EIP

  depends_on = [aws_internet_gateway.this] # Đảm bảo dependency của NAT Gateway lên IGW

  tags = {
    Name = "lab01-nat-gateway"
  }
}

# Tạo 1 public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "lab01-public-rt"
  }
}

# Thêm record route đi ra internet vào route table
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Gán public table route vào các public subnet
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "lab01-private-rt"
  }
}

# EC2 trong private subnet kết nối với internet thông qua NAT Gateway
resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[count.index].id
}

# Restrictive Default Security Group for VPC
resource "aws_security_group" "default" {
  name        = "lab01-default-sg"
  description = "Restrictive default security group for VPC"
  vpc_id      = aws_vpc.this.id

  # Remove all ingress and egress rules to restrict traffic
  # No ingress rules - deny all inbound traffic
  # No egress rules - deny all outbound traffic

  tags = {
    Name = "lab01-default-sg"
  }
}