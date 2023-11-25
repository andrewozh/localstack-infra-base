terraform {
  source = "${local.base_source_url}?version=2.1.0"
}

locals {
  base_source_url = "tfr:///terraform-aws-modules/kms/aws"

  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  account = local.account_vars.locals.account_name
  region  = local.region_vars.locals.aws_region
  env     = local.environment_vars.locals.environment

  cluster_name = "eks-${local.env}"

  tags_all = merge(
   local.account_vars.locals.tags,
   local.region_vars.locals.tags,
   local.environment_vars.locals.tags
  )
}

inputs = {
  enable_default_policy = true

  aliases               = ["eks/${local.cluster_name}"]
  description           = "${local.cluster_name} cluster encryption key"

  tags = local.tags_all
}
