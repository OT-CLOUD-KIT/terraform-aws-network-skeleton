AWS Network Skeleton Terraform module
=====================================

[![Opstree Solutions][opstree_avatar]][opstree_homepage]

[Opstree Solutions][opstree_homepage] 

  [opstree_homepage]: https://opstree.github.io/
  [opstree_avatar]: https://img.cloudposse.com/150x150/https://github.com/opstree.png

Terraform module which creates network skeleton on AWS.

These types of resources are supported:

* [VPC](https://www.terraform.io/docs/providers/aws/r/vpc.html)
* [Subnet](https://www.terraform.io/docs/providers/aws/r/subnet.html)
* [Route](https://www.terraform.io/docs/providers/aws/r/route.html)
* [Route table](https://www.terraform.io/docs/providers/aws/r/route_table.html)
* [Internet Gateway](https://www.terraform.io/docs/providers/aws/r/internet_gateway.html)
* [Network ACL](https://www.terraform.io/docs/providers/aws/r/network_acl.html)
* [NAT Gateway](https://www.terraform.io/docs/providers/aws/r/nat_gateway.html)
* [Application Load Balancer](https://www.terraform.io/docs/providers/aws/r/lb.html)
* [Security Groups](https://www.terraform.io/docs/providers/aws/r/security_group.html)

Terraform versions
------------------

Terraform 0.12.

Usage
------

```hcl
provider "aws" {
  region                  = "ap-south-1"
}

module "network_skeleton" {
  source = "../"

  name = "opstree"
  cidr_block = "10.0.0.0/24"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = false
  enable_classiclink = false

  public_sub_az = ["ap-south-1a","ap-south-1b","ap-south-1c"]
  public_subnet_cidr = ["10.0.0.0/27","10.0.0.32/27","10.0.0.64/27"]
  map_public_ip_on_launch = true
  
  nacl_egress_rule_no = 200
  nacl_egress_protocol = "tcp"
  nacl_egress_action = "allow"
  nacl_egress_from_port = [80,443]
  nacl_egress_to_port = [80,443]
  
  nacl_ingress_rule_no = 100
  nacl_ingress_protocol = "tcp"
  nacl_ingress_action = "allow"
  nacl_ingress_from_port = [80,443]
  nacl_ingress_to_port = [80,443]
  
  sg_egress_from_port = [443,80]
  sg_egress_to_port = [443,80]

  sg_ingress_from_port = [443,80]
  sg_ingress_to_port = [443,80]
  
  whitelist_ssh_ip = ["171.76.32.5/32","191.23.54.23/32"]
  
  certificate_arn = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4"
  
  require_hosted_zone = true
  name_hz  = "opstree.com"
  record_type = "A"

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
  vpc_tags = {
    key1 = "value1"
    key2 = "value2"
  }  
}

```

```
output "vpc_id" {
  value       = module.network_skeleton.vpc_id
}

output "vpc_arn" {
  value       = module.network_skeleton.arn
}

output "default_network_acl_id" {
  value       = module.network_skeleton.default_network_acl_id
}

output "default_route_table_id" {
  value       = module.network_skeleton.default_route_table_id
}

output "default_security_group_id" {
  value       = module.network_skeleton.default_security_group_id
}

output "dhcp_options_id" {
  value       = module.network_skeleton.dhcp_options_id
}

output "network_skeleton_route_table_id" {
  value       = module.network_skeleton.main_route_table_id
}

output "owner_id" {
  value       = module.network_skeleton.owner_id
}

output "igw_id" {
  value       = module.network_skeleton.igw_id
}

output "main_route_table_id" {
  value       = module.network_skeleton.main_route_table_id
}

output "public_sub_id" {
  value       = module.network_skeleton.public_sub_id
}

output "public_subnet_arn" {
  value       = module.network_skeleton.public_subnet_arn
}

output "elastic_ip_id"{
  value       = module.network_skeleton.elastic_ip_id
}

output "ngw_id" {
  value       = module.network_skeleton.ngw_id
}

output "network_acl_id"{
  value       = module.network_skeleton.network_acl_id
}

output "alb_id" {
  value       = module.network_skeleton.alb_id
}

output "web_security_group_id" {
  value       = module.network_skeleton.web_security_group_id
}

output "ssh_security_group_id" {
  value       = module.network_skeleton.ssh_security_group_id
}
```
Tags
----
* Tags are assigned to resources with name variable as prefix.
* Additial tags can be assigned by tags variables as defined above.

Inputs
------
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The sting name append in tags | `string` | `"opstree"` | yes |
| cidr_block | The CIDR block for the VPC. Default value is a valid CIDR  | `string` | `"10.0.0.0/24"` | no |
| instance_tenancy | A tenancy option for instances launched into the VPC | `string` | `"default"` | no |
| enable_dns_support | A dns support for instances launched into the VPC | `boolean` | `"true"` | no |
| enable_dns_hostnames | A dns hostname for instances launched into the VPC | `boolean` | `"false"` | no |
| enable_classiclink |A dns classiclink for instances launched into the VPC | `boolean` | `"false"` | no |
| public_sub_az | A list of availability zones names in the region | `list(string)` | `[]` | no |
| public_subnet_cidr | A list of CIDR block for the subnets in VPC. | `list(string)` | `[]` | no |
| map_public_ip_on_launch | Map public ip with instance on launch into the VPC | `boolean` | `true` | no |
| nacl_egress_rule_no | The subnets outbound network ACL rule number | `string` | `"200"` | no |
| nacl_egress_protocol | The subnets outbound network ACL protocol to follow | `string` | `"tcp"` | no |
| nacl_egress_action | The subnets outbound network ACL action for allow and deny rule | `string` | `"allow"` | no |
| nacl_egress_from_port | The subnets outbound network ACL from port range that follows rule | `list(string)` | `"[]"` | no |
| nacl_egress_to_port | The subnets outbound network ACL to port range that follows rule | `list(string)` | `"[]"` | no |
| nacl_ingress_rule_no | The subnets inbound network ACL rule number | `string` | `"100"` | no |
| nacl_ingress_protocol | The subnets inbound network ACL protocol to follow | `string` | `"tcp"` | no |
| nacl_ingress_action |  The subnets inbound network ACL action for allow and deny rule | `string` | `"allow"` | no |
| nacl_ingress_from_port | The subnets inbound network ACL from port range that follows rule | `list(string)` | `"[]"` | no |
| nacl_ingress_to_port | The subnets inbound network ACL to port range that follows rule | `list(string)` | `"[]"` | no |
| sg_egress_from_port | The outbound security on instance from port range that follows rule | `list(string)` | `"[]"` | no |
| sg_egress_to_port | The outbound security on instance to port range that follows rule | `list(string)` | `"[]"` | no |
| sg_ingress_from_port | The inbound security on instance from port range that follows rule | `list(string)` | `"[]"` | no |
| sg_ingress_to_port | The inbound security on instance to port range that follows rule | `list(string)` | `"[]"` | no |
| whitelist_ssh_ip | The ips allowed for ssh on instance associate with security group | `list(string)` | `"[]"` | no |
| certificate_arn | The certicate arn for https enable in aws | `string` | `""` | yes |
| require_hosted_zone | The boolean value required to create public hosted zone | `boolean` | `"true"` | no |
| name_hz | The domain name reqired for public hosted zone | `string` | `""` | yes |
| record_type | The certicate arn for https enable in aws | `string` | `""` | yes |

Output
------
| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| arn | The arn of the VPC |
| default_network_acl_id | The default_network_acl_id of the VPC |
| default_route_table_id | The default_route_table_id of the VPC |
| default_security_group_id | The default_security_group_id of the VPC |
| dhcp_options_id | The dhcp_options_id of the VPC |
| main_route_table_id | The main_route_table_id of the VPC |
| owner_id | The owner_id of the VPC |
| igw_id | The id of the IGW attached to VPC |
| public_sub_id | The id of public subnets |
| public_subnet_arn | The arn of public subnets |
| elastic_ip_id | The elastic_ip_id of the VPC |
| ngw_id | The id of the NGW attached to VPC |
| network_acl_id | The network_acl_id of the VPC |
| alb_id | The id of the Application load balancer attached to VPC |
| web_security_group_id| The web_security_group_id of the VPC |
| ssh_security_group_id | The ssh_security_group_id to whitelist ip in the VPC |

## Related Projects

Check out these related projects.

- [HA_ec2_ALB](https://gitlab.com/ot-aws/terrafrom_v0.12.21/network_skeleton) -  Terraform module for createing a Highly available setup of an EC2 instance with quick disater recovery.
- [security_group](https://gitlab.com/ot-aws/terrafrom_v0.12.21/security_group) - Terraform module for creating dynamic Security groups
- [eks](https://gitlab.com/ot-aws/terrafrom_v0.12.21/eks) - Terraform module for creating elastic kubernetes cluster.
- [rds](https://gitlab.com/ot-aws/terrafrom_v0.12.21/rds) - Terraform module for creating Relation Datbase service.
- [HA_ec2](https://gitlab.com/ot-aws/terrafrom_v0.12.21/ha_ec2.git) - Terraform module for creating a Highly available setup of an EC2 instance with quick disater recovery.
- [rolling_deployment](https://gitlab.com/ot-aws/terrafrom_v0.12.21/rolling_deployment.git) - This terraform module will orchestrate rolling deployment.

### Contributors

[![Sudipt Sharma][sudipt_avatar]][sudipt_homepage]<br/>[Sudipt Sharma][sudipt_homepage] 

  [sudipt_homepage]: https://github.com/iamsudipt
  [sudipt_avatar]: https://img.cloudposse.com/75x75/https://github.com/iamsudipt.png
