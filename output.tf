output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "ID of the OTMS VPC"
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.vpc.cidr_block
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = aws_vpc.vpc.default_security_group_id
}

output "flow_logs_bucket_arn" {
  description = "The ARN of the Flow Log bucket"
  value       = aws_s3_bucket.flow_logs_bucket[*].arn
}

output "vpc_flow_log_arn" {
  description = "The ARN of the VPC Flow Log"
  value       = aws_flow_log.vpc_flow_log[*].arn
}

output "igw_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = [for nat in aws_nat_gateway.nat_gateway : nat.id]
}

output "vgw_id" {
  description = "Virtual Private Gateway ID"
  value       = var.create_vgw ? aws_vpn_gateway.vgw[0].id : null
}


output "route53_zone_id" {
  description = "Zone ID for the VPC Route53"
  value       = aws_route53_zone.vpc_route53[*].zone_id
}

output "key_pair_name" {
  description = "Name of the created EC2 key pair"
  value       = var.create_key_pair && length(aws_key_pair.key_pair) > 0 ? aws_key_pair.key_pair[0].key_name : var.key_pair_name
}

output "private_key_path" {
  description = "Path to the downloaded private key file (if generated)"
  value       = var.create_private_key && length(local_file.private_key) > 0 ? local_file.private_key[0].filename : "Not generated"
}


output "subnet_ids" {
  value = {
    for subnet in aws_subnet.subnets :
    subnet.tags.Name => subnet.id
  }
}


output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = local.all_subnet_ids
}

output "route_table_names" {
  value = var.route_table_names
}

output "application_subnet_ids" {
  description = "List of application subnet IDs"
  value       = local.application_subnet_ids
}

output "database_subnet_ids" {
  description = "List of database subnet IDs"
  value       = local.database_subnet_ids
}