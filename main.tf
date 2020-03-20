##################### VPC ##################################
resource "aws_vpc" "main" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = var.instance_tenancy
  enable_dns_support               = var.enable_dns_support
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_classiclink               = var.enable_classiclink
  enable_classiclink_dns_support   = var.enable_classiclink_dns_support

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.vpc_tags,
  )
}

#################### Internet Gateway ######################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      "Name" = format("%s-igw", var.name)
    },
    var.tags,
  )
}

################### Route Table #########################################
resource "aws_route" "route_table" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

################## Subnet #############################################
resource "aws_subnet" "public" {
  count              = length(var.public_subnet_cidr)
  availability_zone               = element(var.public_sub_az, count.index)
  cidr_block                      = element(var.public_subnet_cidr, count.index)
  map_public_ip_on_launch         = var.map_public_ip_on_launch
  vpc_id                          = aws_vpc.main.id

  tags = {
    Type = "Public"
    Name = format("%s-subnet-%d", var.name,count.index+1)
  }
}

#################### Route Table Association ##################
resource "aws_route_table_association" "public_rt_asso" {
  count              = length(var.public_subnet_cidr)
  subnet_id          = element(aws_subnet.public.*.id, count.index)
  route_table_id     = aws_route.route_table.id
}

################### NAT Gateways #####################

###### Elastic IP ##############
resource "aws_eip" "Eip" {
  vpc                  = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id        = aws_eip.Eip.id
  subnet_id            = element(aws_subnet.public.*.id,0)
  tags = {
    Name               = format("%s-nat", var.name)
  }
}

################# Network ACL ######################
resource "aws_network_acl" "network_acl" {
  vpc_id = aws_vpc.main.id

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.cidr_block
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.cidr_block
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = format("%s-nacl", var.name)
  }
}
