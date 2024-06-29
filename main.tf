# VPC 1 Configuration (Public and Private Access)
resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "VPC1"
  }
}

resource "aws_subnet" "vpc1_public_subnet" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"
  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "vpc1_private_subnet" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.2.0/24"
  availability_zone       = "us-west-2a"
  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_internet_gateway" "vpc1_igw" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "Internet Gateway"
  }
}

resource "aws_nat_gateway" "vpc1_nat" {
  allocation_id = aws_eip.vpc1_nat_eip.id
  subnet_id     = aws_subnet.vpc1_public_subnet.id
  tags = {
    Name = "NAT Gateway"
  }
}

resource "aws_eip" "vpc1_nat_eip" {
  
}

resource "aws_route_table" "vpc1_public_rt" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc1_igw.id
  }
  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "vpc1_public_rt_assoc" {
  subnet_id      = aws_subnet.vpc1_public_subnet.id
  route_table_id = aws_route_table.vpc1_public_rt.id
}

resource "aws_route_table" "vpc1_private_rt" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.vpc1_nat.id
  }
  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table_association" "vpc1_private_rt_assoc" {
  subnet_id      = aws_subnet.vpc1_private_subnet.id
  route_table_id = aws_route_table.vpc1_private_rt.id
}

# VPC 2 Configuration (Isolated, No Internet Access)
resource "aws_vpc" "vpc2" {
  cidr_block = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "VPC2"
  }
}

resource "aws_subnet" "vpc2_private_subnet" {
  vpc_id     = aws_vpc.vpc2.id
  cidr_block = "10.1.1.0/24"
  availability_zone       = "us-west-2a"
  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_route_table" "vpc2_private_rt" {
  vpc_id = aws_vpc.vpc2.id
  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table_association" "vpc2_private_rt_assoc" {
  subnet_id      = aws_subnet.vpc2_private_subnet.id
  route_table_id = aws_route_table.vpc2_private_rt.id
}

# VPC Peering Configuration
resource "aws_vpc_peering_connection" "peer" {
  vpc_id        = aws_vpc.vpc1.id
  peer_vpc_id   = aws_vpc.vpc2.id
  auto_accept   = true
  tags = {
    Name = "VPC Peering between VPC1 and VPC2"
  }
}

resource "aws_route" "vpc1_to_vpc2" {
  route_table_id         = aws_route_table.vpc1_private_rt.id
  destination_cidr_block = aws_vpc.vpc2.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "vpc2_to_vpc1" {
  route_table_id         = aws_route_table.vpc2_private_rt.id
  destination_cidr_block = aws_vpc.vpc1.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

# Security Groups
resource "aws_security_group" "vpc1_public_sg" {
  vpc_id = aws_vpc.vpc1.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Public Security Group"
  }
}

resource "aws_security_group" "vpc1_private_sg" {
  vpc_id = aws_vpc.vpc1.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_subnet.vpc1_public_subnet.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Private Security Group"
  }
}

resource "aws_security_group" "vpc2_sg" {
  vpc_id = aws_vpc.vpc2.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.vpc1.cidr_block]
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

# Network ACLs
resource "aws_network_acl" "vpc1_acl" {
  vpc_id = aws_vpc.vpc1.id
  subnet_ids = [
    aws_subnet.vpc1_public_subnet.id,
    aws_subnet.vpc1_private_subnet.id
  ]

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "VPC1 Network ACL"
  }
}

resource "aws_network_acl" "vpc2_acl" {
  vpc_id = aws_vpc.vpc2.id
  subnet_ids = [aws_subnet.vpc2_private_subnet.id]

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.vpc1.cidr_block
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "VPC2 Network ACL"
  }
}


