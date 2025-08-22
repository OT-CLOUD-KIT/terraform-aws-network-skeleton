##############################
# VPC
##############################
vpc_cidr             = "10.0.0.0/16"
instance_tenancy     = "default"
enable_dns_support   = true
enable_dns_hostnames = true
cluster_name         = "eks-cluster"

##############################
# Subnets
##############################
subnet_names = ["public-1", "private-1", "public-2", "private-2", "private3"]
subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24","10.0.5.0/24"]
subnet_azs   = ["us-east-1a", "us-east-1a", "us-east-1b", "us-east-1a", "us-east-1a"]

public_route_table    = "public-rt"
private_route_table   = "private-rt"
public_rt_cidr_block  = "0.0.0.0/0"
private_rt_cidr_block = "0.0.0.0/0"

# Use indexes for both public subnets
public_subnet_indexes = [0, 2] # index 0 = public-1, index 2 = public-2

##############################
# NACL Configuration
##############################
create_nacl = true

nacl_names = ["public", "application", "database"]

nacl_rules = {
  public = {
    subnet_index = [0,2]
    ingress_rules = [
      { protocol = "tcp", rule_no = 100, action = "allow", cidr_block = "0.0.0.0/0", from_port = 22, to_port = 22 },      # SSH
      { protocol = "tcp", rule_no = 110, action = "allow", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 }, # Ephemeral
      { protocol = "-1", rule_no = 120, action = "allow", cidr_block = "0.0.0.0/0", from_port = 0, to_port = 0 }          # All traffic (optional fallback)
    ]
    egress_rules = [
      { protocol = "tcp", rule_no = 100, action = "allow", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 }, # Ephemeral
      { protocol = "-1", rule_no = 110, action = "allow", cidr_block = "0.0.0.0/0", from_port = 0, to_port = 0 }          # All
    ]
  }

 

  application = {
    subnet_index = [1]
    ingress_rules = [
      { protocol = "tcp", rule_no = 100, action = "allow", cidr_block = "10.0.0.0/16", from_port = 22, to_port = 22 },
      { protocol = "tcp", rule_no = 110, action = "allow", cidr_block = "10.0.0.0/16", from_port = 1024, to_port = 65535 }
    ]
    egress_rules = [
      { protocol = "tcp", rule_no = 100, action = "allow", cidr_block = "10.0.0.0/16", from_port = 1024, to_port = 65535 }
    ]
  }

  database = {
    subnet_index = [4]
    ingress_rules = [
      { protocol = "tcp", rule_no = 100, action = "allow", cidr_block = "10.0.0.0/16", from_port = 22, to_port = 22 },
      { protocol = "tcp", rule_no = 110, action = "allow", cidr_block = "10.0.0.0/16", from_port = 1024, to_port = 65535 }
    ]
    egress_rules = [
      { protocol = "tcp", rule_no = 100, action = "allow", cidr_block = "10.0.0.0/16", from_port = 1024, to_port = 65535 }
    ]
  }
}


##############################
# NAT Gateway
##############################
create_nat_gateway = true

##############################
# Flow Logs
##############################
flow_logs_enabled      = false
flow_logs_traffic_type = "ALL"
flow_logs_file_format  = "parquet"

##############################
# Route 53
##############################
create_route53 = false
route53_zone   = "example.internal"

##############################
# VPC Endpoints
##############################
enable_s3_endpoint = false
service_name_s3    = "com.amazonaws.us-east-1.s3"
s3_endpoint_type   = "Gateway"

enable_ec2_endpoint     = false
service_name_ec2        = "com.amazonaws.us-east-1.ec2"
ec2_endpoint_type       = "Interface"
ec2_endpoint_subnet_type = "public"
ec2_private_dns_enabled = true

enable_nlb_endpoint = false
# NLB Endpoint Configuration
service_name_nlb        = "com.amazonaws.us-east-1.elasticloadbalancing"
nlb_endpoint_type       = "Interface"
nlb_private_dns_enabled = true


##############################
# Application Load Balancer
##############################
create_alb                 = false
internal                   = false
enable_deletion_protection = false
alb_certificate_arn        = ""
access_logs = {
  enabled = false
  bucket  = ""
  prefix  = ""
}

##############################
# Network Load Balancer
##############################
create_nlb  = false
is_internal = false

##############################
# Tags & Metadata
##############################
provisioner = "terraform"
tags = {
  Environment = "dev"
  Owner       = "Nikita"
}

##############################
# ALB Security Group Rules
##############################
alb_ingress_rules = [
  {
    description = "Allow HTTP from all"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr        = ["0.0.0.0/0"]
  },
  {
    description = "Allow HTTPS from all"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr        = ["0.0.0.0/0"]
  }
]

alb_egress_rules = [
  {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr        = ["0.0.0.0/0"]
  }
]

##############################
# NLB Security Group Rules
##############################
nlb_ingress_rules = [
  {
    description  = "Allow TCP 8080 from ALB SG"
    from_port    = 80
    to_port      = 80
    protocol     = "tcp"
    cidr         = ["0.0.0.0/0"]
    source_SG_ID = ""
  }
]

nlb_egress_rules = [
  {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr        = ["0.0.0.0/0"]
  }
]

##############################
# Endpoint Security Group Rules
##############################
endpoint_ingress_rules = [
  {
    description  = "Allow HTTPS from ALB SG"
    from_port    = 443
    to_port      = 443
    protocol     = "tcp"
    cidr         = ["0.0.0.0/0"]
    source_SG_ID = ""
  }
]

endpoint_egress_rules = [
  {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr        = ["0.0.0.0/0"]
  }
]



##############################
# Key Pair Configuration
##############################
create_key_pair       = false
create_private_key    = false
key_pair_name         = "otbp-key"
private_key_algorithm = "RSA"
private_key_rsa_bits  = 4096
public_key_path       = ""                                           # Leave blank if you're generating the key
key_output_dir        = "/home/nikita/Downloads/terraform_code/keys" # Directory where PEM file will be saved

env     = "prod"
owner   = "nikita"
program = "otcloudkit"
region = "us-east-1"

enable_alb_sg  = true
enable_endpoint_sg = true
enable_nlb_sg = true