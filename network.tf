# ---------------------------------------------
# VPC
# https://registry.terraform.io/providers/hashicorp/aws/3.3.0/docs/resources/vpc
# ---------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block                       = "172.16.0.0/16"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${var.project}-vpc"
    Project = var.project
  }
}

# ---------------------------------------------
# Subnet
# ---------------------------------------------
resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "172.16.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-public_subnet_1a"
    Project = var.project
    type    = "public"
  }
}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "172.16.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-public_subnet_1c"
    Project = var.project
    type    = "public"
  }
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "172.16.3.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-private_subnet_1a"
    Project = var.project
    type    = "private"
  }
}

resource "aws_subnet" "private_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "172.16.4.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-private_subnet_1c"
    Project = var.project
    type    = "private"
  }
}

# ---------------------------------------------
# Route Table(public)
# ---------------------------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-public-rt" #コンソール上に出てくる名前
    Project = var.project
    Type    = "public"
  }
}

# ---------------------------------------------
# Route Table(private)
# ---------------------------------------------
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-private-rt" #コンソール上に出てくる名前
    Project = var.project
    Type    = "private"
  }
}

# ---------------------------------------------
# Route Table association(public)
# ---------------------------------------------
resource "aws_route_table_association" "public_rt_association_1a" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1a.id
}

resource "aws_route_table_association" "public_rt_association_1c" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1c.id
}

# ---------------------------------------------
# Route Table association(private)
# ---------------------------------------------
resource "aws_route_table_association" "private_rt_association_1a" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet_1a.id
}

resource "aws_route_table_association" "private_rt_association_1c" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet_1c.id
}

# ---------------------------------------------
# Internet Gateway
# ---------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-igw"
    Project = var.project
  }
}

# ---------------------------------------------
# Internet Gateway associate with public route table
# ---------------------------------------------
resource "aws_route" "igw_associate_public_rt" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}