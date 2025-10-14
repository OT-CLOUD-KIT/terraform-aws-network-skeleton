## Terraform AWS Network Skeleton

A terraform module which creates network skeleton on AWS with best practices in terms of network security, cost and optimization.

## Architecture

![Network_1 drawio](https://github.com/user-attachments/assets/5b5019a4-d2b2-4801-8add-451254f1db8d)


## Providers

| Name                                              | Version  |
|---------------------------------------------------|----------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.82.2   |
| <a name="terraform_module"></a> [Terraform](Terraform\module) | >= 1.12.1|

## Usage

```hcl


  module "network" {
  source = "OT-CLOUD-KIT/terraform-aws-network-skeleton"

  # VPC
  vpc_cidr             = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  cluster_name         = "eks-cluster"

  # Subnets
  subnet_names          = ["public-1", "private-1", "public-2", "private-2"]
  subnet_cidrs          = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
  subnet_azs            = ["us-east-1a", "us-east-1a", "us-east-1b", "us-east-1b"]
  public_subnet_indexes = [0, 2]

  # Route Tables
  public_rt_cidr_block  = "0.0.0.0/0"
  private_rt_cidr_block = "0.0.0.0/0"

  # NAT Gateway
  create_nat_gateway = true

  # NACL
  create_nacl = true
  nacl_names  = ["public", "private", "application", "database"]

  nacl_rules = {
    public = {
      subnet_index = [0]
      ingress_rules = [
        { protocol = "tcp", rule_no = 100, action = "allow", cidr_block = "0.0.0.0/0", from_port = 22, to_port = 22 },
        { protocol = "tcp", rule_no = 110, action = "allow", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 },
        { protocol = "-1",  rule_no = 120, action = "allow", cidr_block = "0.0.0.0/0", from_port = 0, to_port = 0 }
      ]
      egress_rules = [
        { protocol = "tcp", rule_no = 100, action = "allow", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 },
        { protocol = "-1",  rule_no = 110, action = "allow", cidr_block = "0.0.0.0/0", from_port = 0, to_port = 0 }
      ]
    }

    private = {
      subnet_index = [1]
      ingress_rules = [
        { protocol = "tcp", rule_no = 100, action = "allow", cidr_block = "10.0.0.0/16", from_port = 22, to_port = 22 },
        { protocol = "tcp", rule_no = 110, action = "allow", cidr_block = "10.0.0.0/16", from_port = 1024, to_port = 65535 }
      ]
      egress_rules = [
        { protocol = "tcp", rule_no = 100, action = "allow", cidr_block = "10.0.0.0/16", from_port = 1024, to_port = 65535 }
      ]
    }

    application = {
      subnet_index = [2]
      ingress_rules = [
        { protocol = "tcp", rule_no = 100, action = "allow", cidr_block = "10.0.0.0/16", from_port = 22, to_port = 22 },
        { protocol = "tcp", rule_no = 110, action = "allow", cidr_block = "10.0.0.0/16", from_port = 1024, to_port = 65535 }
      ]
      egress_rules = [
        { protocol = "tcp", rule_no = 100, action = "allow", cidr_block = "10.0.0.0/16", from_port = 1024, to_port = 65535 }
      ]
    }

    database = {
      subnet_index = [3]
      ingress_rules = [
        { protocol = "tcp", rule_no = 100, action = "allow", cidr_block = "10.0.0.0/16", from_port = 22, to_port = 22 },
        { protocol = "tcp", rule_no = 110, action = "allow", cidr_block = "10.0.0.0/16", from_port = 1024, to_port = 65535 }
      ]
      egress_rules = [
        { protocol = "tcp", rule_no = 100, action = "allow", cidr_block = "10.0.0.0/16", from_port = 1024, to_port = 65535 }
      ]
    }
  }

  # Flow Logs
  flow_logs_enabled      = true
  flow_logs_traffic_type = "ALL"
  flow_logs_file_format  = "parquet"

  # Route53
  create_route53 = false
  route53_zone   = "example.internal"

  # Endpoints
  enable_s3_endpoint         = true
  service_name_s3            = "com.amazonaws.us-east-1.s3"
  s3_endpoint_type           = "Gateway"

  enable_ec2_endpoint        = true
  service_name_ec2           = "com.amazonaws.us-east-1.ec2"
  ec2_endpoint_type          = "Interface"
  ec2_private_dns_enabled    = true

  enable_nlb_endpoint        = false
  service_name_nlb           = "com.amazonaws.us-east-2.elasticloadbalancing"
  nlb_endpoint_type          = "Interface"
  nlb_private_dns_enabled    = true
  endpoint_sg_id             = module.endpoint_security_group.sg_id

  # ALB
  create_alb                  = true
  internal                    = false
  alb_sg_id                   = module.alb_security_group.sg_id
  enable_deletion_protection = false
  access_logs = {
    enabled = false
    bucket  = ""
    prefix  = ""
  }
  alb_certificate_arn = ""

  # NLB
  create_nlb  = true
  is_internal = false
  nlb_sg_id   = module.nlb_security_group.sg_id

  # Tags
  bu      = "ot"
  program = "ot"
  app     = "bp"
  env     = "d"
  team    = "infra"
  region  = "us-east-1"

  # Key Pair
  create_key_pair        = true
  create_private_key     = true
  key_pair_name          = "otbp-key"
  private_key_algorithm  = "RSA"
  private_key_rsa_bits   = 4096
  public_key_path        = ""
  key_output_dir         = "/home/nikita/Downloads/terraform_code/keys"
}

```
## Resources

| Name | Type |
|------|------|
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_flow_log.vpc_flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_main_route_table_association.default_public_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/main_route_table_association) | resource |
| [aws_nat_gateway.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.additional_private_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.additional_public_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.default_public_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.private_route_nat_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route53_zone.vpc_route53](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route_table.private_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.database_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_subnets_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_s3_bucket.flow_logs_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_subnet.database_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_caller_identity.current_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |


## Inputs

| Name                                                                                                                                                   | Description                                                              | Type                                                                                                               | Default               | Required |
|--------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|-----------------------|:--------:|
| <a name="input_additional_private_routes"></a> [additional\_private\_routes](#input\_additional\_private\_routes)                                      | List of private subnets routes with map                                  | <pre>list(object({<br/>    destination_cidr_block = string<br/>    gateway_id             = string<br/>  }))</pre> | `[]`                  |    no    |
| <a name="input_additional_public_routes"></a> [additional\_public\_routes](#input\_additional\_public\_routes)                                         | List of public subnets routes with map                                   | <pre>map(object({<br/>    destination_cidr_block = string<br/>    gateway_id             = string<br/>  }))</pre>  | `{}`                  |    no    |
| <a name="input_azs"></a> [azs](#input\_azs)                                                                                                            | A list of availability zones names or ids in the region                  | `list(string)`                                                                                                     | `[]`                  |    no    |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block)                                                                                     | The IPv4 CIDR block for the VPC.                                         | `string`                                                                                                           | `"10.0.0.0/16"`       |    no    |
| <a name="input_database_subnets"></a> [database\_subnets](#input\_database\_subnets)                                                                   | A list of database subnets inside the VPC                                | `list(string)`                                                                                                     | `[]`                  |    no    |
| <a name="input_database_subnets_tags"></a> [database\_subnets\_tags](#input\_database\_subnets\_tags)                                                  | Additional tags for the database subnets                                 | `map(string)`                                                                                                      | `{}`                  |    no    |
| <a name="input_enable_network_address_usage_metrics"></a> [enable\_network\_address\_usage\_metrics](#input\_enable\_network\_address\_usage\_metrics) | Determines whether network address usage metrics are enabled for the VPC | `bool`                                                                                                             | `false`               |    no    |
| <a name="input_flow_logs_enabled"></a> [flow\_logs\_enabled](#input\_flow\_logs\_enabled)                                                              | Whether to enable VPC flow logs or not                                   | `bool`                                                                                                             | `false`               |    no    |
| <a name="input_flow_logs_file_format"></a> [flow\_logs\_file\_format](#input\_flow\_logs\_file\_format)                                                | The format for the flow log. Valid values: plain-text, parquet           | `string`                                                                                                           | `"parquet"`           |    no    |
| <a name="input_flow_logs_traffic_type"></a> [flow\_logs\_traffic\_type](#input\_flow\_logs\_traffic\_type)                                             | The type of traffic to capture. Valid values: ACCEPT,REJECT, ALL         | `string`                                                                                                           | `"ALL"`               |    no    |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy)                                                                   | A tenancy option for instances launched into the VPC                     | `string`                                                                                                           | `"default"`           |    no    |
| <a name="input_name"></a> [name](#input\_name)                                                                                                         | Name to be used on all the resources as identifier                       | `string`                                                                                                           | n/a                   |   yes    |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets)                                                                      | A list of private subnets inside the VPC                                 | `list(string)`                                                                                                     | `[]`                  |    no    |
| <a name="input_private_subnets_tags"></a> [private\_subnets\_tags](#input\_private\_subnets\_tags)                                                     | Additional tags for the private subnets                                  | `map(string)`                                                                                                      | `{}`                  |    no    |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets)                                                                         | A list of public subnets inside the VPC                                  | `list(string)`                                                                                                     | `[]`                  |    no    |
| <a name="input_public_subnets_tags"></a> [public\_subnets\_tags](#input\_public\_subnets\_tags)                                                        | Additional tags for the public subnets                                   | `map(string)`                                                                                                      | `{}`                  |    no    |
| <a name="input_route53_zone"></a> [route53\_zone](#input\_route53\_zone)                                                                               | Name of the private route53 hosted zone                                  | `string`                                                                                                           | `"non-prod.internal"` |    no    |
| <a name="input_tags"></a> [tags](#input\_tags)                                                                                                         | A map of tags to add to all resources                                    | `map(string)`                                                                                                      | `{}`                  |    no    |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags)                                                                                           | Additional tags for the VPC                                              | `map(string)`                                                                                                      | `{}`                  |    no    |
 
## Output


| Name | Description |
|------|-------------|
| <a name="output_vpc_id"></a> [vpc_id](#output_vpc_id) | ID of the VPC |
| <a name="output_vpc_cidr_block"></a> [vpc_cidr_block](#output_vpc_cidr_block) | CIDR block of the VPC |
| <a name="output_igw_id"></a> [igw_id](#output_igw_id) | Internet Gateway ID |
| <a name="output_nat_gateway_ids"></a> [nat_gateway_ids](#output_nat_gateway_ids) | List of NAT Gateway IDs |
| <a name="output_public_rt_id"></a> [public_rt_id](#output_public_rt_id) | Public route table ID |
| <a name="output_private_rt_id"></a> [private_rt_id](#output_private_rt_id) | Private route table ID |
| <a name="output_flow_logs_bucket_arn"></a> [flow_logs_bucket_arn](#output_flow_logs_bucket_arn) | ARN of the Flow Logs S3 bucket |
| <a name="output_vpc_flow_log_arn"></a> [vpc_flow_log_arn](#output_vpc_flow_log_arn) | ARN of the VPC flow log |
| <a name="output_route53_zone_id"></a> [route53_zone_id](#output_route53_zone_id) | Private Route53 Zone ID |
| <a name="output_s3_endpoint"></a> [s3_endpoint](#output_s3_endpoint) | S3 VPC endpoint details |
| <a name="output_ec2_endpoint"></a> [ec2_endpoint](#output_ec2_endpoint) | EC2 VPC endpoint details |
| <a name="output_nlb_endpoint"></a> [nlb_endpoint](#output_nlb_endpoint) | NLB VPC endpoint details |
| <a name="output_alb_arn"></a> [alb_arn](#output_alb_arn) | ARN of the ALB |
| <a name="output_alb_dns_name"></a> [alb_dns_name](#output_alb_dns_name) | DNS name of the ALB |
| <a name="output_alb_zone_id"></a> [alb_zone_id](#output_alb_zone_id) | Zone ID of the ALB |
| <a name="output_alb_http_listener_arn"></a> [alb_http_listener_arn](#output_alb_http_listener_arn) | HTTP Listener ARN for ALB |
| <a name="output_alb_https_listener_arn"></a> [alb_https_listener_arn](#output_alb_https_listener_arn) | HTTPS Listener ARN for ALB |
| <a name="output_nlb_arn"></a> [nlb_arn](#output_nlb_arn) | ARN of the NLB |
| <a name="output_alb_sg_id"></a> [alb_sg_id](#output_alb_sg_id) | Security Group ID for ALB |
| <a name="output_nlb_sg_id"></a> [nlb_sg_id](#output_nlb_sg_id) | Security Group ID for NLB |
| <a name="output_endpoint_sg_id"></a> [endpoint_sg_id](#output_endpoint_sg_id) | Security Group ID for Endpoint |
| <a name="output_created_key_pair_name"></a> [created_key_pair_name](#output_created_key_pair_name) | Name of the created key pair |
| <a name="output_generated_private_key_path"></a> [generated_private_key_path](#output_generated_private_key_path) | Path of the generated private key |
| <a name="output_subnet_ids"></a> [subnet_ids](#output_subnet_ids) | Map of subnet names to subnet IDs |


## Contributors

- [Piyush Upadhyay](https://github.com/piiiyuushh)
- [Nikita Joshi](https://github.com/jnikita19)


