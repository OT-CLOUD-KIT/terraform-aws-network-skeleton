# Resource block for creation of VPC
resource "aws_vpc" "vpc" {
  cidr_block                           = var.cidr_block
  enable_dns_hostnames                 = true
  enable_dns_support                   = true
  instance_tenancy                     = var.instance_tenancy
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics
  tags = merge(
    {
      Name = "${local.base_name}-vpc"
    },
    local.common_tags
  )
}

# Private route53 zone creation (based on create_route53)
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

# Resource block for internet gateway setup
resource "aws_internet_gateway" "igw" {
  count  = var.create_igw ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    {
      Name = "${local.base_name}-igw"
    },
    local.common_tags
  )
}

# Public route table creation
resource "aws_route_table" "public_route_table" {
  count  = var.create_public_route_table ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name = "${local.base_name}-public-rt"
    },
    local.common_tags
  )
}

resource "aws_route" "default_public_route" {
  count                   = var.create_igw && var.create_public_route_table ? 1 : 0
  route_table_id          = aws_route_table.public_route_table[0].id
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.igw[0].id
}

resource "aws_route_table_association" "public" {
  count          = var.create_public_route_table && var.create_public_subnets ? length(var.public_subnets) : 0
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table[0].id
}


# Additional Routes to public route table (condition on create_public_route_table)
resource "aws_route" "additional_public_route" {
  for_each               = var.create_public_route_table ? var.additional_public_routes : {}
  route_table_id         = aws_route_table.public_route_table[0].id
  gateway_id             = each.value.gateway_id
  destination_cidr_block = each.value.destination_cidr_block
}

# Public Subnets creation (based on create_private_subnets)
resource "aws_subnet" "public_subnet" {
  count                   = var.create_public_subnets ? length(var.public_subnets) : 0
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = element(var.azs, count.index)
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    {
      Name = "${local.base_name}-public-${count.index}"
    },
    local.common_tags
  )
}

# Private Subnets creation (based on create_private_subnets)
resource "aws_subnet" "private_subnet" {
  count                   = var.create_private_subnets ? length(var.private_subnets) : 0
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = element(var.azs, count.index)
  cidr_block              = var.private_subnets[count.index]
  map_public_ip_on_launch = false
  tags = merge(
    {
      Name = "${local.base_name}-application-${count.index}"
    },
    local.common_tags
  )
}

resource "aws_route_table" "private_route_table" {
  count  = var.create_private_route_table ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name = "${local.base_name}-private-rt"
    },
    local.common_tags
  )
}


# Private route table association (based on create_private_route_table)
resource "aws_route_table_association" "private_route_table_association" {
  count          = var.create_private_route_table && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[0].id
}

# Nat gateway elastic ip (condition on create_nacl)
resource "aws_eip" "nat" {
  count  = var.create_nat_gateway && var.create_public_subnets ? 1 : 0
  domain = "vpc"

  tags = merge(
    {
      Name = "${local.base_name}-nat-eip"
    },
    local.common_tags
  )

  depends_on = [aws_internet_gateway.igw]
}


# NAT Gateway Creation (condition on create_nacl)
resource "aws_nat_gateway" "nat_gateway" {
  count         = var.create_nat_gateway && var.create_public_subnets ? 1 : 0
  subnet_id     = aws_subnet.public_subnet[0].id
  allocation_id = aws_eip.nat[0].id

  tags = merge(
    {
      Name = "${local.base_name}-nat"
    },
    local.common_tags
  )

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route" "default_private_route" {
  count = var.create_private_route_table && var.create_nat_gateway ? 1 : 0

  route_table_id         = aws_route_table.private_route_table[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[0].id
}


# Database Subnet Creation
resource "aws_subnet" "database_subnet" {
  count             = length(var.database_subnets) > 0 ? length(var.database_subnets) : 0
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = element(var.azs, count.index)
  cidr_block              = var.database_subnets[count.index]
  map_public_ip_on_launch = false
  tags = merge(
    {
      Name = "${local.base_name}-db--${count.index}"
    },
    local.common_tags
  )
}

# VPC Flow logs bucket creation
data "aws_caller_identity" "current_account" {}

resource "aws_s3_bucket" "flow_logs_bucket" {
  count  = var.flow_logs_enabled ? 1 : 0
  bucket = format("%s-flow-logs-bucket", data.aws_caller_identity.current_account.account_id)
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

# NACL creation (based on create_nacl)
resource "aws_network_acl" "public" {
  count = var.create_public_nacl ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    {
      Name = "${local.base_name}-public-nacl"
    },
    local.common_tags
  )
}

resource "aws_network_acl" "private" {
  count = var.create_private_nacl ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    {
      Name = "${local.base_name}-private-nacl"
    },
    local.common_tags
  )
}

resource "aws_network_acl_association" "public_assoc" {
  count          = var.create_nacl && var.create_public_subnets && length(aws_subnet.public_subnet) > 0 ? length(aws_subnet.public_subnet) : 0
  subnet_id      = aws_subnet.public_subnet[count.index].id
  network_acl_id = aws_network_acl.public[0].id
}

resource "aws_network_acl_association" "private_assoc" {
 count = var.create_nacl && var.create_private_subnets ? length(aws_subnet.private_subnet) : 0
 subnet_id      = aws_subnet.private_subnet[count.index].id
  network_acl_id = aws_network_acl.private[0].id
}



###########################################################
# vpc endpoint
###########################################################

# S3 Gateway VPC Endpoint
resource "aws_vpc_endpoint" "s3" {
  count             = var.enable_s3_endpoint ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  service_name      = var.service_name_s3
  vpc_endpoint_type = var.s3_endpoint_type
  route_table_ids   = aws_route_table.private_route_table[*].id


  tags = merge(
    {
      Name = "${local.base_name}-s3-endpoint"
    },
    local.common_tags
  )
}

# Security Group for VPC Endpoints
resource "aws_security_group" "endpoint_sg" {
  count       = var.enable_endpoint_sg ? 1 : 0
  name        = "${local.base_name}-endpoint-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = [for rule in var.endpoint_sg_rules : rule if rule.type == "ingress"]
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = [for rule in var.endpoint_sg_rules : rule if rule.type == "egress"]
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = merge(
    {
      Name = "${local.base_name}-endpoint-sg"
    },
    local.common_tags
  )
}

#EC2 Interface VPC Endpoint
resource "aws_vpc_endpoint" "ec2" {
  count               = var.enable_ec2_endpoint ? 1 : 0
  vpc_id              = aws_vpc.vpc.id
  service_name        = var.service_name_ec2
  vpc_endpoint_type   = var.ec2_endpoint_type
  subnet_ids          = aws_subnet.private_subnet[*].id
  security_group_ids  = [aws_security_group.endpoint_sg[0].id]
  private_dns_enabled = var.ec2_private_dns_enabled

  tags = merge(
    {
      Name = "${local.base_name}-ec2-endpoint"
    },
    local.common_tags
  )
  depends_on = [
    aws_security_group.endpoint_sg[0]
  ]
}

# NLB Interface VPC Endpoint
resource "aws_vpc_endpoint" "nlb" {
  count               = var.enable_nlb_endpoint ? 1 : 0
  vpc_id              = aws_vpc.vpc.id
  service_name        = var.service_name_nlb
  vpc_endpoint_type   = var.nlb_endpoint_type
  subnet_ids          = aws_subnet.private_subnet[*].id
  security_group_ids  = [aws_security_group.endpoint_sg[0].id]
  private_dns_enabled = var.nlb_private_dns_enabled

  tags = merge(
    {
      Name = "${local.base_name}-nlb-endpoint"
    },
    local.common_tags
  )
  depends_on = [
    aws_security_group.endpoint_sg[0]
  ]
}






###############Public ALB #####################3



resource "aws_security_group" "alb_sg" {
  count  = var.create_sg ? 1 : 0
  name   = "${local.base_name}-alb-sg"
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      "Name"        = "${local.base_name}-alb-sg"
      "provisioner" = var.provisioner
    },
    local.common_tags,
  )
}

resource "aws_security_group_rule" "ingress_rule" {
  type                     = "ingress"
  for_each                 = local.security_group_ingress_rules
  description              = each.value.description
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = each.value.source_SG_ID == "" ? each.value.cidr : null
  source_security_group_id = each.value.source_SG_ID != "" ? each.value.source_SG_ID : null
  ipv6_cidr_blocks         = each.value.source_SG_ID == "" ? each.value.ipv6_cidr : null
security_group_id = aws_security_group.alb_sg[0].id
}

resource "aws_security_group_rule" "egress_rule" {
  type                     = "egress"
  for_each                 = local.security_group_egress_rules
  description              = each.value.description
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = each.value.source_SG_ID == "" ? each.value.cidr : null
  source_security_group_id = each.value.source_SG_ID != "" ? each.value.source_SG_ID : null
  ipv6_cidr_blocks         = each.value.source_SG_ID == "" ? each.value.ipv6_cidr : null
security_group_id = aws_security_group.alb_sg[0].id
}


resource "aws_lb" "alb" {
  count  = var.create_alb ? 1 : 0

  name                        = "${local.base_name}-alb"
  internal                    = var.internal
  load_balancer_type          = "application"
  subnets = var.internal ? aws_subnet.private_subnet[*].id : aws_subnet.public_subnet[*].id
    security_groups             = [var.create_sg ? aws_security_group.alb_sg[0].id : var.existing_sg_id]
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
count = trim(var.alb_certificate_arn, " ") == "" ? 0 : 1
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



