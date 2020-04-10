/*-------------------------------------------------------*/
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
/*-------------------------------------------------------*/
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      "Name" = format("%s-igw", var.name)
    },
    var.tags,
  )
}
/*-------------------------------------------------------*/
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      "Name" = format("%s-rt", var.name)
    },
    var.tags,
  )
}
/*-------------------------------------------------------*/
resource "aws_route" "route" {
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
/*-------------------------------------------------------*/
resource "aws_main_route_table_association" "main_route_table" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.route_table.id
}
/*-------------------------------------------------------*/
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidr)
  availability_zone       = element(var.public_sub_az, count.index % length(var.public_sub_az))
  cidr_block              = element(var.public_subnet_cidr, count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch
  vpc_id                  = aws_vpc.main.id

  tags = merge(
    {
    Type = "Public"
    Name = format("%s-subnet-%d", var.name,count.index+1)
  },
    var.tags,
  )
}

/*-------------------------------------------------------*/
resource "aws_route_table_association" "public_rt_asso" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.route_table.id
}

/*-------------------------------------------------------*/
resource "aws_eip" "Eip" {
  vpc = true
}
/*-------------------------------------------------------*/
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.Eip.id
  subnet_id     = element(aws_subnet.public.*.id,0)
  tags = merge(
    {
    Name = format("%s-nat", var.name)
  },
    var.tags,
  )
}
/*-------------------------------------------------------*/
resource "aws_network_acl" "network_acl" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
    Name = format("%s-nacl", var.name)
  },
    var.tags,
  )
}
/*-------------------------------------------------------*/
resource "aws_network_acl_rule" "network_acl_egress_rule" {
  count          = length(var.nacl_egress_to_port)
  network_acl_id = aws_network_acl.network_acl.id
  rule_number    = var.nacl_egress_rule_no+count.index
  egress         = true
  protocol       = var.nacl_egress_protocol
  rule_action    = var.nacl_egress_action
  cidr_block     = var.cidr_block
  from_port      = element(var.nacl_egress_from_port,count.index)
  to_port        = element(var.nacl_egress_to_port,count.index)
}
/*-------------------------------------------------------*/
resource "aws_network_acl_rule" "network_acl_ingress_rule" {
  count          = length(var.nacl_ingress_to_port)
  network_acl_id = aws_network_acl.network_acl.id
  rule_number    = var.nacl_ingress_rule_no+count.index
  egress         = false
  protocol       = var.nacl_ingress_protocol
  rule_action    = var.nacl_ingress_action
  cidr_block     = var.cidr_block
  from_port      = element(var.nacl_ingress_from_port,count.index)
  to_port        = element(var.nacl_ingress_to_port,count.index)
}
/*-------------------------------------------------------*/
resource "aws_lb" "alb"{
  name                 = format("%s-lb", var.name)
  internal             = false
  load_balancer_type   = "application"
  security_groups      = aws_security_group.web_sg.*.id
  subnets              = aws_subnet.public.*.id
  tags = merge(
    {
    Name = format("%s-alb", var.name)
  },
    var.tags,
  )
}
/*-------------------------------------------------------*/
resource "aws_lb_listener" "https_front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type            = "fixed-response"
    fixed_response {
      content_type  = "text/plain"
      message_body  = "Fixed response content"
      status_code   = "200"
    }
  }
}
/*-------------------------------------------------------*/
resource "aws_lb_listener" "http_front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type          = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
/*-------------------------------------------------------*/
resource "aws_security_group" "web_sg" {
  name         = format("%s-web_sg", var.name)
  description  = "Web security group"
  vpc_id                           = aws_vpc.main.id
  tags = merge(
    {
    Name = format("%s-web_sg", var.name)
  },
    var.tags,
  )
}
/*-------------------------------------------------------*/
resource "aws_security_group_rule" "sg_egress" {
  count             = length(var.sg_egress_to_port)
  type              = "egress"
  from_port         = element(var.sg_egress_from_port,count.index)
  to_port           = element(var.sg_egress_to_port,count.index)
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}
/*-------------------------------------------------------*/
resource "aws_security_group_rule" "sg_ingress" {
  count             = length(var.sg_ingress_to_port)
  type              = "ingress"
  from_port         = element(var.sg_ingress_from_port,count.index)
  to_port           = element(var.sg_ingress_to_port,count.index)
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}
/*-------------------------------------------------------*/
resource "aws_security_group" "ssh_sg" {
  name        = format("%s-ssh_sg", var.name)
  description = "SSH security group"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.whitelist_ssh_ip
  }
  tags = merge(
    {
    Name = format("%s-ssh_sg", var.name)
  },
    var.tags,
  )
}
/*-------------------------------------------------------*/
resource "aws_route53_zone" "public" {
  count = var.require_hosted_zone ? 1:0
  name  = var.name_hz

  tags = merge(
    {
    Name = format("%s-ssh_sg", var.name)
  },
    var.tags,
  )
}
/*-------------------------------------------------------*/
resource "aws_route53_record" "public_record" {
  count   = var.require_hosted_zone ? 1:0
  zone_id = aws_route53_zone.public[0].zone_id
  name    = var.name_hz
  type    = var.record_type
  
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}
