
output "vpc_id" {
  value       = module.network.vpc_id
  description = "ID of the VPC"
}

output "vpc_cidr_block" {
  value       = module.network.vpc_cidr_block
  description = "CIDR block of the VPC"
}


output "igw_id" {
  value       = module.network.igw_id
  description = "Internet Gateway ID"
}

output "nat_gateway_ids" {
  value       = module.network.nat_gateway_ids
  description = "List of NAT Gateway IDs"
}

output "public_rt_id" {
  value       = module.network.public_rt_id
  description = "Public route table ID"
}

output "private_rt_id" {
  value       = module.network.privat_rt_id
  description = "Private route table ID"
}

output "flow_logs_bucket_arn" {
  value       = module.network.flow_logs_bucket_arn
  description = "ARN of the Flow Logs S3 bucket"
}

output "vpc_flow_log_arn" {
  value       = module.network.vpc_flow_log_arn
  description = "ARN of the VPC flow log"
}

output "route53_zone_id" {
  value       = module.network.route53_zone_id
  description = "Private Route53 Zone ID"
}

######################
# VPC Endpoints
######################

output "s3_endpoint" {
  value       = module.network.s3_endpoint
  description = "S3 VPC endpoint details"
}

output "ec2_endpoint" {
  value       = module.network.ec2_endpoint
  description = "EC2 VPC endpoint details"
}

output "nlb_endpoint" {
  value       = module.network.nlb_endpoint
  description = "NLB VPC endpoint details"
}

######################
# ALB Outputs
######################

output "alb_arn" {
  value       = module.network.alb_arn
  description = "ARN of the ALB"
}

output "alb_dns_name" {
  value       = module.network.alb_dns_name
  description = "DNS name of the ALB"
}

output "alb_zone_id" {
  value       = module.network.alb_zone_id
  description = "Zone ID of the ALB"
}




output "alb_http_listener_arn" {
  description = "HTTP Listener ARN for ALB"
  value       = module.network.alb_http_listener_arn
}

output "alb_https_listener_arn" {
  description = "HTTPS Listener ARN for ALB"
  value       = module.network.alb_https_listener_arn
}

# Optional: if you want to expose all listener ARNs
output "alb_listener_arns" {
  description = "All ALB listener ARNs from the module"
  value       = module.network.alb_listener_arns
}

######################
# NLB Outputs
######################

output "nlb_arn" {
  value       = module.network.nlb_arn
  description = "ARN of the NLB"
}

######################
# Security Group Outputs
######################

output "alb_sg_id" {
  description = "Security Group ID for ALB"
  value       = try(module.alb_security_group["enabled"].sg_id, "")
}

output "nlb_sg_id" {
  description = "Security Group ID for NLB"
  value       = try(module.nlb_security_group["enabled"].sg_id,"")
}

output "endpoint_sg_id" {
  description = "Security Group ID for Endpoint"
  value       = try(module.endpoint_security_group["enabled"].sg_id, "")
}


###key pair##########

output "created_key_pair_name" {
  value = module.network.key_pair_name
}

output "generated_private_key_path" {
  value = module.network.private_key_path
}

output "subnet_ids" {
  value       = module.network.subnet_ids
  description = "Map of subnet names to subnet IDs"
}



output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.network.private_subnet_ids
}

output "application_subnet_ids" {
  description = "List of application subnet IDs"
  value       = module.network.application_subnet_ids
}

output "database_subnet_ids" {
  description = "List of database subnet IDs"
  value       = module.network.database_subnet_ids
}
