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

# Private route53 zone creation
resource "aws_route53_zone" "vpc_route53" {
  name = var.route53_zone
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
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    { "Name" = format("%s-igw", var.name) },
    var.tags
  )
}

# Resource block for public subnets route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    { "Name" = format("%s-public-rt", var.name) },
    var.tags
  )
}

# Default route for public route table
resource "aws_route" "default_public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Updating main route table to public route table
resource "aws_main_route_table_association" "default_public_route" {
  route_table_id = aws_route_table.public_route_table.id
  vpc_id         = aws_vpc.vpc.id
}

# Additional Routes to public route table
resource "aws_route" "additional_public_route" {
  for_each               = var.additional_public_routes
  route_table_id         = aws_route_table.public_route_table.id
  gateway_id             = each.value.gateway_id
  destination_cidr_block = each.value.destination_cidr_block
}

# Public Subnets creation
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets) >= length(var.azs) ? length(var.public_subnets) : 0
  availability_zone       = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  cidr_block              = element(concat(var.public_subnets, [""]), count.index)
  map_public_ip_on_launch = true
  tags = merge(
    { "Name" = format("${var.name}-public-%s", element(var.azs, count.index)) },
    var.tags,
    var.public_subnets_tags
  )
}

# Route table association with public subnets
resource "aws_route_table_association" "public_subnets_association" {
  count          = length(var.public_subnets)
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
}

# Private Subnets creation
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnets) >= length(var.azs) ? length(var.private_subnets) : 0
  availability_zone       = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  cidr_block              = element(concat(var.private_subnets, [""]), count.index)
  map_public_ip_on_launch = true
  tags = merge(
    { "Name" = format("${var.name}-private-%s", element(var.azs, count.index)) },
    var.tags,
    var.private_subnets_tags
  )
}

# Private route table creation
resource "aws_route_table" "private_route_table" {
  count  = length(var.azs)
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    { "Name" = format("%s-private-rt-%s", var.name, element(var.azs, count.index)) },
    var.tags
  )
}

# Private route table association
resource "aws_route_table_association" "private_route_table_association" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
  route_table_id = element(aws_route_table.private_route_table[*].id, count.index)
}

# Nat gateway elastic ip
resource "aws_eip" "nat" {
  count  = length(var.azs)
  domain = "vpc"

  tags = merge(
    { "Name" = format("%s-eip-%s", var.name, element(var.azs, count.index)) },
    var.tags
  )

  depends_on = [aws_internet_gateway.igw]
}

# Nat gateway creation and setup
resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.azs)
  subnet_id     = element(aws_subnet.public_subnet[*].id, count.index)
  allocation_id = element(aws_eip.nat[*].id, count.index)

  tags = merge(
    { "Name" = format("%s-nat-%s", var.name, element(var.azs, count.index)) },
    var.tags
  )

  depends_on = [aws_internet_gateway.igw]
}

# Nat gateway association
resource "aws_route" "private_route_nat_association" {
  count                  = length(var.azs)
  route_table_id         = element(aws_route_table.private_route_table[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat_gateway[*].id, count.index)
}

# Database subnet creation
resource "aws_subnet" "database_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.database_subnets) >= length(var.azs) ? length(var.database_subnets) : 0
  availability_zone       = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  cidr_block              = element(concat(var.database_subnets, [""]), count.index)
  map_public_ip_on_launch = true
  tags = merge(
    { "Name" = format("${var.name}-db-%s", element(var.azs, count.index)) },
    var.tags,
    var.database_subnets_tags
  )
}

# Database route table association
resource "aws_route_table_association" "database_route_table_association" {
  count          = length(var.database_subnets)
  subnet_id      = element(aws_subnet.database_subnet[*].id, count.index)
  route_table_id = element(aws_route_table.private_route_table[*].id, count.index)
}

# Additional routes for private route table
locals {
  additional_routes = {
    for route in aws_route_table.private_route_table[*].id : route => var.additional_private_routes
  }
}

# Additional routes to private route table
resource "aws_route" "additional_private_route" {
  count                  = length(var.additional_private_routes) > 0 ? length(aws_route_table.private_route_table[*].id) : 0
  route_table_id         = element(aws_route_table.private_route_table[*].id, count.index)
  gateway_id             = local.additional_routes[element(aws_route_table.private_route_table[*].id, count.index)][0].gateway_id
  destination_cidr_block = local.additional_routes[element(aws_route_table.private_route_table[*].id, count.index)][0].destination_cidr_block
}
