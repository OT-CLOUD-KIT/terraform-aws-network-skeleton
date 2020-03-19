variable "name" {
  description = "Name tag of the VPC"
  type        = string
  default     = "opstree"
}

variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = ""
}

variable "instance_tenancy" {
  description = "If this attribute is true, the provider ensures all EC2 instances that are launched in a VPC run on hardware that's dedicated to a single customer."
  type        = string
  default     = "dedicated"
}

variable "enable_dns_support" {
  description = "If this attribute is false, the Amazon-provided DNS server that resolves public DNS hostnames to IP addresses is not enabled."
  type        = string
  default     = "true"
}

variable "enable_dns_hostnames" {
  description = "If this attribute is true, instances in the VPC get public DNS hostnames, but only if the enableDnsSupport attribute is also set to true."
  type        = string
  default     = "false"
}

variable "enable_classiclink" {
  description = "If this attribute is true, ClassicLink allows you to link EC2-Classic instances to a VPC in your account, within the same region."
  type        = string
  default     = "false"
}

variable "enable_classiclink_dns_support" {
  description = "If this attribute is true, the DNS hostname of a linked EC2-Classic instance resolves to its private IP address when addressed from an instance in the VPC to which it's linked."
  type        = string
  default     = "false"
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

variable "public_sub_az" {
  description = "AZ for public subnet"
  type        = list(string)
  default     = ["10.0.0.0/19","10.0.32.0/19","10.64.0.0/19"]
}

variable "public_sub_az_id" {
  description = "ID of AZ for public subnet"
  type        = list(string)
  default     = ["ap-south-1a","ap-south-1b","ap-south-1c"]
}

variable "public_subnet_cidr" {
  description = "CIDR of public subnet"
  type        = list(string)
  default     = ["ap-south-1a","ap-south-1b","ap-south-1c"]
}

variable "map_public_ip_on_launch" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address"
  type        = string
  default     = false
}

variable "backend_s3_bucket_name" {
  description = "Name of the s3 bucket to be configured as backend"
  type        = string
  default     = "terraform-state-file-bucket"
}

variable "backend_key" {
  description = "Path for the statefile"
  type        = string
  default     = "network_skeleton/terraform.tfstate"

}

variable "backend_region" {
  description = "Region in which the bucket will be created"
  type        = string
  default     = "ap-south-1"
}

variable "backend_profile" {
  description = "AWS profile to be used"
  type        = string
  default     = "default"
} 

