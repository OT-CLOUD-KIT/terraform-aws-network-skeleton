variable "region" {
  default = "us-east-2"
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
}

variable "create_nat_gateway" {
  description = "Whether to create NAT Gateways"
  type        = bool
}

variable "create_database_subnets" {
  description = "Whether to create database subnets"
  type        = bool
}

variable "create_public_subnets" {
  description = "Whether to create public subnets"
  type        = bool
}

variable "create_private_subnets" {
  description = "Whether to create private subnets"
  type        = bool
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
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "database_subnets" {
  description = "A list of database subnets inside the VPC"
  type        = list(string)
  default     = []
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
  default     = false
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
}

variable "create_private_nacl" {
  description = "Flag to create private NACL"
  type        = bool
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
  default = []
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
  default = []
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
  default = []
}

variable "service_name_s3" {
  description = ""
  type        = string
  default     = ""

}

variable "s3_endpoint_type" {
  description = ""
  type        = string
  default     = ""
}
variable "service_name_ec2" {
  description = ""
  type        = string
  default     = ""

}

variable "ec2_endpoint_type" {
  description = ""
  type        = string
  default     = ""
}

variable "ec2_private_dns_enabled" {
  description = ""
  type        = bool
  default     = true
}

variable "service_name_nlb" {
  description = ""
  type        = string
  default     = ""

}

variable "nlb_endpoint_type" {
  description = ""
  type        = string
  default     = ""
}

variable "nlb_private_dns_enabled" {
  description = ""
  type        = bool
}

################### Naming convention variables ###################

variable "env" {
  description = "Environment short name. Must be one of: d (dev), p (prod), q (qa), s (stage), g (global)."
  type        = string
  validation {
    condition     = contains(["d", "p", "q", "s", "g"], var.env)
    error_message = "env must be one of 'd', 'p', 'q', 's', 'g'."
  }
}

variable "bu" {
  description = "Business unit name (e.g., pcs, ultrasound). Max 5 characters."
  type        = string
  validation {
    condition     = length(var.bu) <= 5
    error_message = "The business unit name must be less than or equal to 5 characters."
  }
}

variable "app" {
  description = "Application name (e.g., network, shared). Max 6 characters."
  type        = string
  validation {
    condition     = length(var.app) <= 6
    error_message = "The app name must be less than or equal to 6 characters."
  }
}

variable "resource" {
  description = "Resource name (e.g., eks, efs, ecr). Max 8 characters."
  type        = string
  default     = ""
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
}

variable "upper" {
  description = "Include uppercase characters in the generated name."
  type        = bool
}

variable "number" {
  description = "Include numbers in the generated name."
  type        = bool
}

variable "gen_no_of_names" {
  description = "Number of names to generate."
  type        = number
}

variable "team" {
  description = "The email address of the team who owns the application, ex:digitalops@gehealthcare.com"
  type        = string
}

variable "program" {
  description = "Name of the Program, For ex: OT, BP etc."
  type        = string
}

