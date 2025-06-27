locals {
  # Standard tag components
  base_name = "${var.env}-${var.bu}-${var.app}"

  common_tags = {
    "BusinessUnit" = var.bu
    "Program"      = var.program
    "Application"  = var.app
    "Environment"  = var.env
    "Team"         = var.team
    "Region"       = var.region
    "ManagedBy"    = "Terraform"
  }

public_port_rule_numbers = {
    for idx, port in var.public_ports :
    port => {
      rule  = 100 * (idx + 1)
      cidrs = ["0.0.0.0/0"]  # Public access
    }
  }

  private_ingress_rules = var.create_private_nacl ? {
    for pair in flatten([
      for port_index, port in var.private_ports : [
        for cidr_index, cidr in var.public_subnets : {
          key        = "${port}-${cidr}-ingress"
          rule       = (port_index + 1) * 100 + cidr_index * 10
          port       = port
          cidr_block = cidr
        }
      ]
    ]) : pair.key => {
      rule       = pair.rule
      port       = pair.port
      cidr_block = pair.cidr_block
    }
  } : {}

  private_egress_rules = var.create_private_nacl ? {
    for pair in flatten([
      for port_index, port in var.private_ports : [
        for cidr_index, cidr in var.database_subnets : {
          key        = "${port}-${cidr}-egress"
          rule       = (port_index + 1) * 100 + cidr_index * 10 + 1
          port       = port
          cidr_block = cidr
        }
      ]
    ]) : pair.key => {
      rule       = pair.rule
      port       = pair.port
      cidr_block = pair.cidr_block
    }
  } : {}

  db_egress_rules = var.create_database_nacl ? {
    for pair in flatten([
      for port_index, port in var.database_ports : [
        for cidr_index, cidr in var.database_subnets : {
          key        = "${port}-${cidr}-egress"
          rule       = (port_index + 1) * 100 + cidr_index * 10 + 1
          port       = port
          cidr_block = cidr
        }
      ]
    ]) : pair.key => {
      rule       = pair.rule
      port       = pair.port
      cidr_block = pair.cidr_block
    }
  } : {}

  # Optional: db_ingress_rules (if needed)
  db_ingress_rules = var.create_database_nacl ? {
    for pair in flatten([
      for port_index, port in var.database_ports : [
        for cidr_index, cidr in var.private_subnets : {
          key        = "${port}-${cidr}-ingress"
          rule       = (port_index + 1) * 100 + cidr_index * 10
          port       = port
          cidr_block = cidr
        }
      ]
    ]) : pair.key => {
      rule       = pair.rule
      port       = pair.port
      cidr_block = pair.cidr_block
    }
  } : {}

}

locals {
  sg_ingress_rules = flatten([for rules in var.ingress_rule :
    merge({
      rules_map = rules,
      key       = join(" ", ["cidr_block"], rules.cidr, ["from_port"], [rules.from_port], ["to_port"], [rules.to_port], ["ipv6_cidr"], rules.ipv6_cidr, ["source_sg_id"], [rules.source_SG_ID], ["protocol"], [rules.protocol])
    })
  ])


  security_group_ingress_rules = { for rules in local.sg_ingress_rules :
    rules.key => rules.rules_map
  }

  sg_egress_rules = flatten([for rules in var.egress_rule :
    merge({
      rules_map = rules,
      key       = join(" ", ["cidr_block"], rules.cidr, ["from_port"], [rules.from_port], ["to_port"], [rules.to_port], ["ipv6_cidr"], rules.ipv6_cidr, ["source_sg_id"], [rules.source_SG_ID], ["protocol"], [rules.protocol])
    })
  ])

  security_group_egress_rules = { for rules in local.sg_egress_rules :
    rules.key => rules.rules_map
  }
}


###############################NACL#######################3

