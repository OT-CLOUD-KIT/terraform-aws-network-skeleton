output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.vpc.cidr_block
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = aws_vpc.vpc.default_security_group_id
}

output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = aws_vpc.vpc.default_network_acl_id
}

output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = aws_vpc.vpc.default_route_table_id
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public_route_table.id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public_subnet[*].id
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = compact(aws_subnet.public_subnet[*].cidr_block)
}

output "route53_zone_id" {
  description = "Zone id for the vpc route53"
  value       = aws_route53_zone.vpc_route53.zone_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private_subnet[*].id
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = compact(aws_subnet.private_subnet[*].cidr_block)
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.private_route_table[*].id
}

output "nat_gateway_ips" {
  description = "List of nat gateway IPs"
  value       = aws_eip.nat[*].public_ip
}

output "nat_gateway_id" {
  description = "List of IDs of nat gateway"
  value       = aws_nat_gateway.nat_gateway[*].id
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = aws_subnet.database_subnet[*].id
}

output "database_subnets_cidr_blocks" {
  description = "List of cidr_blocks of database subnets"
  value       = compact(aws_subnet.database_subnet[*].cidr_block)
}

output "additional_private_routes" {
  description = "List of additional private routes"
  value       = local.additional_routes
}

output "flow_logs_bucket_arn" {
  description = "The ARN of the Flow Log bucket"
  value       = aws_s3_bucket.flow_logs_bucket[*].arn
}

output "vpc_flow_log_arn" {
  description = "The ARN of the Flow Log"
  value       = aws_flow_log.vpc_flow_log[*].arn
}
