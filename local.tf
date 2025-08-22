

locals {
  base_name= "${var.env}-${var.program}"
}

locals {
  common_tags = {
    env = var.env
    owner = var.owner
  }
}


#################### subnet ##########################333{

locals {
  subnets = [
    for i in range(length(var.subnet_names)) : {
      name       = "${var.env}-${var.program}-${var.subnet_names[i]}"
      cidr       = var.subnet_cidrs[i]
      avail_zone = var.subnet_azs[i]
    }
  ]

  public_subnet_indexes = [
    for idx, name in var.subnet_names :
    idx if can(regex("(?i)public", name))
  ]

  private_subnet_indexes = [
    for idx, name in var.subnet_names :
    idx if !can(regex("(?i)public", name))
  ]

  public_subnet_ids = [
    for i in local.public_subnet_indexes :
    aws_subnet.subnets[i].id
  ]

  private_subnet_ids = [
    for i in local.private_subnet_indexes :
    aws_subnet.subnets[i].id
  ]

  application_subnet_ids = [
    for i, subnet in aws_subnet.subnets :
    subnet.id if can(regex("(?i)application", var.subnet_names[i]))
  ]

  database_subnet_ids = [
    for i, subnet in aws_subnet.subnets :
    subnet.id if can(regex("(?i)database", var.subnet_names[i]))
  ]
}



locals {
  selected_subnet_ids = (
    var.ec2_endpoint_type == "Interface" ?
    (
      var.ec2_endpoint_subnet_type == "private" ?
      local.private_subnet_ids :
      local.public_subnet_ids
    ) : null
  )
}


#################### NACL ########################

locals {
  nacls = {
    for i in range(length(var.nacl_names)) :
    var.nacl_names[i] => "${var.env}-${var.nacl_names[i]}-nacl"
  }

  nacl_config = {
    for nacl_key, nacl_value in var.nacl_rules :
    nacl_key => {
      name       = local.nacls[nacl_key]
      subnet_ids = [for index in nacl_value.subnet_index : aws_subnet.subnets[index].id]
      ingress    = nacl_value.ingress_rules
      egress     = nacl_value.egress_rules
    }
  }
}