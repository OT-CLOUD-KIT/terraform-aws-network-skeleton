output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.network_skeleton.vpc_id
}

output "vpc_arn" {
  description = "The arn of the VPC"
  value       = module.network_skeleton.arn
}

output "default_network_acl_id" {
  description = "The default_network_acl_id of the VPC"
  value       = module.network_skeleton.default_network_acl_id
}

output "default_route_table_id" {
  description = "The default_route_table_id of the VPC"
  value       = module.network_skeleton.default_route_table_id
}

output "default_security_group_id" {
  description = "The default_security_group_id of the VPC"
  value       = module.network_skeleton.default_security_group_id
}

output "dhcp_options_id" {
  description = "The dhcp_options_id of the VPC"
  value       = module.network_skeleton.dhcp_options_id
}

output "network_skeleton_route_table_id" {
  description = "The network_skeleton_route_table_id of the VPC"
  value       = module.network_skeleton.main_route_table_id
}

output "owner_id" {
  description = "The owner_id of the VPC"
  value       = module.network_skeleton.owner_id
}

output "igw_id" {
  description = "The id of the IGW attached to VPC"
  value       = module.network_skeleton.igw_id
}

output "main_route_table_id" {
  description = "The main_route_table_id of the VPC"
  value       = module.network_skeleton.main_route_table_id
}

output "public_sub_id" {
  description = "The id of public subnet"
  value       = module.network_skeleton.public_sub_id
}

output "public_subnet_arn" {
  description = "The arn of public subnet" 
  value       = module.network_skeleton.public_subnet_arn
}

output "elastic_ip_id"{
  description = "The elastic_ip_id of the VPC"
  value       = module.network_skeleton.elastic_ip_id
}

output "ngw_id" {
  description = "The id of the NGW attached to VPC"
  value       = module.network_skeleton.ngw_id
}

output "network_acl_id"{
  description = "The network_acl_id of the VPC"
  value       = module.network_skeleton.network_acl_id
}

output "alb_id" {
  description = "The id of the Application load balancer attached to VPC"
  value       = module.network_skeleton.alb_id
}

output "web_security_group_id" {
  description = "The web_security_group_id of the VPC"
  value       = module.network_skeleton.web_security_group_id
}

output "ssh_security_group_id" {
  description = "The ssh_security_group_id to whitelist ip in the VPC"
  value       = module.network_skeleton.ssh_security_group_id
}