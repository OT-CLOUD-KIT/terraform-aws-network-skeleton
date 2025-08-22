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
      "kubernetes.io/cluster/${var.cluster_name}-eks-cluster" = "owned"
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
  availability_zone = local.subnets[count.index].avail_zone

  tags = merge(
    {
      Name = local.subnets[count.index].name
      "kubernetes.io/cluster/${var.cluster_name}-eks-cluster" = "owned"
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
    },
    local.common_tags
  )
}

######################################
# Elastic IP for NAT
######################################
resource "aws_eip" "nat" {
  count  = var.create_nat_gateway ? 1 : 0
  domain = "vpc"

  tags = merge(
    {
      Name = "${local.base_name}-nat-eip"
    },
    local.common_tags
  )

  depends_on = [aws_internet_gateway.igw]
}

######################################
# NAT Gateway
######################################
resource "aws_nat_gateway" "nat_gateway" {
  count         = var.create_nat_gateway ? 1 : 0
  subnet_id     = local.public_subnet_ids[0]
  allocation_id = aws_eip.nat[0].id

  tags = merge(
    {
      Name = "${local.base_name}-nat"
    },
    local.common_tags
  )

  depends_on = [aws_internet_gateway.igw]
}

######################################
# Route Tables
######################################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.public_rt_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    {
      Name = "${local.base_name}-public-rt"
    },
    local.common_tags
  )
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = var.private_rt_cidr_block
    nat_gateway_id = var.create_nat_gateway ? aws_nat_gateway.nat_gateway[0].id : null
  }

  tags = merge(
    {
      Name = "${local.base_name}-private-rt"
    },
    local.common_tags
  )
}

resource "aws_route_table_association" "public_rt_association" {
  for_each = { for idx in var.public_subnet_indexes : idx => aws_subnet.subnets[idx].id }

  subnet_id      = each.value
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt_association" {
  for_each = {
    for idx, subnet in aws_subnet.subnets : idx => subnet.id
    if !(contains(var.public_subnet_indexes, idx))
  }


  subnet_id      = each.value
  route_table_id = aws_route_table.private_rt.id
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
# VPC Endpoints
######################################
resource "aws_vpc_endpoint" "s3" {
  count             = var.enable_s3_endpoint ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  service_name      = var.service_name_s3
  vpc_endpoint_type = var.s3_endpoint_type
  route_table_ids   = [aws_route_table.private_rt.id]

  tags = merge(
    {
      Name = "${local.base_name}-s3-endpoint"
    },
    local.common_tags
  )
}




resource "aws_vpc_endpoint" "ec2" {
  count               = var.enable_ec2_endpoint ? 1 : 0
  vpc_id              = aws_vpc.vpc.id
  service_name        = var.service_name_ec2
  vpc_endpoint_type   = var.ec2_endpoint_type
  subnet_ids          = local.selected_subnet_ids
  private_dns_enabled = var.ec2_private_dns_enabled
  security_group_ids  = var.endpoint_sg_id != "" ? [var.endpoint_sg_id] : null

  tags = merge(
    {
      Name = "${local.base_name}-ec2-endpoint"
    },
    local.common_tags
  )
}

resource "aws_vpc_endpoint" "nlb" {
  count               = var.enable_nlb_endpoint ? 1 : 0
  vpc_id              = aws_vpc.vpc.id
  service_name        = var.service_name_nlb
  vpc_endpoint_type   = var.nlb_endpoint_type
  subnet_ids          = var.nlb_endpoint_type == "Interface" ? local.private_subnet_ids : null
  private_dns_enabled = var.nlb_private_dns_enabled
  security_group_ids  = var.nlb_endpoint_type == "Interface" && var.endpoint_sg_id != "" ? [var.endpoint_sg_id] : null

  tags = merge(
    {
      Name = "${local.base_name}-nlb-endpoint"
    },
    local.common_tags
  )
}

######################################
# ALB
######################################
resource "aws_lb" "alb" {
  count                     = var.create_alb ? 1 : 0
  name                      = "${local.base_name}-alb"
  internal                  = var.internal
  load_balancer_type        = "application"
  subnets                   = var.internal ? local.private_subnet_ids : local.public_subnet_ids

  security_groups           = var.alb_sg_id != "" ? [var.alb_sg_id] : null
  enable_deletion_protection = var.enable_deletion_protection

  dynamic "access_logs" {
    for_each = var.access_logs.enabled && var.access_logs.bucket != null && var.access_logs.prefix != null ? [1] : []
    content {
      bucket  = var.access_logs.bucket
      prefix  = var.access_logs.prefix
      enabled = true
    }
  }

  tags = merge(
    {
      Name = "${local.base_name}-alb"
    },
    local.common_tags
  )
}

resource "aws_lb_listener" "alb_http_listener" {
  count             = var.create_alb ? 1 : 0
  load_balancer_arn = aws_lb.alb[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "alb_https_listener" {
  count             = trim(var.alb_certificate_arn, " ") == "" ? 0 : 1
  load_balancer_arn = aws_lb.alb[0].arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.alb_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

######################################
# NLB
######################################
resource "aws_lb" "nlb" {
  count                     = var.create_nlb ? 1 : 0
  name                      = "${local.base_name}-nlb"
  internal                  = var.is_internal
  load_balancer_type        = "network"
  subnets                   = var.is_internal ? local.private_subnet_ids : local.public_subnet_ids
  enable_deletion_protection = var.enable_deletion_protection
  security_groups           = var.nlb_sg_id != "" ? [var.nlb_sg_id] : null

  tags = merge(
    {
      Name = "${local.base_name}-nlb"
    },
    local.common_tags
  )
}


################## key pair ######################

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
