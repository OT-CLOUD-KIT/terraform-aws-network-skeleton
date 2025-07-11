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



public_ingress_map  = { for rule in var.public_ingress_rules  : "${rule.port}-${rule.cidr}" => rule }
  public_egress_map   = { for rule in var.public_egress_rules   : "${rule.port}-${rule.cidr}" => rule }
  private_ingress_map = { for rule in var.private_ingress_rules : "${rule.port}-${rule.cidr}" => rule }
  private_egress_map  = { for rule in var.private_egress_rules  : "${rule.port}-${rule.cidr}" => rule }
  db_ingress_map      = { for rule in var.db_ingress_rules      : "${rule.port}-${rule.cidr}" => rule }
  db_egress_map       = { for rule in var.db_egress_rules       : "${rule.port}-${rule.cidr}" => rule }

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



