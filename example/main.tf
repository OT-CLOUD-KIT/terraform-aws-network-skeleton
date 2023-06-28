provider "aws" {
  region = var.region
}

data "aws_acm_certificate" "acm" {
  domain   = var.acm_certificate_domain
  statuses = var.statuses
}

module "network_skeleton" {
  source                                               = "../"
  vpc_name                                             = var.vpc_name
  cidr_block                                           = var.cidr_block
  enable_dns_hostnames                                 = true
  enable_vpc_logs                                      = false
  public_subnets_cidr                                  = var.public_subnets_cidr
  pvt_zone_name                                        = var.pvt_zone_name
  private_subnets_cidr                                 = var.private_subnets_cidr
  avaialability_zones                                  = var.avaialability_zones
  logs_bucket                                          = var.logs_bucket
  logs_bucket_arn                                      = var.logs_bucket_arn
  tags                                                 = var.tags
  public_web_sg_name                                   = var.public_web_sg_name
  alb_certificate_arn                                  = data.aws_acm_certificate.acm.arn
  igw_name                                             = "testing-igw"
  pub_rt_name                                          = "testing-pub-rt"
  pub_subnet_name                                      = "testing-pub-subnet"
  nat_name                                             = "testing-nat"
  pvt_rt_ame                                           = "testing-pvt-rt"
  pvt_subnet_name                                      = "testing-pvt-subnet"
  alb_name                                             = "testing-alb"
  enable_igw_publicRouteTable_PublicSubnets_resource   = true
  enable_nat_privateRouteTable_PrivateSubnets_resource = true
  enable_public_web_security_group_resource            = true
  enable_pub_alb_resource                              = true
  enable_aws_route53_zone_resource                     = true
}
