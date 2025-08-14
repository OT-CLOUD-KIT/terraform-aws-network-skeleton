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

output "public_rt_id" {
  value = aws_route_table.public_rt.id
}

output "privat_rt_id" {
  value = aws_route_table.private_rt.id
}

output "route53_zone_id" {
  description = "Zone ID for the VPC Route53"
  value       = aws_route53_zone.vpc_route53[*].zone_id
}

# ----------------------------
# VPC Endpoint Outputs
# ----------------------------

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

# ----------------------------
# ALB Outputs
# ----------------------------

output "alb_arn" {
  value       = var.create_alb ? one(aws_lb.alb[*].arn) : null
  description = "The ARN of the ALB"
}

output "alb_dns_name" {
  value       = var.create_alb ? one(aws_lb.alb[*].dns_name) : null
  description = "The DNS name of the ALB"
}

output "alb_zone_id" {
  value       = var.create_alb ? one(aws_lb.alb[*].zone_id) : null
  description = "The zone ID of the ALB"
}

output "alb_http_listener_arn" {
  description = "The ARN of the ALB HTTP listener"
  value       = try(aws_lb_listener.alb_http_listener[0].arn, null)
}

output "alb_https_listener_arn" {
  description = "The ARN of the ALB HTTPS listener (if present)"
  value       = try(aws_lb_listener.alb_https_listener[0].arn, null)
}

# ----------------------------
# NLB Output
# ----------------------------

output "nlb_arn" {
  value       = var.create_nlb ? one(aws_lb.nlb[*].arn) : null
  description = "The ARN of the NLB"
}


####################### key pair ######################333

######################################
# Key Pair Outputs
######################################
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
  value       = local.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = local.private_subnet_ids
}

output "application_subnet_ids" {
  description = "List of application subnet IDs"
  value       = local.application_subnet_ids
}

output "database_subnet_ids" {
  description = "List of database subnet IDs"
  value       = local.database_subnet_ids
}
