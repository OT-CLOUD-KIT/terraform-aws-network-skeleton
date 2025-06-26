output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.network.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.network.vpc_cidr_block
}

output "default_security_group_id" {
  description = "The ID of the default security group for the VPC"
  value       = module.network.default_security_group_id
}

output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = module.network.default_network_acl_id
}

output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = module.network.default_route_table_id
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = module.network.igw_id
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = module.network.public_route_table_id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.network.public_subnets_ids
}

output "public_subnets_cidr_blocks" {
  description = "CIDR blocks of public subnets"
  value       = module.network.public_subnets_cidr_blocks
}

output "route53_zone_id" {
  description = "Private Route53 zone ID"
  value       = module.network.route53_zone_id
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.network.private_subnets_ids
}

output "private_subnets_cidr_blocks" {
  description = "CIDR blocks of private subnets"
  value       = module.network.private_subnets_cidr_blocks
}

output "private_route_table_id" {
  description = "List of private route table IDs"
  value       = module.network.private_route_table_id
}

output "nat_gateway_ips" {
  description = "List of NAT Gateway IP addresses"
  value       = module.network.nat_gateway_ips
}

output "nat_gateway_id" {
  description = "List of NAT Gateway IDs"
  value       = module.network.nat_gateway_id
}

output "database_subnets" {
  description = "List of database subnet IDs"
  value       = module.network.database_subnets_ids
}

output "database_subnets_cidr_blocks" {
  description = "CIDR blocks of database subnets"
  value       = module.network.database_subnets_cidr_blocks
}

output "flow_logs_bucket_arn" {
  description = "ARN of the S3 bucket for flow logs"
  value       = module.network.flow_logs_bucket_arn
}

output "vpc_flow_log_arn" {
  description = "ARN of the VPC flow log resource"
  value       = module.network.vpc_flow_log_arn
}

output "public_nacl_id" {
  value = module.network.public_nacl_id
}

output "private_nacl_id" {
  value = module.network.private_nacl_id
}



output "s3_endpoint_id" {
  description = "The ID of the S3 VPC endpoint"
  value       = var.enable_s3_endpoint ? module.network.s3_endpoint.id : null
}

output "s3_endpoint_dns_entries" {
  description = "DNS entries for the S3 VPC endpoint"
  value       = var.enable_s3_endpoint ? module.network.s3_endpoint.dns_entries : null
}

output "ec2_endpoint_id" {
  description = "The ID of the EC2 VPC endpoint"
  value       = var.enable_ec2_endpoint ? module.network.ec2_endpoint.id : null
}

output "ec2_endpoint_dns_entries" {
  description = "DNS entries for the EC2 VPC endpoint"
  value       = var.enable_ec2_endpoint ? module.network.ec2_endpoint.dns_entries : null
}

output "nlb_endpoint_id" {
  description = "The ID of the NLB VPC endpoint"
  value       = var.enable_nlb_endpoint ? module.network.nlb_endpoint.id : null
}

output "nlb_endpoint_dns_entries" {
  description = "DNS entries for the NLB VPC endpoint"
  value       = var.enable_nlb_endpoint ? module.network.nlb_endpoint.dns_entries : null
}

output "endpoint_security_group_id" {
  description = "The ID of the endpoint security group"
  value       = var.enable_endpoint_sg ? module.network.endpoint_security_group.id : null
}

# Additional useful outputs
output "all_vpc_endpoint_ids" {
  description = "Map of all created VPC endpoint IDs"
  value = {
    s3  = var.enable_s3_endpoint ? module.network.s3_endpoint.id : null
    ec2 = var.enable_ec2_endpoint ? module.network.ec2_endpoint.id : null
    nlb = var.enable_nlb_endpoint ? module.network.nlb_endpoint.id : null
  }
}

output "endpoint_sg_ingress_rules" {
  description = "List of ingress rules for the endpoint security group"
  value       = var.enable_endpoint_sg ? module.network.endpoint_security_group_rules.ingress : null
}

output "endpoint_sg_egress_rules" {
  description = "List of egress rules for the endpoint security group"
  value       = var.enable_endpoint_sg ? module.network.endpoint_security_group_rules.egress : null
}




###################
output "alb_dns_name" {
  value = module.network.alb_dns_name
}

output "alb_arn" {
  value = module.network.alb_arn
}

output "alb_zone_id" {
  value = module.network.alb_zone_id
}

output "alb_http_listener_arn" {
  value = module.network.alb_http_listener_arn
}

output "alb_https_listener_arn" {
  value = module.network.alb_https_listener_arn
}

output "alb_security_group_id" {
  value = module.network.alb_security_group_id
}

output "alb_security_group_arn" {
  value = module.network.alb_security_group_arn
}
