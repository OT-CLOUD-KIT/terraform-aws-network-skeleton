## Terraform AWS Network Skeleton

A terraform module which creates network skeleton on AWS with best practices in terms of network security, cost and optimization.

## Architecture

![_network_skeleton drawio](https://github.com/user-attachments/assets/cc42a4fb-b88c-41f6-846e-a6270babcf86)


## Providers

| Name                                              | Version  |
|---------------------------------------------------|----------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.82.2   |
| <a name="terraform_module"></a> [Terraform](Terraform\module) | >= 1.12.1|

## Usage

```hcl
module "network" {
  source = "OT-CLOUD-KIT/terraform-aws-network-skeleton"

  name                                 = "dev-ot-cloud-vpc"
  cidr_block                           = "10.1.0.0/16"
  instance_tenancy                     = "default"
  enable_network_address_usage_metrics = false
  azs                                  = ["us-east-1a", "us-east-1b"]
  public_subnets                       = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnets                      = ["10.1.12.0/24", "10.1.13.0/24", "10.1.14.0/24"]
  route53_zone                         = "non-prod.internal"
  flow_logs_enabled                    = false
  additional_public_routes             = {}
  additional_private_routes            = []
  tags = {
    Environment = "non-prod"
    Project     = "du-project"
  }
  vpc_tags = {
    Name = "dev-ot-cloud-vpc"
  }
  public_subnets_tags = {
    Tier = "public"
  }
  private_subnets_tags = {
    Tier = "application"
  }
  database_subnets_tags                = {}
  create_database_subnets              = false
  create_igw                           = true
  create_nat_gateway                   = false
  create_public_nacl                   = false
  create_private_nacl                  = false
  create_private_route_table           = true
  create_public_route_table            = true
  create_private_subnets               = true
  create_public_subnets                = true
  create_route53                       = false
  create_nacl                          = false
  database_subnets                     = []
  enable_s3_endpoint                   = true
  enable_ec2_endpoint                  = false
  enable_nlb_endpoint                  = false
  enable_endpoint_sg                   = false
  endpoint_sg_rules = [
    {
      description = "HTTPS from VPC"
      type        = "ingress"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    },
    {
      description = "DNS from VPC"
      type        = "ingress"
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]
  service_name_s3          = "com.amazonaws.us-east-1.s3"
  s3_endpoint_type         = "Gateway"
  service_name_ec2         = "com.amazonaws.us-east-1.ec2"
  ec2_endpoint_type        = "Interface"
  ec2_private_dns_enabled  = true
  service_name_nlb         = "com.amazonaws.us-east-1.elasticloadbalancing"
  nlb_endpoint_type        = "Interface"
  nlb_private_dns_enabled  = true

  # For ALB
  create_alb                 = true
  create_sg                  = true
  existing_sg_id             = null                        # Leave null to create new SG
  alb_certificate_arn        = ""  # Replace with your ACM ARN
  enable_deletion_protection = false                       # Change to true if needed
  access_logs                = false                       # Enable if using logs
  create_nlb                 = true
  is_internal                = false                       # true if internal NLB
  nlb_sg_id                  = module.nlb_security_group[0].sg_id

}


```

## Resources

| Name                                                                                                                                                                | Type        |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip)                                                                      | resource    |
| [aws_flow_log.vpc_flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log)                                                   | resource    |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)                                            | resource    |
| [aws_main_route_table_association.default_public_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/main_route_table_association)   | resource    |
| [aws_nat_gateway.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway)                                              | resource    |
| [aws_route.additional_private_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)                                             | resource    |
| [aws_route.additional_public_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)                                              | resource    |
| [aws_route.default_public_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)                                                 | resource    |
| [aws_route.private_route_nat_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)                                        | resource    |
| [aws_route53_zone.vpc_route53](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone)                                            | resource    |
| [aws_route_table.private_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                                      | resource    |
| [aws_route_table.public_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                                       | resource    |
| [aws_route_table_association.database_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource    |
| [aws_route_table_association.private_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)  | resource    |
| [aws_route_table_association.public_subnets_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)       | resource    |
| [aws_s3_bucket.flow_logs_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)                                             | resource    |
| [aws_subnet.database_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                    | resource    |
| [aws_subnet.private_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                     | resource    |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                      | resource    |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)                                                                      | resource    |
| [aws_caller_identity.current_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                               | data source |
|[aws_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) |resource |
|[aws_lb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) |resource |


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

 |      Name                                                                                                                           | Description                                                     |
|--------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------|
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id)                                                                       | The ID of the VPC                                               |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block)                                             | The CIDR block of the VPC                                       |
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id)          | The ID of the default security group for the VPC                |
| <a name="output_default_network_acl_id"></a> [default\_network\_acl\_id](#output\_default\_network\_acl\_id)                   | The ID of the default network ACL                               |
| <a name="output_default_route_table_id"></a> [default\_route\_table\_id](#output\_default\_route\_table\_id)                   | The ID of the default route table                               |
| <a name="output_igw_id"></a> [igw\_id](#output\_igw\_id)                                                                       | The ID of the Internet Gateway                                  |
| <a name="output_public_route_table_id"></a> [public\_route\_table\_id](#output\_public\_route\_table\_id)                      | The ID of the public route table                                |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets)                                               | List of public subnet IDs                                       |
| <a name="output_public_subnets_cidr_blocks"></a> [public\_subnets\_cidr\_blocks](#output\_public\_subnets\_cidr\_blocks)       | CIDR blocks of public subnets                                   |
| <a name="output_route53_zone_id"></a> [route53\_zone\_id](#output\_route53\_zone\_id)                                          | Private Route53 zone ID                                         |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets)                                            | List of private subnet IDs                                      |
| <a name="output_private_subnets_cidr_blocks"></a> [private\_subnets\_cidr\_blocks](#output\_private\_subnets\_cidr\_blocks)    | CIDR blocks of private subnets                                  |
| <a name="output_private_route_table_id"></a> [private\_route\_table\_id](#output\_private\_route\_table\_id)                   | List of private route table IDs                                 |
| <a name="output_nat_gateway_ips"></a> [nat\_gateway\_ips](#output\_nat\_gateway\_ips)                                          | List of NAT Gateway IP addresses                                |
| <a name="output_nat_gateway_id"></a> [nat\_gateway\_id](#output\_nat\_gateway\_id)                                             | List of NAT Gateway IDs                                         |
| <a name="output_database_subnets"></a> [database\_subnets](#output\_database\_subnets)                                         | List of database subnet IDs                                     |
| <a name="output_database_subnets_cidr_blocks"></a> [database\_subnets\_cidr\_blocks](#output\_database\_subnets\_cidr\_blocks) | CIDR blocks of database subnets                                 |
| <a name="output_flow_logs_bucket_arn"></a> [flow\_logs\_bucket\_arn](#output\_flow\_logs\_bucket\_arn)                         | ARN of the S3 bucket for flow logs                              |
| <a name="output_vpc_flow_log_arn"></a> [vpc\_flow\_log\_arn](#output\_vpc\_flow\_log\_arn)                                     | ARN of the VPC flow log resource                                |
| <a name="output_public_nacl_id"></a> [public\_nacl\_id](#output\_public\_nacl\_id)                                             | ID of the public NACL                                           |
| <a name="output_private_nacl_id"></a> [private\_nacl\_id](#output\_private\_nacl\_id)                                          | ID of the private NACL                                          |
| <a name="output_s3_endpoint_id"></a> [s3\_endpoint\_id](#output\_s3\_endpoint\_id)                                             | The ID of the S3 VPC endpoint                                   |
| <a name="output_s3_endpoint_dns_entries"></a> [s3\_endpoint\_dns\_entries](#output\_s3\_endpoint\_dns\_entries)               | DNS entries for the S3 VPC endpoint                             |
| <a name="output_ec2_endpoint_id"></a> [ec2\_endpoint\_id](#output\_ec2\_endpoint\_id)                                          | The ID of the EC2 VPC endpoint                                  |
| <a name="output_ec2_endpoint_dns_entries"></a> [ec2\_endpoint\_dns\_entries](#output\_ec2\_endpoint\_dns\_entries)            | DNS entries for the EC2 VPC endpoint                            |
| <a name="output_nlb_endpoint_id"></a> [nlb\_endpoint\_id](#output\_nlb\_endpoint\_id)                                          | The ID of the NLB VPC endpoint                                  |
| <a name="output_nlb_endpoint_dns_entries"></a> [nlb\_endpoint\_dns\_entries](#output\_nlb\_endpoint\_dns\_entries)            | DNS entries for the NLB VPC endpoint                            |
| <a name="output_endpoint_security_group_id"></a> [endpoint\_security\_group\_id](#output\_endpoint\_security\_group\_id)      | The ID of the endpoint security group                           |
| <a name="output_all_vpc_endpoint_ids"></a> [all\_vpc\_endpoint\_ids](#output\_all\_vpc\_endpoint\_ids)                        | Map of all created VPC endpoint IDs                             |
| <a name="output_endpoint_sg_ingress_rules"></a> [endpoint\_sg\_ingress\_rules](#output\_endpoint\_sg\_ingress\_rules)         | List of ingress rules for the endpoint security group           |
| <a name="output_endpoint_sg_egress_rules"></a> [endpoint\_sg\_egress\_rules](#output\_endpoint\_sg\_egress\_rules)            | List of egress rules for the endpoint security group            |


## Contributors

- [Piyush Upadhyay](https://github.com/piiiyuushh)
- [Nikita Joshi](https://github.com/jnikita19)

