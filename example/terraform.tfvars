
region     = "us-east-1"
cidr_block = "10.0.0.0/16"

instance_tenancy = "default"

enable_network_address_usage_metrics = false


route53_zone = "non-prod.internal"



azs              = ["us-east-1a", "us-east-1b"]
public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets  = ["10.0.12.0/24", "10.0.13.0/24"]
database_subnets = ["10.0.14.0/24"]

# Flags for resource creation
create_igw                 = true
create_nat_gateway         = true
create_database_subnets    = false
create_public_subnets      = true
create_private_subnets     = true
create_public_route_table  = true
create_private_route_table = true
create_nacl                = true
create_route53             = true
create_public_nacl         = true
create_private_nacl        = true
create_database_nacl = true




# Additional routes (optional)
additional_private_routes = []
additional_public_routes  = {}

# Flow logs
flow_logs_enabled = false



################ NACL #################

public_ingress_rules = [
  {port =1024, to_port= 65535, cidr= "0.0.0.0/0",rule =90 },
  { port = 80,  to_port = 80,  cidr = "0.0.0.0/0", rule = 100 },
  { port = 443, to_port = 443, cidr = "0.0.0.0/0", rule = 110 },
  { port = 22,  to_port = 22,  cidr = "0.0.0.0/0", rule = 120 }
]

public_egress_rules = [
    {port =1024, to_port= 65535, cidr= "0.0.0.0/0",rule =90 },

  { port = 80,  to_port = 80,  cidr = "0.0.0.0/0", rule = 101 },
  { port = 443, to_port = 443, cidr = "0.0.0.0/0", rule = 111 },
  { port = 22,  to_port = 22,  cidr = "0.0.0.0/0", rule = 121 }
]

private_ingress_rules = [
    {port =1024, to_port= 65535, cidr= "0.0.0.0/0",rule =90 },
  { port = 5000, to_port = 5000, cidr = "10.0.0.0/16", rule = 200 },
  { port = 8080, to_port = 8080, cidr = "10.0.0.0/16", rule = 210 },
  { port = 5432, to_port = 5432, cidr = "10.0.0.0/16", rule = 220 },
  { port = 3306, to_port = 3306, cidr = "10.0.0.0/16", rule = 230 },
  { port = 22,   to_port = 22,   cidr = "10.0.0.0/16", rule = 240 }
]

private_egress_rules = [
    {port =1024, to_port= 65535, cidr= "0.0.0.0/0",rule =90 },

  { port = 5000, to_port = 5000, cidr = "10.0.0.0/16", rule = 201 },
  { port = 8080, to_port = 8080, cidr = "10.0.0.0/16", rule = 211 },
  { port = 5432, to_port = 5432, cidr = "10.0.0.0/16", rule = 221 },
  { port = 3306, to_port = 3306, cidr = "10.0.0.0/16", rule = 231 },
  { port = 22,   to_port = 22,   cidr = "10.0.0.0/16", rule = 241 }
]

db_ingress_rules = [
  { port = 5432, to_port = 5432, cidr = "10.0.1.0/24", rule = 300 },
  { port = 3306, to_port = 3306, cidr = "10.0.1.0/24", rule = 310 },
  { port = 22,   to_port = 22,   cidr = "10.0.1.0/24", rule = 320 }
]

db_egress_rules = [
  { port = 5432, to_port = 5432, cidr = "10.0.1.0/24", rule = 301 },
  { port = 3306, to_port = 3306, cidr = "10.0.1.0/24", rule = 311 },
  { port = 22,   to_port = 22,   cidr = "10.0.1.0/24", rule = 321 }
]


#################### VPC endpoint #####################


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
service_name_nlb        = "com.amazonaws.us-east-2.elasticloadbalancing"
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


################## Naming Convension #####################

random_alphanumeric_len = 4

bu       = "ot"
app      = "bp"
env      = "d"
resource = "network"
tenant   = ""

special = false
upper   = false
number  = true

gen_no_of_names = 1

team    = "infra"
program = "ot"


########################ALB #####################3333


create_sg      = true
create_alb     = true
existing_sg_id = "" # Leave empty if `create_sg = true`

alb_internal = false # true for internal ALB, false for internet-facing

alb_certificate_arn = ""

enable_deletion_protection = false

access_logs = {
  enabled = false
  bucket  = ""
  prefix  = ""
}

security_group_ingress_rules = {
  "http" = {
    description  = "Allow HTTP"
    from_port    = 80
    to_port      = 80
    protocol     = "tcp"
    cidr         = ["0.0.0.0/0"]
    ipv6_cidr    = []
    source_SG_ID = ""
  },
  "https" = {
    description  = "Allow HTTPS"
    from_port    = 443
    to_port      = 443
    protocol     = "tcp"
    cidr         = ["0.0.0.0/0"]
    ipv6_cidr    = []
    source_SG_ID = ""
  }
}

security_group_egress_rules = {
  "all-egress" = {
    description  = "Allow all egress"
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr         = ["0.0.0.0/0"]
    ipv6_cidr    = []
    source_SG_ID = ""
  }
}

provisioner = "terraform"


create_nlb   = false
is_internal  = false
nlb_sg_name = "dev_nlg_sg"
enable_public_web_security_group_resource = true