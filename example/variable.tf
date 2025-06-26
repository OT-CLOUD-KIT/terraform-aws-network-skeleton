variable "region" {
  default = "us-east-1"
}

variable "cidr_block" {
  description = "The IPv4 CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}

variable "enable_network_address_usage_metrics" {
  description = "Determines whether network address usage metrics are enabled for the VPC"
  type        = bool
  default     = false
}

variable "route53_zone" {
  description = "Name of the private route53 hosted zone"
  type        = string
  default     = "non-prod.internal"
}


variable "create_igw" {
  description = "Whether to create an Internet Gateway"
  type        = bool
  default     = true

}

variable "create_nat_gateway" {
  description = "Whether to create NAT Gateways"
  type        = bool
  default     = true
}

variable "create_database_subnets" {
  description = "Whether to create database subnets"
  type        = bool
  default     = true
}

variable "create_public_subnets" {
  description = "Whether to create public subnets"
  type        = bool
  default     = true
}

variable "create_private_subnets" {
  description = "Whether to create private subnets"
  type        = bool
  default     = true
}

variable "create_public_route_table" {
  type    = bool
  default = true
}

variable "create_private_route_table" {
  type    = bool
  default = true
}

variable "create_nacl" {
  type    = bool
  default = true
}

variable "create_route53" {
  description = "Whether to create private Route53 zone"
  type        = bool
  default     = true
}

variable "additional_public_routes" {
  description = "List of public subnets routes with map"
  type = map(object({
    destination_cidr_block = string
    gateway_id             = string
  }))
  default = {}
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  validation {
    condition     = length(var.azs) > 0
    error_message = "You must provide at least one AZ."
  }
  default = ["us-east-1a", "us-east-1b"]

}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.12.0/24", "10.0.13.0/24"]
}

variable "database_subnets" {
  description = "A list of database subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.14.0/24"]
}

variable "additional_private_routes" {
  description = "List of private subnets routes with map"
  type = list(object({
    destination_cidr_block = string
    gateway_id             = string
  }))
  default = []
}

variable "flow_logs_enabled" {
  description = "Whether to enable VPC flow logs or not"
  type        = bool
  default     = true
}

variable "flow_logs_traffic_type" {
  description = "The type of traffic to capture. Valid values: ACCEPT,REJECT, ALL"
  type        = string
  default     = "ALL"
}

variable "flow_logs_file_format" {
  description = "The format for the flow log. Valid values: plain-text, parquet"
  type        = string
  default     = "parquet"
}

################### NACL variables ###################
variable "create_public_nacl" {
  description = "Flag to create public NACL"
  type        = bool
  default     = true
}

variable "create_private_nacl" {
  description = "Flag to create private NACL"
  type        = bool
  default     = true
}

variable "public_nacl_rules" {
  description = "List of NACL rules for public subnets"
  type = list(object({
    rule_number = number
    egress      = bool
    protocol    = string
    rule_action = string
    cidr_block  = string
    from_port   = number
    to_port     = number
  }))
  default = [{
    rule_number = 100
    egress      = true
    protocol    = "tcp"
    rule_action = "allow"
    cidr_block  = "0.0.0.0/0"
    from_port   = 80
    to_port     = 80
    },
    {
      rule_number = 200
      egress      = true
      protocol    = "-1"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
      from_port   = 0
      to_port     = 0
  }]
}

variable "private_nacl_rules" {
  description = "List of NACL rules for private subnets"
  type = list(object({
    rule_number = number
    egress      = bool
    protocol    = string
    rule_action = string
    cidr_block  = string
    from_port   = number
    to_port     = number
  }))
  default = [{
    rule_number = 100
    egress      = true
    protocol    = "tcp"
    rule_action = "allow"
    cidr_block  = "10.0.0.0/8"
    from_port   = 443
    to_port     = 443
    },
    {
      rule_number = 200
      egress      = true
      protocol    = "-1"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
      from_port   = 0
      to_port     = 0
  }]
}

######################## vpc endpoint variable ###################

variable "enable_s3_endpoint" {
  type    = bool
  default = true
}

variable "enable_ec2_endpoint" {
  type    = bool
  default = true
}

variable "enable_nlb_endpoint" {
  type    = bool
  default = true
}

variable "enable_endpoint_sg" {
  description = "Whether to create the endpoint security group"
  type        = bool
  default     = true
}

variable "endpoint_sg_rules" {
  description = "List of security group rules for VPC endpoints"
  type = list(object({
    description = string
    type        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [{
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
  }]
}

variable "service_name_s3" {
  description = "service name of s3"
  type        = string
  default     = "com.amazonaws.us-east-1.s3"

}

variable "s3_endpoint_type" {
  description = "endpoint type for s3"
  type        = string
  default     = "Gateway"
}

variable "service_name_ec2" {
  description = "service name for ec2"
  type        = string
  default     = "com.amazonaws.us-east-1.ec2"

}

variable "ec2_endpoint_type" {
  description = "endpoint type for ec2"
  type        = string
  default     = "Interface"
}

variable "ec2_private_dns_enabled" {
  description = "Whether to enable private DNS for EC2 endpoint"
  type        = bool
  default     = true
}

variable "service_name_nlb" {
  description = "service name for NLB"
  type        = string
  default     = "com.amazonaws.us-east-1.elasticloadbalancing"

}

variable "nlb_endpoint_type" {
  description = "endpoint type for NLB"
  type        = string
  default     = "Interface"
}

variable "nlb_private_dns_enabled" {
  description = "Whether to enable private DNS for NLB endpoint"
  type        = bool
  default     = true
}

################### Naming convention variables ###################

variable "env" {
  description = "Environment short name. Must be one of: d (dev), p (prod), q (qa), s (stage), g (global)."
  type        = string
  default     = "d"
  validation {
    condition     = contains(["d", "p", "q", "s", "g"], var.env)
    error_message = "env must be one of 'd', 'p', 'q', 's', 'g'."
  }
}

variable "bu" {
  description = "Business unit name (e.g., pcs, ultrasound). Max 5 characters."
  type        = string
  default     = "OT"
  validation {
    condition     = length(var.bu) <= 5
    error_message = "The business unit name must be less than or equal to 5 characters."
  }
}

variable "app" {
  description = "Application name (e.g., network, shared). Max 6 characters."
  type        = string
  default     = "BP"
  validation {
    condition     = length(var.app) <= 6
    error_message = "The app name must be less than or equal to 6 characters."
  }
}

variable "resource" {
  description = "Resource name (e.g., eks, efs, ecr). Max 8 characters."
  type        = string
  default     = "Network"
  validation {
    condition     = length(var.resource) <= 8
    error_message = "The resource name must be less than or equal to 8 characters."
  }
}

variable "tenant" {
  description = "Tenant name (e.g., app1, app2). Max 6 characters."
  type        = string
  default     = ""
  validation {
    condition     = length(var.tenant) <= 6
    error_message = "The tenant name must be less than or equal to 6 characters."
  }
}

variable "enabled_features" {
  type    = list(string)
  default = []
}

variable "create" {
  description = "Controls if resources should be created (affects nearly all resources)"
  type        = bool
  default     = true
}

variable "random_alphanumeric_len" {
  description = "The length of random alphanumeric string desired. Min: 1, Max: 4."
  type        = number
  validation {
    condition     = var.random_alphanumeric_len >= 1 && var.random_alphanumeric_len <= 4
    error_message = "The length must be between 1 and 4."
  }
}

variable "special" {
  description = "Include special characters like !@#$%&*()-_=+[]{}<>:? in the generated name."
  type        = bool
  default     = true
}

variable "upper" {
  description = "Include uppercase characters in the generated name."
  type        = bool
  default     = true
}

variable "number" {
  description = "Include numbers in the generated name."
  type        = bool
  default     = true
}

variable "gen_no_of_names" {
  description = "Number of names to generate."
  type        = number
  default     = 1
}

variable "team" {
  description = "The email address of the team who owns the application, ex:digitalops@gehealthcare.com"
  type        = string
  default     = "infra"
}

variable "program" {
  description = "Name of the Program, For ex: OT, BP etc."
  type        = string
  default     = "ot"
}

########################ALB#################

variable "create_sg" {
  type    = bool
  default = true
}

variable "existing_sg_id" {
  type    = string
  default = ""
}

variable "alb_internal" {
  type    = bool
  default = false
}

variable "alb_certificate_arn" {
  type    = string
  default = ""
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

# variable "access_logs" {
#   type = object({
#     enabled = bool
#     bucket  = string
#     prefix  = string
#   })
#   default = {
#     enabled = false
#     bucket  = ""
#     prefix  = ""
#   }
# }

variable "security_group_ingress_rules" {
  description = "Ingress rules for ALB SG"
  type = map(object({
    description  = string
    from_port    = number
    to_port      = number
    protocol     = string
    cidr         = list(string)
    ipv6_cidr    = list(string)
    source_SG_ID = string
  }))
  default = {}
}

variable "security_group_egress_rules" {
  description = "Egress rules for ALB SG"
  type = map(object({
    description  = string
    from_port    = number
    to_port      = number
    protocol     = string
    cidr         = list(string)
    ipv6_cidr    = list(string)
    source_SG_ID = string
  }))
  default = {}
}

variable "provisioner" {
  type    = string
  default = "terraform"
}

variable "create_alb" {
  description = "Whether to create a new Security Group"
  type        = bool
  default     = true
}


variable "access_logs" {
  description = "Configuration for ALB access logs"
  type = object({
    enabled = bool
    bucket  = string
    prefix  = string
  })
}


