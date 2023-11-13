include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_modules/vpc_peering.hcl"
  expose = true
}

dependency "vpc_common" {
  config_path = "../vpc"
}

dependency "vpc_dev" {
  config_path = "../../dev/vpc"
}

dependencies {
  paths = [
    "../vpc",
    "../../dev/vpc"
  ]
}

# locals {
#   account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
#   region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
#   environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
#
#   env = local.environment_vars.locals.environment
#
#   tags_all = merge(
#     local.account_vars.locals.tags,
#     local.region_vars.locals.tags,
#     local.environment_vars.locals.tags
#   )
# }

inputs = {
  this_vpc_id = dependency.vpc_common.outputs.vpc_id
  peer_vpc_id = dependency.vpc_dev.outputs.vpc_id

  providers = {
    aws.this = aws
    aws.peer = aws
  }

  # tags = merge(
  #   local.tags_all,
  #   {
  #     Name = "tf-${local.env}-to-dev-vpc"
  #   },
  # )
}
