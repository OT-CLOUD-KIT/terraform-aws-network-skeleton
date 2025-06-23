cidr_block                           = "10.1.0.0/16"
instance_tenancy                     = "default"
enable_network_address_usage_metrics = false
name                                 = "test-vpc"
route53_zone                         = "non-prod.internal"
tags = {
  Environment = "non-prod"
  Project     = "du-project"
}
vpc_tags = {
  Name = "nonprod-vpc"
}
azs              = ["us-east-1a", "us-east-1b"]
public_subnets   = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnets  = ["10.1.12.0/24", "10.1.13.0/24", "10.1.14.0/24"]
database_subnets = []
# Flags for resource creation
create_igw                 = true
create_nat_gateway         = false
create_database_subnets    = false
create_public_subnets      = true
create_private_subnets     = true
create_public_route_table  = true
create_private_route_table = true
create_nacl                = false
create_route53             = false
create_public_nacl         = false
create_private_nacl        = false
# Tags
public_subnets_tags = {
  Tier = "public"
}
private_subnets_tags = {
  Tier = "application"
}
# Additional routes (optional)
additional_private_routes = []
additional_public_routes  = {}
# Flow logs
flow_logs_enabled = false
################ NACL #################
public_nacl_rules = [
  {
    rule_number = 100
    egress      = false
    protocol    = "tcp"
    rule_action = "allow"
    cidr_block  = "0.0.0.0/0"
    from_port   = 80
    to_port     = 80
  },
  {
    rule_number = 200
    egress      = false
    protocol    = "-1"
    rule_action = "allow"
    cidr_block  = "0.0.0.0/0"
    from_port   = 0
    to_port     = 0
  }
]
private_nacl_rules = [
  {
    rule_number = 100
    egress      = false
    protocol    = "tcp"
    rule_action = "allow"
    cidr_block  = "10.0.0.0/8"
    from_port   = 443
    to_port     = 443
  },
  {
    rule_number = 200
    egress      = false
    protocol    = "-1"
    rule_action = "allow"
    cidr_block  = "0.0.0.0/0"
    from_port   = 0
    to_port     = 0
  }
]

###########################

enable_s3_endpoint  = true
enable_ec2_endpoint = false
enable_nlb_endpoint = false
enable_endpoint_sg  = false

# S3 Endpoint Configuration
service_name_s3  = "com.amazonaws.us-east-1.s3"
s3_endpoint_type = "Gateway"

# EC2 Endpoint Configuration
service_name_ec2        = "com.amazonaws.us-east-1.ec2"
ec2_endpoint_type       = "Interface"
ec2_private_dns_enabled = true

# NLB Endpoint Configuration
service_name_nlb        = "com.amazonaws.us-east-1.elasticloadbalancing"
nlb_endpoint_type       = "Interface"
nlb_private_dns_enabled = true

endpoint_sg_rules = [
  # Ingress rules
  {
    description = "HTTPS from VPC"
    type        = "ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  },
  {
    description = "DNS from VPC"
    type        = "ingress"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/16"]
  }
]