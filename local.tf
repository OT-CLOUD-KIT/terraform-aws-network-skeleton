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
}