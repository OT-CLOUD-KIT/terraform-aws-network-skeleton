provider "aws" {
  region                  = "ap-south-1"
}

terraform {
  backend "s3" {
    
    bucket = "terraform-state-ezmall-file-bucket" 
    key     = "network_skeleton/terraform.tfstate" 
    profile     = "default"
    region = "ap-south-1"
  }
}

module "network_skeleton" {
  source = "../"

  name = "opstree"
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "dedicated"
  enable_dns_support = true
  enable_dns_hostnames = false
  enable_classiclink = false

  public_sub_az = ["ap-south-1a","ap-south-1b","ap-south-1c"]
  public_subnet_cidr = ["10.0.0.0/19","10.0.32.0/19","10.64.0.0/19"]
  map_public_ip_on_launch = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
  vpc_tags = {
    key1 = "value1"
    key2 = "value2"
  }  
}
