# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  environment = "dev"

  vpc_cidr            = "10.1.0.0/16"
  vpc_private_subnets = ["10.1.0.0/19", "10.1.32.0/19", "10.1.64.0/19"]
  vpc_public_subnets  = ["10.1.96.0/19", "10.1.128.0/19", "10.1.160.0/19"]

  tags = {
    Environment  = local.environment
  }
}
