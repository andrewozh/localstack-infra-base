locals {
  account_name   = "localstack"
  aws_account_id = "000000000000"
  aws_profile    = "localstack"

  tags = {
    Account      = local.account_name
    Terragrunt   = "true"
  }
}
