variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name of the VPC to be created"
  type        = string
  default     = "testing-vpc"
}

variable "tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

variable "public_subnets_cidr" {
  description = "CIDR list for public subnet"
  type        = list(string)
}

variable "App_private_subnets_cidr" {
  description = "CIDR list for private subnet"
  type        = list(string)
}

variable "DB_private_subnets_cidr" {
  description = "CIDR list for private subnet"
  type        = list(string)
}

variable "avaialability_zones" {
  description = "List of avaialability zones"
  type        = list(string)
}

variable "public_web_sg_name" {
  type = string
}

variable "logs_bucket" {
  description = "Name of bucket where we would be storing our logs"
}

variable "logs_bucket_arn" {
  description = "ARN of bucket where we would be storing vpc our logs"
}

variable "pvt_zone_name" {
  description = "Name of private zone"
  type        = string
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "instance_tenancy" {
  type    = string
  default = "default"
}

variable "log_destination_type" {
  type    = string
  default = "s3"
}

variable "traffic_type" {
  type    = string
  default = "ALL"
}

variable "enable_vpc_logs" {
  type    = bool
  default = false
}

variable "enable_alb_logging" {
  type    = bool
  default = true
}

variable "alb_certificate_arn" {
  description = "Cretificate arn for alb"
  type        = string
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

variable "enable_igw_publicRouteTable_PublicSubnets_resource" {
  type        = bool
  description = "This variable is used to create IGW, Public Route Table and Public Subnets"
  default     = true
}

variable "enable_nat_privateRouteTable_PrivateSubnets_resource" {
  type        = bool
  description = "This variable is used to create NAT, Private Route Table and Private Subnets"
  default     = true
}

variable "enable_public_web_security_group_resource" {
  type        = bool
  description = "This variable is to create Web Security Group"
  default     = true
}

variable "enable_pub_alb_resource" {
  type        = bool
  description = "This variable is to create ALB"
  default     = true
}

variable "enable_aws_route53_zone_resource" {
  type        = bool
  description = "This variable is to create Route 53 Zone"
  default     = true
}

variable "igw_name" {
  type        = string
  description = "Internet Gateway name"
}

variable "pub_rt_name" {
  type        = string
  description = "Public route table name"
}

variable "pub_subnet_name" {
  type        = string
  description = "public subnet name"
}

variable "nat_name" {
  type        = string
  description = "Name of Nat Gateway"
}

variable "pvt_rt_ame" {
  type        = string
  description = "Name of Pvt Rpoute table"
}

variable "DB_pvt_subnet_name" {
  type        = string
  description = "Name of private subnets"
}

variable "App_pvt_subnet_name" {
  type        = string
  description = "Name of private subnets"
}

variable "alb_name" {
  type        = string
  description = "Name of ALB"
}

variable "alb_type" {
  type        = bool
  description = "Type of ALB"
  default     = false
}
