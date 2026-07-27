output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}
output "public_subnet_1_id" {
  value = aws_subnet.public_subnet_1.id
}

output "public_subnet_2_id" {
  value = aws_subnet.public_subnet_2.id
}

output "private_subnet_1_id" {
  value = aws_subnet.private_subnet_1.id
}

output "private_subnet_2_id" {
  value = aws_subnet.private_subnet_2.id
}
output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
}
output "public_route_table_id" {
  value = aws_route_table.public.id
}
output "nat_gateway_id" {
  value = aws_nat_gateway.this.id
}

output "elastic_ip" {
  value = aws_eip.nat.public_ip
}
output "private_route_table_id" {
  value = aws_route_table.private.id
}
output "public_subnet_ids" {
  description = "List of public subnet IDs"

  value = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"

  value = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
}