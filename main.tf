######################################
# VPC
######################################
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    {
      Name = "${local.base_name}-vpc"
      customer_code = var.Customer_Code
      "kubernetes.io/cluster/${var.env}-${var.program}-eks-cluster" = "owned"

    },
    local.common_tags
  )
}

######################################
# Subnets
######################################
resource "aws_subnet" "subnets" {
  count = length(local.subnets)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.subnets[count.index].cidr
  availability_zone = local.subnets[count.index].az

  tags = merge(
    {
      Name = local.subnets[count.index].name
      "kubernetes.io/cluster/${var.env}-${var.program}-eks-cluster" = "owned"
      Project = var.Project
    },
    local.common_tags
  )
}

######################################
# Internet Gateway
######################################
resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name = "${local.base_name}-igw"
      CC-Project = var.CC-Project
    },
    local.common_tags
  )
}

resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.rt["172263_RTB1-DEV_S1"].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

######################################
# Virtual Gateway
######################################

resource "aws_vpn_gateway" "vgw" {
  count = var.create_vgw ? 1 : 0

  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name = var.vgw_name
    },
    local.common_tags
  )
}

######################################
# Elastic IPs for NAT Gateways
######################################
resource "aws_eip" "nat" {
  count  = var.create_nat_gateway ? var.nat_gateway_count : 0
  domain = "vpc"

  tags = merge(
    {
      Name = "${local.base_name}-nat-eip-${count.index + 1}"
    },
    local.common_tags
  )

  depends_on = [aws_internet_gateway.igw]
}

######################################
# NAT Gateways
######################################
resource "aws_nat_gateway" "nat_gateway" {
  count         = var.create_nat_gateway ? var.nat_gateway_count : 0
  subnet_id = local.all_subnet_ids[count.index]
  allocation_id = aws_eip.nat[count.index].id

  tags = merge(
    {
      Name = "${local.base_name}-nat-${count.index + 1}"
    },
    local.common_tags
  )

  depends_on = [aws_internet_gateway.igw]
}



######################################
# Route Tables
######################################
resource "aws_route_table" "rt" {
  for_each = local.route_tables
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    { Name = each.key },
    local.common_tags,
    {CC = var.CC}
  )
}

#############################
# RT Association
############################
resource "aws_route_table_association" "rt_assoc" {
  count = length(local.route_table_associations)

  route_table_id = aws_route_table.rt[
    local.route_table_associations[count.index].rt_name
  ].id

  subnet_id = aws_subnet.subnets[
    local.route_table_associations[count.index].subnet_index
  ].id
}

######################################
# NACLs
######################################
resource "aws_network_acl" "nacls" {
  for_each = var.create_nacl ? local.nacl_config : {}

  vpc_id     = aws_vpc.vpc.id
  subnet_ids = each.value.subnet_ids

  tags = merge(
    {
      Name = each.value.name
    },
    local.common_tags
  )

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      protocol   = ingress.value.protocol
      rule_no    = ingress.value.rule_no
      action     = ingress.value.action
      cidr_block = ingress.value.cidr_block
      from_port  = ingress.value.from_port
      to_port    = ingress.value.to_port
    }
  }

  dynamic "egress" {
    for_each = each.value.egress
    content {
      protocol   = egress.value.protocol
      rule_no    = egress.value.rule_no
      action     = egress.value.action
      cidr_block = egress.value.cidr_block
      from_port  = egress.value.from_port
      to_port    = egress.value.to_port
    }
  }
}

######################################
# Flow Logs
######################################
data "aws_caller_identity" "current_account" {}

resource "aws_s3_bucket" "flow_logs_bucket" {
  count         = var.flow_logs_enabled ? 1 : 0
  bucket        = format("%s-flow-logs-bucket", data.aws_caller_identity.current_account.account_id)
  force_destroy = true
}

resource "aws_flow_log" "vpc_flow_log" {
  count                = var.flow_logs_enabled ? 1 : 0
  log_destination      = aws_s3_bucket.flow_logs_bucket[0].arn
  log_destination_type = "s3"
  traffic_type         = var.flow_logs_traffic_type
  vpc_id               = aws_vpc.vpc.id

  destination_options {
    file_format        = var.flow_logs_file_format
    per_hour_partition = true
  }
}

######################################
# Route53
######################################
resource "aws_route53_zone" "vpc_route53" {
  count = var.create_route53 ? 1 : 0
  name  = var.route53_zone

  vpc {
    vpc_id = aws_vpc.vpc.id
  }

  tags = merge(
    {
      Name = "${local.base_name}-route53"
    },
    local.common_tags
  )
}

######################################
# EC2 Key Pair (Generate and Save)
######################################

resource "tls_private_key" "ec2_key" {
  count     = var.create_key_pair && var.create_private_key ? 1 : 0
  algorithm = var.private_key_algorithm
  rsa_bits  = var.private_key_rsa_bits
}

resource "aws_key_pair" "key_pair" {
  count      = var.create_key_pair ? 1 : 0
  key_name   = var.key_pair_name
  public_key = var.create_private_key ? tls_private_key.ec2_key[0].public_key_openssh : file(var.public_key_path)

  tags = merge(
    {
      Name = "${local.base_name}-key"
    },
    local.common_tags
  )
}

resource "local_file" "private_key" {
  count           = var.create_key_pair && var.create_private_key ? 1 : 0
  content         = tls_private_key.ec2_key[0].private_key_pem
  filename        = "${var.key_output_dir}/${var.key_pair_name}.pem"
  file_permission = "0400"

  depends_on = [aws_key_pair.key_pair]
}
