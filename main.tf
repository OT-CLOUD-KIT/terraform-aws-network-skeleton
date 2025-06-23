# Resource block for creation of VPC
resource "aws_vpc" "vpc" {
  cidr_block                           = var.cidr_block
  enable_dns_hostnames                 = true
  enable_dns_support                   = true
  instance_tenancy                     = var.instance_tenancy
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics
  tags = merge(
    { "Name" = format("%s-vpc", var.name) },
    var.tags,
    var.vpc_tags
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
    { "Name" = format("%s-route53-zone", var.name) },
    var.tags
  )
}

# Resource block for internet gateway setup
resource "aws_internet_gateway" "igw" {
  count  = var.create_igw ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    { "Name" = format("%s-igw", var.name) },
    var.tags
  )
}

# Public route table creation (based on create_public_route_table)
resource "aws_route_table" "public_route_table" {
  count  = var.create_public_route_table ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    { "Name" = format("%s-public-rt", var.name) },
    var.tags
  )
}

# Default route for public route table (if public route table exists)
resource "aws_route" "default_public_route" {
  count                  = var.create_igw && var.create_public_route_table ? 1 : 0
  route_table_id         = aws_route_table.public_route_table[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id
}

# Updating main route table to public route table (based on create_public_route_table)
resource "aws_main_route_table_association" "default_public_route" {
  count          = var.create_public_route_table ? 1 : 0
  route_table_id = aws_route_table.public_route_table[0].id
  vpc_id         = aws_vpc.vpc.id
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
    { "Name" = format("${var.name}-public-%s", element(var.azs, count.index)) },
    var.tags,
    var.public_subnets_tags
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
    { "Name" = format("${var.name}-private-%s", element(var.azs, count.index)) },
    var.tags,
    var.private_subnets_tags
  )
}

# Private route table creation (based on create_private_route_table)
resource "aws_route_table" "private_route_table" {
  count  = var.create_private_route_table ? length(var.azs) : 0
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    { "Name" = format("%s-private-rt-%s", var.name, element(var.azs, count.index)) },
    var.tags
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
  count  = var.create_nacl && var.create_nat_gateway ? length(var.azs) : 0
  domain = "vpc"

  tags = merge(
    { "Name" = format("%s-eip-%s", var.name, element(var.azs, count.index)) },
    var.tags
  )

  depends_on = [aws_internet_gateway.igw]
}

# NAT Gateway Creation (condition on create_nacl)
resource "aws_nat_gateway" "nat_gateway" {
  count         = var.create_nat_gateway && length(aws_subnet.public_subnet) > 0 ? 1 : 0
  subnet_id     = aws_subnet.public_subnet[0].id
  allocation_id = aws_eip.nat[count.index].id

  tags = merge(
    { "Name" = format("%s-nat-%s", var.name, element(var.azs, count.index)) },
    var.tags
  )

  depends_on = [aws_internet_gateway.igw]
}

# Database Subnet Creation
resource "aws_subnet" "database_subnet" {
  count                   = length(var.database_subnets) > 0 ? length(var.database_subnets) : 0
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = element(var.azs, count.index)
  cidr_block              = var.database_subnets[count.index]
  map_public_ip_on_launch = false
  tags = merge(
    { "Name" = format("%s-db-%s", var.name, element(var.azs, count.index)) },
    var.tags,
    var.database_subnets_tags
  )
}

# VPC Flow logs bucket creation
data "aws_caller_identity" "current_account" {}

resource "aws_s3_bucket" "flow_logs_bucket" {
  count  = var.flow_logs_enabled ? 1 : 0
  bucket = format("%s-%s-flow-logs-bucket", var.name, data.aws_caller_identity.current_account.account_id)
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
  count  = var.create_public_nacl ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.name}-public-nacl"
  }
}

resource "aws_network_acl" "private" {
  count  = var.create_private_nacl ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.name}-private-nacl"
  }
}

resource "aws_network_acl_association" "public_assoc" {
  count          = var.create_nacl && var.create_public_subnets && length(aws_subnet.public_subnet) > 0 ? length(aws_subnet.public_subnet) : 0
  subnet_id      = aws_subnet.public_subnet[count.index].id
  network_acl_id = aws_network_acl.public[0].id
}

resource "aws_network_acl_association" "private_assoc" {
  count          = var.create_nacl && var.create_private_subnets ? length(aws_subnet.private_subnet) : 0
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


  tags = {
    Name = "${var.name}-s3-endpoint"
  }
}

# Security Group for VPC Endpoints
resource "aws_security_group" "endpoint_sg" {
  count       = var.enable_endpoint_sg ? 1 : 0
  name        = "${var.name}-vpc-endpoint-sg"
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
    { "Name" = format("%s-vpc-endpoint-sg", var.name) },
    var.tags
  )
}

#EC2 Interface VPC Endpoint
resource "aws_vpc_endpoint" "ec2" {
  count               = var.enable_ec2_endpoint ? 1 : 0
  vpc_id              = aws_vpc.vpc.id
  service_name        = var.ec2_endpoint_type
  vpc_endpoint_type   = var.ec2_endpoint_type
  subnet_ids          = aws_subnet.private_subnet[*].id
  security_group_ids  = [aws_security_group.endpoint_sg[0].id]
  private_dns_enabled = var.ec2_private_dns_enabled

  tags = {
    Name = "${var.name}-ec2-endpoint"
  }
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

  tags = {
    Name = "${var.name}-nlb-endpoint"
  }
  depends_on = [
    aws_security_group.endpoint_sg[0]
  ]
}
