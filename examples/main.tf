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
  public_subnet_cidr = ["10.0.0.0/19","10.0.32.0/19","10.0.64.0/19"]
  map_public_ip_on_launch = true
  
  nacl_egress_rule_no = 200
  nacl_egress_protocol = "tcp"
  nacl_egress_action = "allow"
  nacl_egress_from_port = [80,443]
  nacl_egress_to_port = [80,443]
  
  nacl_ingress_rule_no = 100
  nacl_ingress_protocol = "tcp"
  nacl_ingress_action = "allow"
  nacl_ingress_from_port = [80,443]
  nacl_ingress_to_port = [80,443]
  
  sg_egress_from_port = [443,80]
  sg_egress_to_port = [443,80]

  sg_ingress_from_port = [443,80]
  sg_ingress_to_port = [443,80]
  
  whitelist_ssh_ip = ["171.76.32.5/32","191.23.54.23/32"]

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
  vpc_tags = {
    key1 = "value1"
    key2 = "value2"
  }  
}
