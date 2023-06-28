variable "region" {
  type        = string
  description = "Region"
  default     = "ap-south-1"
}

variable "acm_certificate_domain" {
  type        = string
  description = "(optional) describe your variable"
  default     = "www.mydevopsprojects.co.in"
}

variable "statuses" {
  type        = list(string)
  description = "(optional) describe your variable"
  default     = ["ISSUED"]
}

variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "173.31.0.0/20"
}

variable "vpc_name" {
  description = "Name of the VPC to be created"
  type        = string
  default     = "testing-vpc"
}

variable "tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default = {
    "owner" = "devops"
    "env"   = "testing"
  }
}

variable "public_subnets_cidr" {
  description = "CIDR list for public subnet"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "CIDR list for private subnet"
  type        = list(string)
}

variable "avaialability_zones" {
  description = "List of avaialability zones"
  type        = list(string)
}

variable "pvt_zone_name" {
  description = "Name of private zone"
  type        = string
}

variable "logs_bucket" {
  description = "Name of bucket where we would be storing our logs"
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

variable "logs_bucket_arn" {
  description = "Name of bucket where we would be storing our logs"
}

variable "enable_alb_logging" {
  type    = bool
  default = true
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

variable "public_web_sg_name" {
  type    = string
  default = "staging-pub-sg"
}
