module "network" {
  source = "./module"

  name                                 = var.name
  cidr_block                           = var.cidr_block
  instance_tenancy                     = var.instance_tenancy
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics
  azs                                  = var.azs
  public_subnets                       = var.public_subnets
  private_subnets                      = var.private_subnets
  route53_zone                         = var.route53_zone
  flow_logs_enabled                    = var.flow_logs_enabled
  additional_public_routes             = var.additional_public_routes
  additional_private_routes            = var.additional_private_routes
  tags                                 = var.tags
  vpc_tags                             = var.vpc_tags
  public_subnets_tags                  = var.public_subnets_tags
  private_subnets_tags                 = var.private_subnets_tags
  database_subnets_tags                = var.database_subnets_tags
  create_database_subnets              = var.create_database_subnets
  create_igw                           = var.create_igw
  create_nat_gateway                   = var.create_nat_gateway
  create_public_nacl                   = var.create_public_nacl
  create_private_nacl                  = var.create_private_nacl
  create_private_route_table           = var.create_private_route_table
  create_public_route_table            = var.create_public_route_table
  create_private_subnets               = var.create_private_subnets
  create_public_subnets                = var.create_public_subnets
  create_route53                       = var.create_route53
  create_nacl                          = var.create_nacl
  database_subnets                     = var.database_subnets
  enable_s3_endpoint                   = var.enable_s3_endpoint
  enable_ec2_endpoint                  = var.enable_ec2_endpoint
  enable_nlb_endpoint                  = var.enable_nlb_endpoint
  enable_endpoint_sg                   = var.enable_endpoint_sg
  endpoint_sg_rules                    = var.endpoint_sg_rules
  service_name_s3                      = var.service_name_s3
  s3_endpoint_type                     = var.s3_endpoint_type
  service_name_ec2                     = var.service_name_ec2
  ec2_endpoint_type                    = var.ec2_endpoint_type
  ec2_private_dns_enabled              = var.ec2_private_dns_enabled
  service_name_nlb                     = var.service_name_nlb
  nlb_endpoint_type                    = var.nlb_endpoint_type
  nlb_private_dns_enabled              = var.nlb_private_dns_enabled


}
