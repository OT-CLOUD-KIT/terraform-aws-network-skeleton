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

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "route53_zone" {
  description = "Name of the private route53 hosted zone"
  type        = string
  default     = "non-prod.internal"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

variable "additional_public_routes" {
  description = "List of public subnets routes with map"
  type = map(object({
    destination_cidr_block = string
    gateway_id             = string
  }))
  default = {}
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "public_subnets_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}

variable "database_subnets" {
  description = "A list of database subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "database_subnets_tags" {
  description = "Additional tags for the database subnets"
  type        = map(string)
  default     = {}
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
