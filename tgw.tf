# AWS Transit Gateway
resource "aws_ec2_transit_gateway" "example" {
  description     = "Transit Gateway for connecting VPCs"
  amazon_side_asn = var.asn
}

# Transit Gateway Attachments for VPCs
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc1_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.example.id
  vpc_id             = aws_vpc.vpc1.id
  subnet_ids         = [aws_subnet.vpc1_private_subnet.id] # One private subnet attached
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc2_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.example.id
  vpc_id             = aws_vpc.vpc2.id
  subnet_ids         = [aws_subnet.vpc2_private_subnet.id] # One private subnet attached
}

# Transit Gateway Route Table
resource "aws_ec2_transit_gateway_route_table" "example" {
  transit_gateway_id = aws_ec2_transit_gateway.example.id
}

# Transit Gateway Routes
resource "aws_ec2_transit_gateway_route" "vpc1_to_vpc2" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example.id
  destination_cidr_block         = aws_vpc.vpc2.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc2_attachment.id
}

resource "aws_ec2_transit_gateway_route" "vpc2_to_vpc1" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.example.id
  destination_cidr_block         = aws_vpc.vpc1.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc1_attachment.id
}