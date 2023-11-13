terraform {
  source = "${local.base_source_url}?version=6.0.0"
}

locals {
  base_source_url = "tfr:///grem11n/vpc-peering/aws"

    
  #account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  #region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  #environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  #env = local.environment_vars.locals.environment

  #tags_all = merge(
  #  local.account_vars.locals.tags,
  #  local.region_vars.locals.tags,
  #  local.environment_vars.locals.tags
  #)
}

inputs = {
  # providers = {
  #   aws.this = aws
  #   aws.peer = aws
  # }
  auto_accept_peering = true
}
