output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.network_skeleton.vpc_id
}

output "arn" {
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

output "ipv6_association_id" {
  description = "The ipv6_association_id of the VPC"
  value       = module.network_skeleton.ipv6_association_id
}

output "ipv6_cidr_block" {
  description = "The ipv6_cidr_block of the VPC"
  value       = module.network_skeleton.ipv6_cidr_block
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
