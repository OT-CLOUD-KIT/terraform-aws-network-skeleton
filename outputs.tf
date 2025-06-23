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
  value = length(aws_internet_gateway.igw) > 0 ? aws_internet_gateway.igw[0].id : null
  description = "The ID of the Internet Gateway"
}


output "public_route_table_id" {
  value = length(aws_route_table.public_route_table) > 0 ? aws_route_table.public_route_table[0].id : null
  description = "The ID of the public route table"
}


output "public_subnets_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public_subnet[*].id
}

output "public_subnets_cidr_blocks" {
  description = "List of CIDR blocks of public subnets"
  value       = compact(aws_subnet.public_subnet[*].cidr_block)
}

output "route53_zone_id" {
  description = "Zone ID for the VPC Route53"
  value       = aws_route53_zone.vpc_route53[*].zone_id  
}

output "private_subnets_ids" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private_subnet[*].id
}

output "private_subnets_cidr_blocks" {
  description = "List of CIDR blocks of private subnets"
  value       = compact(aws_subnet.private_subnet[*].cidr_block)
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.private_route_table[*].id
}

output "nat_gateway_ips" {
  description = "List of NAT Gateway IPs"
  value       = aws_eip.nat[*].public_ip
}

output "nat_gateway_id" {
  description = "List of IDs of NAT Gateways"
  value       = aws_nat_gateway.nat_gateway[*].id
}

output "database_subnets_ids" {
  description = "List of IDs of database subnets"
  value       = aws_subnet.database_subnet[*].id
}

output "database_subnets_cidr_blocks" {
  description = "List of CIDR blocks of database subnets"
  value       = compact(aws_subnet.database_subnet[*].cidr_block)
}

output "flow_logs_bucket_arn" {
  description = "The ARN of the Flow Log bucket"
  value       = aws_s3_bucket.flow_logs_bucket[*].arn
}

output "vpc_flow_log_arn" {
  description = "The ARN of the Flow Log"
  value       = aws_flow_log.vpc_flow_log[*].arn
}

output "public_nacl_id" {
  description = "The ID of the public Network ACL"
  value       = length(aws_network_acl.public) > 0 ? aws_network_acl.public[0].id : null
}

output "private_nacl_id" {
  description = "The ID of the private Network ACL"
  value       = length(aws_network_acl.private) > 0 ? aws_network_acl.private[0].id : null
}

# Outputs for VPC Endpoints
output "s3_endpoint" {
  description = "Details of the S3 VPC endpoint"
  value = var.enable_s3_endpoint ? {
    id              = aws_vpc_endpoint.s3[0].id
    service_name    = aws_vpc_endpoint.s3[0].service_name
    dns_entries     = aws_vpc_endpoint.s3[0].dns_entry
    route_table_ids = aws_vpc_endpoint.s3[0].route_table_ids
  } : null
}

output "ec2_endpoint" {
  description = "Details of the EC2 VPC endpoint"
  value = var.enable_ec2_endpoint ? {
    id              = aws_vpc_endpoint.ec2[0].id
    service_name    = aws_vpc_endpoint.ec2[0].service_name
    dns_entries     = aws_vpc_endpoint.ec2[0].dns_entry
    subnet_ids      = aws_vpc_endpoint.ec2[0].subnet_ids
    security_groups = aws_vpc_endpoint.ec2[0].security_group_ids
    private_dns     = aws_vpc_endpoint.ec2[0].private_dns_enabled
  } : null
}

output "nlb_endpoint" {
  description = "Details of the NLB VPC endpoint"
  value = var.enable_nlb_endpoint ? {
    id              = aws_vpc_endpoint.nlb[0].id
    service_name    = aws_vpc_endpoint.nlb[0].service_name
    dns_entries     = aws_vpc_endpoint.nlb[0].dns_entry
    subnet_ids      = aws_vpc_endpoint.nlb[0].subnet_ids
    security_groups = aws_vpc_endpoint.nlb[0].security_group_ids
    private_dns     = aws_vpc_endpoint.nlb[0].private_dns_enabled
  } : null
}

output "endpoint_security_group_rules" {
  description = "Ingress and egress rules of the endpoint security group"
  value = var.enable_endpoint_sg ? {
    ingress = aws_security_group.endpoint_sg[0].ingress
    egress  = aws_security_group.endpoint_sg[0].egress
  } : null
}

output "endpoint_security_group" {
  description = "Details of the endpoint security group"
  value = var.enable_endpoint_sg ? {
    id          = aws_security_group.endpoint_sg[0].id
    name        = aws_security_group.endpoint_sg[0].name
    description = aws_security_group.endpoint_sg[0].description
    vpc_id      = aws_security_group.endpoint_sg[0].vpc_id
  } : null
}