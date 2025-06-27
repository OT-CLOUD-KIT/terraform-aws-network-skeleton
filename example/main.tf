module "naming" {
  source   = "git@github.com:OT-CLOUD-KIT/terraform-aws-naming.git?ref=dev"
  bu       = var.bu
  env      = var.env
  app      = var.app
  tenant   = var.tenant
  resource = var.resource
}

module "standard_tags" {
  source = "git@github.com:OT-CLOUD-KIT/terraform-aws-standard-tagging.git?ref=dev"

  bu      = var.bu
  program = var.program
  app     = var.app
  team    = var.team
  region  = var.region
  env     = var.env
}


module "network" {
  source = "git@github.com:OT-CLOUD-KIT/terraform-aws-network-skeleton.git?ref=Feature"

  region                               = var.region
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
  bu                                   = var.bu
  program                              = var.program
  team                                 = var.team
  app                                  = var.app
  env                                  = var.env
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
  database_ports                       = var.database_ports
  create_alb                           = var.create_alb
  create_sg                            = var.create_sg
  existing_sg_id                       = var.existing_sg_id
  alb_certificate_arn                  = var.alb_certificate_arn
  enable_deletion_protection           = var.enable_deletion_protection
  provisioner                          = var.provisioner
  access_logs                          = var.access_logs
  logs_bucket                          = ""

}











