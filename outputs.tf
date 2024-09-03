# Outputs for VPC 1
output "vpc1_id" {
  description = "VPC 1 id"
  value       = aws_vpc.vpc1.id
}

output "vpc1_public_subnet_id" {
  description = "VPC 1 Public Subnet id"
  value       = aws_subnet.vpc1_public_subnet.id
}

output "vpc1_private_subnet_id" {
  description = "VPC 1 Private Subnet id"
  value       = aws_subnet.vpc1_private_subnet.id
}

output "vpc1_igw_id" {
  description = "VPC 1 Internet Gateway id"
  value       = aws_internet_gateway.vpc1_igw.id
}
# Outputs for VPC 2
output "vpc2_id" {
  description = "VPC 2 ID"
  value       = aws_vpc.vpc2.id
}

output "vpc2_public_subnet_id" {
  description = "VPC 2 Public Subnet id"
  value       = aws_subnet.vpc2_public_subnet.id
}

output "vpc2_private_subnet_id" {
  description = "VPC 2 Private Subnet id"
  value       = aws_subnet.vpc2_private_subnet.id
}

output "vpc2_igw_id" {
  description = "VPC 2 Internet Gateway id"
  value       = aws_internet_gateway.vpc2_igw.id
}





