####################################
# VPC Configuration
####################################
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "instance_tenancy" {
  type    = string
  default = "default"
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}


####################################
# Subnet Configuration
####################################
variable "subnet_names" {
  type    = list(string)
  default = ["subnet-a", "subnet-b", "subnet-c"]
}

variable "subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "subnet_azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_route_table" {
  type    = string
  default = ""
}

variable "private_route_table" {
  type    = string
  default = ""
}


variable "public_rt_cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}

variable "private_rt_cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}

variable "public_subnet_indexes" {
  type    = list(number)
  default = [0]
}

####################################
# NACL & NAT Gateway
####################################
variable "create_nacl" {
  type    = bool
  default = false
}

variable "nacl_names" {
  type    = list(string)
  default = []
}

variable "nacl_rules" {
  type    = any
  default = {}
}

variable "create_igw_gateway" {
  type    = bool
  default = true
}

variable "create_nat_gateway" {
  type    = bool
  default = false
}

####################################
# Flow Logs
####################################
variable "flow_logs_enabled" {
  type    = bool
  default = false
}

variable "flow_logs_traffic_type" {
  type    = string
  default = "ALL"
}

variable "flow_logs_file_format" {
  type    = string
  default = "plain-text"
}

####################################
# Route53
####################################
variable "create_route53" {
  type    = bool
  default = false
}

variable "route53_zone" {
  type    = string
  default = ""
}

####################################
# VPC Endpoints
####################################
variable "enable_s3_endpoint" {
  type    = bool
  default = false
}

variable "service_name_s3" {
  type    = string
  default = "com.amazonaws.us-east-1.s3"
}

variable "s3_endpoint_type" {
  type    = string
  default = "Gateway"
}

variable "enable_ec2_endpoint" {
  type    = bool
  default = false
}

variable "service_name_ec2" {
  type    = string
  default = "com.amazonaws.us-east-1.ec2"
}

variable "ec2_endpoint_type" {
  type    = string
  default = "Interface"
}

variable "ec2_endpoint_subnet_type" {
  description = "Subnet type to use for EC2 interface endpoint: private or public"
  type        = string
  default     = "public"
  validation {
    condition     = contains(["private", "public"], var.ec2_endpoint_subnet_type)
    error_message = "ec2_endpoint_subnet_type must be 'private' or 'public'."
  }
}

variable "ec2_private_dns_enabled" {
  type    = bool
  default = true
}

variable "enable_nlb_endpoint" {
  type    = bool
  default = false
}

variable "service_name_nlb" {
  type    = string
  default = "com.amazonaws.us-east-1.elb"
}

variable "nlb_endpoint_type" {
  type    = string
  default = "Interface"
}

variable "nlb_private_dns_enabled" {
  type    = bool
  default = false
}

####################################
# ALB & NLB
####################################
variable "create_alb" {
  type    = bool
  default = false
}

variable "internal" {
  type    = bool
  default = false
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

variable "access_logs" {
  type    = any
  default = {}
}

variable "alb_certificate_arn" {
  type    = string
  default = ""
}

variable "create_nlb" {
  type    = bool
  default = false
}

variable "is_internal" {
  type    = bool
  default = false
}


variable "provisioner" {
  type    = string
  default = "terraform"
}

variable "tags" {
  type    = map(string)
  default = {}
}



####################################
# Security Group Rules - ALB
####################################
variable "alb_ingress_rules" {
  type = list(object({
    description  = string
    from_port    = number
    to_port      = number
    protocol     = string
    cidr         = optional(list(string))
    ipv6_cidr    = optional(list(string))
    source_SG_ID = optional(string)
  }))
  default = []
}

variable "alb_egress_rules" {
  type = list(object({
    description  = string
    from_port    = number
    to_port      = number
    protocol     = string
    cidr         = optional(list(string))
    ipv6_cidr    = optional(list(string))
    source_SG_ID = optional(string)
  }))
  default = []
}

####################################
# Security Group Rules - NLB
####################################
variable "nlb_ingress_rules" {
  type = list(object({
    description  = string
    from_port    = number
    to_port      = number
    protocol     = string
    cidr         = optional(list(string))
    ipv6_cidr    = optional(list(string))
    source_SG_ID = optional(string)
  }))
  default = []
}

variable "nlb_egress_rules" {
  type = list(object({
    description  = string
    from_port    = number
    to_port      = number
    protocol     = string
    cidr         = optional(list(string))
    ipv6_cidr    = optional(list(string))
    source_SG_ID = optional(string)
  }))
  default = []
}

####################################
# Security Group Rules - Endpoint
####################################
variable "endpoint_ingress_rules" {
  type = list(object({
    description  = string
    from_port    = number
    to_port      = number
    protocol     = string
    cidr         = optional(list(string))
    ipv6_cidr    = optional(list(string))
    source_SG_ID = optional(string)
  }))
  default = []
}

variable "endpoint_egress_rules" {
  type = list(object({
    description  = string
    from_port    = number
    to_port      = number
    protocol     = string
    cidr         = optional(list(string))
    ipv6_cidr    = optional(list(string))
    source_SG_ID = optional(string)
  }))
  default = []
}


################## key pair ################3333

variable "create_key_pair" {
  description = "Whether to create a key pair"
  type        = bool
  default     = false
}

variable "create_private_key" {
  description = "Whether to generate a private key using TLS"
  type        = bool
  default     = false
}

variable "key_pair_name" {
  description = "Name of the key pair"
  type        = string
  default     = "default-key"
}

variable "private_key_algorithm" {
  description = "Algorithm to use for TLS private key"
  type        = string
  default     = "RSA"
}

variable "private_key_rsa_bits" {
  description = "Number of bits for RSA key"
  type        = number
  default     = 4096
}

variable "public_key_path" {
  description = "Path to the public key file if not generating a key"
  type        = string
  default     = ""
}


variable "key_output_dir" {
  type    = string
  default = "./keys"
}

variable "env" {
  type    = string
  default = "prod"


}

variable "program" {
  type    = string
  default = "trransbank"

}

variable "owner" {
  type    = string
  default = "nikita"

}

variable "region" {
  type = string
  default = "us-east-1"
  
}

variable "enable_alb_sg" {
  description = "Enable or disable the ALB security group"
  type        = bool
  default     = true
}


variable "enable_nlb_sg" {
  description = "Enable or disable the ALB security group"
  type        = bool
  default     = true
}


variable "enable_endpoint_sg" {
  description = "Enable or disable the ALB security group"
  type        = bool
  default     = true
}

variable "nat_gateway_count" {
  description = <<EOT
Number of NAT Gateways to create:
- Set to 1 for a single NAT Gateway (cost-saving)
- Set to length of public_subnet_ids for HA (one per AZ)
EOT
  type        = number
  default     = 1
}


variable "alb_listeners" {
  description = "List of listeners to create on the ALB"
  type = list(object({
    port            = number
    protocol        = string
    certificate_arn = string
    target_group_arn = optional(string)
    default_action_type = string          # "forward", "fixed-response", "redirect"
    fixed_response = optional(object({
      content_type = string
      message_body = string
      status_code  = string
    }))
    redirect = optional(object({
      port        = string
      protocol    = string
      status_code = string
    }))
  }))
  default = []
}