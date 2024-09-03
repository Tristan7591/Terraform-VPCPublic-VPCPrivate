# VPC 1 Configuration
resource "aws_vpc" "vpc1" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "VPC1"
  }
}

resource "aws_subnet" "vpc1_public_subnet" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.az
  tags = {
    Name = "VPC1 Public Subnet"
  }
}

resource "aws_subnet" "vpc1_private_subnet" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.az
  tags = {
    Name = "VPC1 Private Subnet"
  }
}

resource "aws_internet_gateway" "vpc1_igw" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "VPC1 Internet Gateway"
  }
}

resource "aws_route_table" "vpc1_public_rt" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc1_igw.id
  }
  tags = {
    Name = "VPC1 Public Route Table"
  }
}

resource "aws_route_table_association" "vpc1_public_rt_assoc" {
  subnet_id      = aws_subnet.vpc1_public_subnet.id
  route_table_id = aws_route_table.vpc1_public_rt.id
}

resource "aws_route_table" "vpc1_private_rt" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "VPC1 Private Route Table"
  }
}

resource "aws_route_table_association" "vpc1_private_rt_assoc" {
  subnet_id      = aws_subnet.vpc1_private_subnet.id
  route_table_id = aws_route_table.vpc1_private_rt.id
}

# VPC 2 Configuration
resource "aws_vpc" "vpc2" {
  cidr_block           = "11.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "VPC2"
  }
}

resource "aws_subnet" "vpc2_public_subnet" {
  vpc_id                  = aws_vpc.vpc2.id
  cidr_block              = "11.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.az
  tags = {
    Name = "VPC2 Public Subnet"
  }
}

resource "aws_subnet" "vpc2_private_subnet" {
  vpc_id            = aws_vpc.vpc2.id
  cidr_block        = "11.1.2.0/24"
  availability_zone = var.az
  tags = {
    Name = "VPC2 Private Subnet"
  }
}

resource "aws_internet_gateway" "vpc2_igw" {
  vpc_id = aws_vpc.vpc2.id
  tags = {
    Name = "VPC2 Internet Gateway"
  }
}

resource "aws_route_table" "vpc2_public_rt" {
  vpc_id = aws_vpc.vpc2.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc2_igw.id
  }
  tags = {
    Name = "VPC2 Public Route Table"
  }
}

resource "aws_route_table_association" "vpc2_public_rt_assoc" {
  subnet_id      = aws_subnet.vpc2_public_subnet.id
  route_table_id = aws_route_table.vpc2_public_rt.id
}

resource "aws_route_table" "vpc2_private_rt" {
  vpc_id = aws_vpc.vpc2.id
  tags = {
    Name = "VPC2 Private Route Table"
  }
}

resource "aws_route_table_association" "vpc2_private_rt_assoc" {
  subnet_id      = aws_subnet.vpc2_private_subnet.id
  route_table_id = aws_route_table.vpc2_private_rt.id
}

# Security Groups with SSH and ICMP rules
resource "aws_security_group" "vpc1_sg" {
  vpc_id = aws_vpc.vpc1.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VPC1 Security Group"
  }
}

resource "aws_security_group" "vpc2_sg" {
  vpc_id = aws_vpc.vpc2.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VPC2 Security Group"
  }
}
