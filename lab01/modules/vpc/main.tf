resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true # Giúp EC2 truy cập Internet bằng DNS
  enable_dns_hostnames = true # Hostname nội bộ cho EC2 để gọi nhau

  tags = {
    name = "${var.name}-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    name = "${var.name}-igw"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  count                   = length(var.public_subnet_cidrs)
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true # EC2 trong subnet này tự động có public IP

  tags = {
    name = "${var.name}-public-${count.index}"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  count             = length(var.private_subnet_cidrs)
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    name = "${var.name}-private-${count.index}"
  }
}

resource "aws_eip" "nat" {
  count  = 1
  domain = "vpc" # EIP này được sử dụng trong VPC
}

resource "aws_nat_gateway" "this" {
  subnet_id     = aws_subnet.public[0].id # Đặt ở 1 public subnet
  allocation_id = aws_eip.nat[0].id       # Gán EIP

  depends_on = [aws_internet_gateway.this] # Đảm bảo dependency của NAT Gateway lên IGW

  tags = {
    name = "${var.name}-nat"
  }
}

# Tạo 1 public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    name = "${var.name}-public-rt"
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
    name = "${var.name}-private-rt"
  }
}

# EC2 trong private subnet kết nối với internet thông qua NAT Gateway
resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[count.index].id
}
