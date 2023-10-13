resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    {
      "Name" = format("%s", var.vpc_name)
    },
    var.tags,
  )
}

resource "aws_flow_log" "vpc_flow_logs" {
  count                = var.enable_vpc_logs == true ? 1 : 0
  log_destination      = var.logs_bucket_arn
  log_destination_type = var.log_destination_type
  traffic_type         = var.traffic_type
  vpc_id               = aws_vpc.main.id
}

resource "aws_internet_gateway" "igw" {
  count  = var.enable_igw_publicRouteTable_PublicSubnets_resource == true ? 1 : 0
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      "Name" = format("%s", var.igw_name)
    },
    var.tags,
  )
}

module "publicRouteTable" {
  count      = var.enable_igw_publicRouteTable_PublicSubnets_resource == true ? 1 : 0
  source     = "OT-CLOUD-KIT/route-table/aws"
  version    = "0.0.1"
  cidr       = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw[count.index].id
  name    = format("%s", var.pub_rt_name)
  vpc_id     = aws_vpc.main.id
  tags       = var.tags
}

module "PublicSubnets" {
  count              = var.enable_igw_publicRouteTable_PublicSubnets_resource == true ? 1 : 0
  source             = "OT-CLOUD-KIT/subnet/aws"
  version            = "0.0.2"
  availability_zones = var.avaialability_zones
  subnet_name        = format("%s", var.pub_subnet_name)
  route_table_id     = module.publicRouteTable[count.index].id
  subnets_cidr       = var.public_subnets_cidr
  vpc_id             = aws_vpc.main.id
  tags               = var.tags
}



module "nat-gateway" {
  count              = var.enable_nat_privateRouteTable_PrivateSubnets_resource == true ? 1 : 0
  source             = "OT-CLOUD-KIT/nat-gateway/aws"
  version            = "0.0.2"
  subnets_for_nat_gw = module.PublicSubnets[count.index].ids
  nat_name           = var.nat_name
  tags               = var.tags
}

module "privateRouteTable" {
  count      = var.enable_nat_privateRouteTable_PrivateSubnets_resource == true ? 1 : 0
  source     = "OT-CLOUD-KIT/route-table/aws"
  version    = "0.0.1"
  cidr       = "0.0.0.0/0"
  gateway_id = module.nat-gateway[count.index].ngw_id
  name       = format("%s", var.pvt_rt_ame)
  vpc_id     = aws_vpc.main.id
  tags       = var.tags
}

module "AppPrivateSubnets" {
  count              = var.enable_nat_privateRouteTable_PrivateSubnets_resource == true ? 1 : 0
  source             = "OT-CLOUD-KIT/subnet/aws"
  version            = "0.0.2"
  availability_zones = var.avaialability_zones
  subnet_name        = format("%s", var.App_pvt_subnet_name)
  route_table_id     = module.privateRouteTable[count.index].id
  subnets_cidr       = var.App_private_subnets_cidr
  vpc_id             = aws_vpc.main.id
  tags               = var.tags
}

module "DBPrivateSubnets" {
  count              = var.enable_nat_privateRouteTable_PrivateSubnets_resource == true ? 1 : 0
  source             = "OT-CLOUD-KIT/subnet/aws"
  version            = "0.0.2"
  availability_zones = var.avaialability_zones
  subnet_name        = format("%s", var.DB_pvt_subnet_name)
  route_table_id     = module.privateRouteTable[count.index].id
  subnets_cidr       = var.DB_private_subnets_cidr
  vpc_id             = aws_vpc.main.id
  tags               = var.tags
}

module "public_web_security_group" {
  count               = var.enable_public_web_security_group_resource == true ? 1 : 0
  source              = "OT-CLOUD-KIT/security-groups/aws"
  version             = "1.0.0"
  enable_whitelist_ip = true
  name_sg             = var.public_web_sg_name
  vpc_id              = aws_vpc.main.id
  ingress_rule = {
    rules = {
      rule_list = [
        {
          description  = "Rule for port 80"
          from_port    = 80
          to_port      = 80
          protocol     = "tcp"
          cidr         = ["0.0.0.0/0"]
          source_SG_ID = []
        },
        {
          description  = "Rule for port 443"
          from_port    = 443
          to_port      = 443
          protocol     = "tcp"
          cidr         = ["0.0.0.0/0"]
          source_SG_ID = []
        }
      ]
    }
  }
}

module "pub_alb" {
  count                      = var.enable_pub_alb_resource == true ? 1 : 0
  source                     = "OT-CLOUD-KIT/alb/aws"
  version                    = "0.0.4"
  alb_name                   = var.alb_name
  internal                   = var.alb_type
  logs_bucket                = var.logs_bucket
  security_groups_id         = [module.public_web_security_group[count.index].sg_id]
  subnets_id                 = var.alb_type == false ? module.PublicSubnets[count.index].ids : module.AppPrivateSubnets[count.index].ids
  tags                       = var.tags
  enable_logging             = var.enable_alb_logging
  enable_deletion_protection = var.enable_deletion_protection
  alb_certificate_arn        = var.alb_certificate_arn
}

resource "aws_route53_zone" "private_hosted_zone" {
  count = var.enable_aws_route53_zone_resource == true ? 1 : 0
  name  = var.pvt_zone_name
  vpc {
    vpc_id = aws_vpc.main.id
  }
}