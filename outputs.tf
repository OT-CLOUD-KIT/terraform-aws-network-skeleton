
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "arn" {
  description = "The arn of the VPC"
  value       = aws_vpc.vpc.arn
}

output "default_network_acl_id" {
  description = "The default_network_acl_id of the VPC"
  value       = aws_vpc.vpc.default_network_acl_id
}

output "default_route_table_id" {
  description = "The default_route_table_id of the VPC"
  value       = aws_vpc.vpc.default_route_table_id
}

output "default_security_group_id" {
  description = "The default_security_group_id of the VPC"
  value       = aws_vpc.vpc.default_security_group_id
}

output "dhcp_options_id" {
  description = "The dhcp_options_id of the VPC"
  value       = aws_vpc.vpc.dhcp_options_id
}

output "ipv6_association_id" {
  description = "The ipv6_association_id of the VPC"
  value       = aws_vpc.vpc.ipv6_association_id
}

output "ipv6_cidr_block" {
  description = "The ipv6_cidr_block of the VPC"
  value       = aws_vpc.vpc.ipv6_cidr_block
}

output "main_route_table_id" {
  description = "The main_route_table_id of the VPC"
  value       = aws_vpc.vpc.main_route_table_id
}

output "owner_id" {
  description = "The owner_id of the VPC"
  value       = aws_vpc.vpc.owner_id
}

output "igw_id" {
  description = "The id of the IGW attached to VPC"
  value       = aws_internet_gateway.igw.id
}
