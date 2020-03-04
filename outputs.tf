
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "arn" {
  description = "The arn of the VPC"
  value       = aws_vpc.main.arn
}

output "default_network_acl_id" {
  description = "The default_network_acl_id of the VPC"
  value       = aws_vpc.main.default_network_acl_id
}

output "default_route_table_id" {
  description = "The default_route_table_id of the VPC"
  value       = aws_vpc.main.default_route_table_id
}

output "default_security_group_id" {
  description = "The default_security_group_id of the VPC"
  value       = aws_vpc.main.default_security_group_id
}

output "dhcp_options_id" {
  description = "The dhcp_options_id of the VPC"
  value       = aws_vpc.main.dhcp_options_id
}

output "main_route_table_id" {
  description = "The main_route_table_id of the VPC"
  value       = aws_vpc.main.main_route_table_id
}

output "owner_id" {
  description = "The owner_id of the VPC"
  value       = aws_vpc.main.owner_id
}

output "igw_id" {
  description = "The id of the IGW attached to VPC"
  value       = aws_internet_gateway.igw.id
}

output "public_sub_id" {
  description = "The id of public subnet"
  value       = aws_subnet.public.id
}

output "public_subnet_arn" {
  description = "The arn of public subnet" 
  value       = aws_subnet.public.arn
}
