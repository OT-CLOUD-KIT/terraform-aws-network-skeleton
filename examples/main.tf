module "network_skeleton" {
  source = "../"

  name = "opstree"
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "dedicated"
  enable_dns_support = true
  enable_dns_hostnames = false
  enable_classiclink = false
  assign_generated_ipv6_cidr_block = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
  vpc_tags = {
    key1 = "value1"
    key2 = "value2"
  }  
}