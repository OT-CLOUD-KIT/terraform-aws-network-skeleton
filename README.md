## Terraform AWS Network Skeleton

A terraform module which creates network skeleton on AWS with best practices in terms of network security, cost and optimization.

## Architecture

![](https://raw.githubusercontent.com/OT-CLOUD-KIT/terraform-aws-network-skeleton/refs/heads/main/assets/network-skeleton.gif)

## Providers

| Name                                              | Version  |
|---------------------------------------------------|----------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.82.2   |

## Usage

```hcl
module "network-skeleton" {
  source     = "OT-CLOUD-KIT/network-skeleton/aws"
  version    = "1.0.4"
  name       = "testing"
  cidr_block = "10.10.0.0/16"
  tags = {
    environment = "dev"
  }
  vpc_tags = {
    vpc = "shared"
  }
  public_subnets = ["10.10.0.0/20", "10.10.16.0/20"]
  azs            = ["us-west-2a", "us-west-2b"]
  public_subnets_tags = {
    subnet_type = "public"
  }
  private_subnets = ["10.10.32.0/20", "10.10.48.0/20"]
  private_subnets_tags = {
    subnet_type = "private"
  }
  database_subnets = ["10.10.64.0/20", "10.10.80.0/20"]
  database_subnets_tags = {
    subnet_type = "database"
  }
  additional_private_routes = [
    {
      destination_cidr_block = "20.0.0.0/16"
      gateway_id             = "pxc-00a12c2c206403cfa"
    }
  ]
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

## Outputs

| Name                                                                                                                           | Description                                                     |
|--------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------|
| <a name="output_additional_private_routes"></a> [additional\_private\_routes](#output\_additional\_private\_routes)            | List of additional private routes                               |
| <a name="output_database_subnets"></a> [database\_subnets](#output\_database\_subnets)                                         | List of IDs of database subnets                                 |
| <a name="output_database_subnets_cidr_blocks"></a> [database\_subnets\_cidr\_blocks](#output\_database\_subnets\_cidr\_blocks) | List of cidr\_blocks of database subnets                        |
| <a name="output_default_network_acl_id"></a> [default\_network\_acl\_id](#output\_default\_network\_acl\_id)                   | The ID of the default network ACL                               |
| <a name="output_default_route_table_id"></a> [default\_route\_table\_id](#output\_default\_route\_table\_id)                   | The ID of the default route table                               |
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id)          | The ID of the security group created by default on VPC creation |
| <a name="output_flow_logs_bucket_arn"></a> [flow\_logs\_bucket\_arn](#output\_flow\_logs\_bucket\_arn)                         | The ARN of the Flow Log bucket                                  |
| <a name="output_igw_id"></a> [igw\_id](#output\_igw\_id)                                                                       | The ID of the Internet Gateway                                  |
| <a name="output_nat_gateway_id"></a> [nat\_gateway\_id](#output\_nat\_gateway\_id)                                             | List of IDs of nat gateway                                      |
| <a name="output_nat_gateway_ips"></a> [nat\_gateway\_ips](#output\_nat\_gateway\_ips)                                          | List of nat gateway IPs                                         |
| <a name="output_private_route_table_id"></a> [private\_route\_table\_id](#output\_private\_route\_table\_id)                   | The ID of the private route table                               |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets)                                            | List of IDs of private subnets                                  |
| <a name="output_private_subnets_cidr_blocks"></a> [private\_subnets\_cidr\_blocks](#output\_private\_subnets\_cidr\_blocks)    | List of cidr\_blocks of private subnets                         |
| <a name="output_public_route_table_id"></a> [public\_route\_table\_id](#output\_public\_route\_table\_id)                      | The ID of the public route table                                |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets)                                               | List of IDs of public subnets                                   |
| <a name="output_public_subnets_cidr_blocks"></a> [public\_subnets\_cidr\_blocks](#output\_public\_subnets\_cidr\_blocks)       | List of cidr\_blocks of public subnets                          |
| <a name="output_route53_zone_id"></a> [route53\_zone\_id](#output\_route53\_zone\_id)                                          | Zone id for the vpc route53                                     |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block)                                             | The CIDR block of the VPC                                       |
| <a name="output_vpc_flow_log_arn"></a> [vpc\_flow\_log\_arn](#output\_vpc\_flow\_log\_arn)                                     | The ARN of the Flow Log                                         |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id)                                                                       | The ID of the VPC                                               |
