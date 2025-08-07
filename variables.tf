####################### Project Info ########################

variable "bu" {
  description = "Business unit name (e.g., BP, GURUKU). Max 6 characters."
  type        = string
  default     = "BP"

  validation {
    condition     = length(var.bu) <= 10
    error_message = "The business unit name must be less than or equal to 10 characters."
  }
}

variable "program" {
  description = "Name of the program (e.g., OT, BP)."
  type        = string
  default     = "OT"
}

variable "app" {
  description = "Application name (e.g., network, shared). Max 10 characters."
  type        = string
  default     = "database"

  validation {
    condition     = length(var.app) <= 10
    error_message = "The app name must be less than or equal to 10 characters."
  }
}

variable "env" {
  description = "Environment code: 'd' (dev), 'p' (prod), 'q' (qa), 's' (stage), 'g' (global)."
  type        = string
  default     = "p"

  validation {
    condition     = contains(["d", "p", "q", "s", "g"], var.env)
    error_message = "env must be one of 'd', 'p', 'q', 's', 'g'."
  }
}

variable "team" {
  description = "Team email responsible for the application (e.g., digitalops@gehealthcare.com)."
  type        = string
  default     = "infra"
}

variable "region" {
  description = "AWS region (e.g., us-east-1, ap-south-1)."
  type        = string
  default     = "us-east-1"
}

variable "mission" {
  description = "Mission name or identifier for the project (max 20 characters)."
  type        = string
  default     = "infra-core"

  validation {
    condition     = length(var.mission) <= 20
    error_message = "The mission name must be less than or equal to 20 characters."
  }
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

variable "cluster_name" {
  type        = string
  default     = "eks-cluster"
  description = "Name of the Kubernetes/EKS cluster"
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

variable "create_nat_gateway" {
  type        = bool
  description = "Enable NAT gateway creation"
  default     = true
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

variable "s3_endpoint_type" {
  type        = string
  default     = "Gateway"
}

variable "enable_ec2_endpoint" {
  type        = bool
  default     = false
}

variable "service_name_ec2" {
  type        = string
  default     = ""
}

variable "ec2_endpoint_type" {
  type        = string
  default     = "Interface"
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

variable "key_output_dir" {
  description = "Directory to write the generated private key"
  type        = string
  default     = "./keys"
}
