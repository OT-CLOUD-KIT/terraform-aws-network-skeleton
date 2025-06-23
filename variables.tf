# VPC-related variables
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


# Flags for resource creation
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
  description = "Whether to create public route table"
  type        = bool
}

variable "create_private_route_table" {
  description = "Whether to create private route table"
  type        = bool
}

variable "create_nacl" {
  description = "Whether to create Network ACLs"
  type        = bool

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

# Availability Zones (AZs) for resource distribution
variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  validation {
    condition     = length(var.azs) > 0
    error_message = "You must provide at least one AZ."
  }
}

# Subnet CIDR blocks and tags
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

# Flow logs for the VPC
variable "flow_logs_enabled" {
  description = "Whether to enable VPC flow logs or not"
  type        = bool
  default     = false
}

variable "flow_logs_traffic_type" {
  description = "The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL"
  type        = string
  default     = "ALL"
}

variable "flow_logs_file_format" {
  description = "The format for the flow log. Valid values: plain-text, parquet"
  type        = string
  default     = "parquet"
}

############### NACL-related variables #############
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
    rule_number    = number
    egress         = bool
    protocol       = string
    rule_action    = string
    cidr_block     = string
    from_port      = number
    to_port        = number
  }))
  default = []
}

variable "private_nacl_rules" {
  description = "List of NACL rules for private subnets"
  type = list(object({
    rule_number    = number
    egress         = bool
    protocol       = string
    rule_action    = string
    cidr_block     = string
    from_port      = number
    to_port        = number
  }))
  default = []
}


################################### Naming convention variables #########################################

variable "bu" {
  description = "Business unit name (e.g., BP, GURUKU). Max 6 characters."
  type        = string

  validation {
    condition     = length(var.bu) <= 6
    error_message = "The business unit name must be less than or equal to 6 characters."
  }
}

variable "program" {
  description = "Name of the program (e.g., OT, BP)."
  type        = string
}

variable "app" {
  description = "Application name (e.g., network, shared). Max 6 characters."
  type        = string

  validation {
    condition     = length(var.app) <= 6
    error_message = "The app name must be less than or equal to 6 characters."
  }
}

variable "env" {
  description = "Environment code: 'd' (dev), 'p' (prod), 'q' (qa), 's' (stage), 'g' (global)."
  type        = string

  validation {
    condition     = contains(["d", "p", "q", "s", "g"], var.env)
    error_message = "env must be one of 'd', 'p', 'q', 's', 'g'."
  }
}

variable "team" {
  description = "Team email responsible for the application (e.g., digitalops@gehealthcare.com)."
  type        = string
}

variable "region" {
  description = "AWS region (e.g., us-east-1, ap-south-1)."
  type        = string
}

###########################################################
# vpc endpoint
###########################################################

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
    type        = string # "ingress" or "egress"
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
}

variable "service_name_nlb" {
  description = ""
  type        = string
  default     = ""

}

variable "nlb_endpoint_type" {
  description = ""
  type        = string
}

variable "nlb_private_dns_enabled" {
  description = ""
  type        = bool
}
