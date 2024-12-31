name       = "testing"
cidr_block = "10.10.0.0/16"
tags = {
  environment = "dev"
}
vpc_tags = {
  vpc = "shared"
}
public_subnets = ["10.10.0.0/20", "10.10.16.0/20"]
azs            = ["us-west-2a", "us-west-2b"]
public_subnets_tags = {
  subnet_type = "public"
}
private_subnets = ["10.10.32.0/20", "10.10.48.0/20"]
private_subnets_tags = {
  subnet_type = "private"
}
database_subnets = ["10.10.64.0/20", "10.10.80.0/20"]
database_subnets_tags = {
  subnet_type = "database"
}
additional_private_routes = [
  {
    destination_cidr_block = "20.0.0.0/16"
    gateway_id             = "nat-00a12c2c206403cfa"
  }
]
