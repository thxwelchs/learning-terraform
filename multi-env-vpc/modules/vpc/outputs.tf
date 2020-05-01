# VPC
output "vpc_id" {
  description = "VPC ID"
  value = aws_vpc.this.id
}

output "vpc_cidr_block" {
  value = aws_vpc.this.cidr_block
}

output "default_security_group_id" {
  value = aws_vpc.this.default_security_group_id
}

output "default_network_acl_id" {
  value = aws_vpc.this.default_network_acl_id
}

# internet gateway
output "igw_id" {
  description = "Interget Gateway ID"
  value = aws_internet_gateway.this.id
}

# subnets
output "private_subnets_ids" {
  value = aws_subnet.private.*.id
}

output "public_subnets_ids" {
  value = aws_subnet.public.*.id
}

# az list
output "az_list" {
  value = var.az_list
}

# route tables
output "public_route_table_ids" {
  value = aws_route_table.this_public_rt.*.id
}

output "private_route_table_ids" {
  value = aws_route_table.this_private_rt.*.id
}

# NAT gateway
output "nat_id" {
  value = aws_eip.this.id
}

output "nat_public_ip" {
  value = aws_eip.this.public_ip
}

output "natgw_id" {
  value = aws_nat_gateway.this.id
}