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
  default = true

}

variable "create_nat_gateway" {
  description = "Whether to create NAT Gateways"
  type        = bool
  default = true

}

variable "create_database_subnets" {
  description = "Whether to create database subnets"
  type        = bool
  default = true

}

variable "create_public_subnets" {
  description = "Whether to create public subnets"
  type        = bool
  default = true

}

variable "create_private_subnets" {
  description = "Whether to create private subnets"
  type        = bool
  default = true
}

variable "create_public_route_table" {
  description = "Whether to create public route table"
  type        = bool
  default = true
}

variable "create_private_route_table" {
  description = "Whether to create private route table"
  type        = bool
  default = true
}

variable "create_nacl" {
  description = "Whether to create Network ACLs"
  type        = bool
  default = true

}

variable "create_route53" {
  description = "Whether to create private Route53 zone"
  type        = bool
  default = true
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
  default = [ "us-east-1a" ,"us-east-1b" ]
}

# Subnet CIDR blocks and tags
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

# Flow logs for the VPC
variable "flow_logs_enabled" {
  description = "Whether to enable VPC flow logs or not"
  type        = bool
  default     = true
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
  default = true

}

variable "create_private_nacl" {
  description = "Flag to create private NACL"
  type        = bool
  default = true

}



variable "public_ports" {
  description = "List of ports to allow in the public NACL"
  type        = list(number)
  default     = [80, 443, 5000]
}




variable "private_ports" {
  description = "List of ports to allow in the private NACL"
  type        = list(number)
  default     = [5000, 8080]
}


variable "create_database_nacl" {
  description = "Whether to create a NACL for database subnet"
  type        = bool
  default     = true
}

variable "database_ports" {
  description = "List of DB ports to allow (e.g., 5432, 3306)"
  type        = list(number)
  default     = [5432] # PostgreSQL by default
}

################################### Naming convention variables #########################################

variable "bu" {
  description = "Business unit name (e.g., BP, GURUKU). Max 6 characters."
  type        = string
  default = "BP"
  validation {
    condition     = length(var.bu) <= 6
    error_message = "The business unit name must be less than or equal to 6 characters."
  }
}

variable "program" {
  description = "Name of the program (e.g., OT, BP)."
  type        = string
  default = "OT"
}

variable "app" {
  description = "Application name (e.g., network, shared). Max 6 characters."
  type        = string
  default = "network"
  validation {
    condition     = length(var.app) <= 10
    error_message = "The app name must be less than or equal to 10 characters."
  }
}

variable "env" {
  description = "Environment code: 'd' (dev), 'p' (prod), 'q' (qa), 's' (stage), 'g' (global)."
  type        = string
  default = "d"

  validation {
    condition     = contains(["d", "p", "q", "s", "g"], var.env)
    error_message = "env must be one of 'd', 'p', 'q', 's', 'g'."
  }
}

variable "team" {
  description = "Team email responsible for the application (e.g., digitalops@gehealthcare.com)."
  type        = string
  default = "infra"
}

variable "region" {
  description = "AWS region (e.g., us-east-1, ap-south-1)."
  type        = string
  default = "us-east-1"
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
  default = [ {
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
  default = true
}

variable "service_name_nlb" {
  description = "service name for NLB"
  type        = string
  default     = "com.amazonaws.us-east-1.elasticloadbalancing"

}

variable "nlb_endpoint_type" {
  description = "endpoint type for NLB"
  type        = string
  default = "Interface"
}

variable "nlb_private_dns_enabled" {
  description = ""
  type        = bool
  default = true
}


##############################ALB ####################################


variable "create_sg" {
  description = "Whether to create a new Security Group"
  type        = bool
  default     = true
}

variable "ingress_rule" {
  type = list(object({
    description  = string
    from_port    = number
    to_port      = number
    protocol     = string
    cidr         = optional(list(string), [])
    ipv6_cidr    = optional(list(string), [])
    source_SG_ID = optional(string, "")
  }))
  default = [
    {
      description  = ""
      from_port    = 80
      to_port      = 80
      protocol     = "tcp"
      cidr   =   ["0.0.0.0/0"]
    },
    {
      description  = ""
      from_port    = 443
      to_port      = 443
      protocol     = "tcp"
      cidr  =  ["0.0.0.0/0"]
    }
  ]
  description = "List of ingress rules for security group"
}

variable "egress_rule" {
  type = list(object({
    description  = string
    from_port    = number
    to_port      = number
    protocol     = string
    cidr         = optional(list(string), [])
    ipv6_cidr    = optional(list(string), [])
    source_SG_ID = optional(string, "")
  }))
  default = [
    {
      description  = "Allow all outbound traffic"
      from_port    = 0
      to_port      = 0
      protocol     = "-1"
      cidr         = ["0.0.0.0/0"]
    }
  ]
  description = "List of egress rules for security group"
}

variable "allowed_cidrs" {
  description = "List of allowed CIDRs for ALB"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = true
}

variable "internal" {
  description = "Whether the ALB is internal"
  type        = bool
  default     = false
}

variable "existing_sg_id" {
  description = "ID of existing Security Group"
  type        = string
  default     = ""
}

variable "alb_certificate_arn" {
  type        = string
  description = "ARN of the SSL certificate for the HTTPS listener"
}

variable "enable_logging" {
  type        = bool
  default     = false
  description = "Enable ALB access logs"
}

variable "logs_bucket" {
  type        = string
  description = "S3 bucket for ALB access logs"
}


variable "provisioner" {
  description = "Provisioner for this resource"
  type        = string
  default     = "terraform"
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



#####NLB

variable "create_nlb" {
  description = "Whether to create the NLB"
  type        = bool
  default     = false
}

variable "is_internal" {
  description = "Whether the NLB is internal"
  type        = bool
  default     = false
}

variable "nlb_sg_id" {
  type    = string
  default = ""
}

variable "enable_public_web_security_group_resource" {
  type        = bool
  description = "This variable is to create Web Security Group"
  default     = true
}