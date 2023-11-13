terraform {
  source = "${local.base_source_url}?ref=v0.26.8"
}

locals {
  base_source_url = "git::git@github.com:gruntwork-io/terraform-aws-vpc.git//modules/vpc-peering"
    
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  tags_all = merge(
   local.account_vars.locals.tags,
   local.region_vars.locals.tags,
   local.environment_vars.locals.tags
  )
}

inputs = {
  aws_account_id = local.account_vars.locals.aws_account_id
  allow_remote_vpc_dns_resolution = true
  auto_accept = true
  create_resources = true
  custom_tags = local.tags_all
}
