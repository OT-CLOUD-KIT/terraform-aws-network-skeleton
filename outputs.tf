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
  value       = aws_route_table.route_table.id
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
  value       = aws_subnet.public.*.id
}

output "public_subnet_arn" {
  description = "The arn of public subnet" 
  value       = aws_subnet.public.*.arn
}

output "elastic_ip_id"{
  description = "The elastic_ip_id of the VPC"
  value       = aws_eip.Eip.id
}

output "ngw_id" {
  description = "The id of the NGW attached to VPC"
  value       = aws_nat_gateway.ngw.id
}

output "network_acl_id"{
  description = "The network_acl_id of the VPC"
  value       = aws_network_acl.network_acl.id
}

output "alb_id" {
  description = "The id of the Application load balancer attached to VPC"
  value       = aws_lb.alb.id
}

output "web_security_group_id" {
  description = "The web_security_group_id of the VPC"
  value       = aws_security_group.web_sg.id
}

output "ssh_security_group_id" {
  description = "The ssh_security_group_id to whitelist ip in the VPC"
  value       = aws_security_group.ssh_sg.id
}
