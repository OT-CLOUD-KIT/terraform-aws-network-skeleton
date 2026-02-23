

variable "env" {
  type = string
  default = "dev"
  
}

variable "program" {
  type = string
  default = "otcloud"
  
}

variable "owner" {
  type = string
  default = "opstree"
  
}
###################### VPC Configuration ####################

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "enable_dns_support" {
  type        = bool
  description = "Enable DNS support in VPC"
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true
}

variable "instance_tenancy" {
  type        = string
  description = "Tenancy option: default or dedicated"
  default     = "default"
}



###################### Subnet Configuration ####################

variable "subnet_names" {
  type        = list(string)
  description = "List of subnet names"
  default = ["public-1", "private-1", "public-2", "private-2"]
}

variable "subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for subnets"
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]

}

variable "subnet_azs" {
  type        = list(string)
  description = "List of Availability Zones for subnets"
  default = ["us-east-1a", "us-east-1a", "us-east-1b", "us-east-1b"]
}

variable "public_subnet_indexes" {
  type        = list(number)
  description = "Indexes of public subnets in subnet list"
  default = [ 0,2 ]
}


######################## Route Tables ########################

variable "public_rt_cidr_block" {
  type        = string
  description = "CIDR for public route table"
  default = "0.0.0.0/0"
}

variable "private_rt_cidr_block" {
  type        = string
  description = "CIDR for private route table (typically 0.0.0.0/0)"
  default = "0.0.0.0/0"
}

variable "route_table_subnet_map" {
  description = "Mapping of route tables to subnet indexes"
  type        = map(list(number))
}

variable "route_table_igw_cidr" {
  description = "CIDR for IGW route"
  type        = string
  default     = "0.0.0.0/0"
}

variable "route_table_names" {
  description = "List of route table names"
  type        = list(string)
  default     = []
}

########################## NAT ######################################
variable "create_nat_gateway" {
  type        = bool
  description = "Enable NAT gateway creation"
  default     = true
}

#######################virtual gateway#################

variable "create_vgw" {
  type    = bool
  default = false
}

variable "vgw_name" {
  type    = string
  default = null
}

########################## NACL ###########################

variable "create_nacl" {
  type        = bool
  description = "Enable creation of custom network ACLs"
  default     = true
}

variable "nacl_names" {
  type        = list(string)
  description = "List of NACL names"
  default     = ["public", "private", "application", "database"]

}

variable "nacl_rules" {
  type        = any
  description = "Map of NACL rules (ingress/egress)"
  default     = {}
}

variable "nacl_subnet_map" {
  description = "Mapping of NACLs to subnet indexes"
  type        = map(list(number))
}
########################## Route53 ###########################

variable "create_route53" {
  type        = bool
  description = "Enable Route53 private zone"
  default     = true
}

variable "route53_zone" {
  type        = string
  description = "Route53 private hosted zone domain name"
  default     = "example.internal"
}

###################### VPC Flow Logs #########################

variable "flow_logs_enabled" {
  type        = bool
  description = "Enable VPC Flow Logs"
  default     = false
}

variable "flow_logs_traffic_type" {
  type        = string
  description = "Type of traffic to capture: ACCEPT, REJECT, ALL"
  default     = "ALL"
}

variable "flow_logs_file_format" {
  type        = string
  description = "File format for VPC Flow Logs: plain-text or parquet"
  default     = "plain-text"
}

###################### VPC Endpoints ##########################

variable "enable_s3_endpoint" {
  type        = bool
  default     = false
}

variable "service_name_s3" {
  type        = string
  default     = ""
}

variable "ec2_endpoint_type" {
  type        = string
  default     = "Interface"
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
  type        = bool
  default     = true
}

variable "enable_nlb_endpoint" {
  type        = bool
  default     = false
}

variable "service_name_nlb" {
  type        = string
  default     = ""
}

variable "nlb_endpoint_type" {
  type        = string
  default     = "Interface"
}

variable "nlb_private_dns_enabled" {
  type        = bool
  default     = false
}

variable "endpoint_sg_id" {
  type        = string
  default     = ""
}

########################## ALB & NLB ##########################

variable "create_alb" {
  type        = bool
  default     = true
}

variable "internal" {
  type        = bool
  default     = false
}

variable "alb_sg_id" {
  type        = string
  default     = ""
}

variable "enable_deletion_protection" {
  type        = bool
  default     = false
}

variable "alb_certificate_arn" {
  type        = string
  default     = ""
}

variable "access_logs" {
  type = object({
    enabled = bool
    bucket  = string
    prefix  = string
  })
  default = {
    enabled = false
    bucket  = ""
    prefix  = ""
  }
}

variable "create_nlb" {
  type        = bool
  default     = true
}

variable "is_internal" {
  type        = bool
  default     = false
}

variable "nlb_sg_id" {
  type        = string
  default     = ""
}


######################## key pair  ##################3333

variable "create_key_pair" {
  description = "Whether to create the EC2 key pair"
  type        = bool
  default     = true
}

variable "create_private_key" {
  description = "Whether to generate a private key (if false, public key must be provided)"
  type        = bool
  default     = true
}

variable "key_pair_name" {
  description = "Name of the EC2 key pair"
  type        = string
  default     = "ot-key"
}

variable "public_key_path" {
  description = "Path to an existing public key file (used if create_private_key = false)"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_algorithm" {
  description = "Algorithm for private key generation"
  type        = string
  default     = "RSA"
}

variable "private_key_rsa_bits" {
  description = "Bit size of RSA key"
  type        = number
  default     = 4096
}

variable "Customer_Code" {
  type = string
}

variable "CC" {
  type = string
}

variable "Project" {
  type = string
}

variable "CC-Project" {
  type = string
}

variable "key_output_dir" {
  description = "Directory to write the generated private key"
  type        = string
  default     = "./keys"
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

