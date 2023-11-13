# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  account_name = local.account_vars.locals.account_name
  account_id   = local.account_vars.locals.aws_account_id
  aws_region   = local.region_vars.locals.aws_region
}

# Generate an AWS provider block
generate "provider" {
  path      = "terragrunt_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region  = "${local.aws_region}"
  profile = "localstack" # aws-cli

  # Only these AWS Account IDs may be operated on by this template
  #allowed_account_ids = ["${local.account_id}"]

  access_key                  = "test"
  secret_key                  = "test"

  s3_use_path_style           = false
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  #skip_requesting_account_id  = true

  endpoints {
    acm                      = "http://localhost:4566"
    amplify                  = "http://localhost:4566"
    apigateway               = "http://localhost:4566"
    apigatewayv2             = "http://localhost:4566"
    appconfig                = "http://localhost:4566"
    applicationautoscaling   = "http://localhost:4566"
    appsync                  = "http://localhost:4566"
    athena                   = "http://localhost:4566"
    autoscaling              = "http://localhost:4566"
    backup                   = "http://localhost:4566"
    batch                    = "http://localhost:4566"
    cloudformation           = "http://localhost:4566"
    cloudfront               = "http://localhost:4566"
    cloudsearch              = "http://localhost:4566"
    cloudtrail               = "http://localhost:4566"
    cloudwatch               = "http://localhost:4566"
    cloudwatchlogs           = "http://localhost:4566"
    codecommit               = "http://localhost:4566"
    cognitoidentity          = "http://localhost:4566"
    cognitoidp               = "http://localhost:4566"
    config                   = "http://localhost:4566"
    configservice            = "http://localhost:4566"
    costexplorer             = "http://localhost:4566"
    docdb                    = "http://localhost:4566"
    dynamodb                 = "http://localhost:4566"
    ec2                      = "http://localhost:4566"
    ecr                      = "http://localhost:4566"
    ecs                      = "http://localhost:4566"
    efs                      = "http://localhost:4566"
    eks                      = "http://localhost:4566"
    elasticache              = "http://localhost:4566"
    elasticbeanstalk         = "http://localhost:4566"
    elasticsearch            = "http://localhost:4566"
    elb                      = "http://localhost:4566"
    elbv2                    = "http://localhost:4566"
    emr                      = "http://localhost:4566"
    es                       = "http://localhost:4566"
    events                   = "http://localhost:4566"
    firehose                 = "http://localhost:4566"
    glacier                  = "http://localhost:4566"
    glue                     = "http://localhost:4566"
    iam                      = "http://localhost:4566"
    iot                      = "http://localhost:4566"
    iotanalytics             = "http://localhost:4566"
    iotevents                = "http://localhost:4566"
    kafka                    = "http://localhost:4566"
    kinesis                  = "http://localhost:4566"
    kinesisanalytics         = "http://localhost:4566"
    kinesisanalyticsv2       = "http://localhost:4566"
    kms                      = "http://localhost:4566"
    lakeformation            = "http://localhost:4566"
    lambda                   = "http://localhost:4566"
    mediaconvert             = "http://localhost:4566"
    mediastore               = "http://localhost:4566"
    neptune                  = "http://localhost:4566"
    organizations            = "http://localhost:4566"
    qldb                     = "http://localhost:4566"
    rds                      = "http://localhost:4566"
    redshift                 = "http://localhost:4566"
    redshiftdata             = "http://localhost:4566"
    resourcegroups           = "http://localhost:4566"
    resourcegroupstaggingapi = "http://localhost:4566"
    route53                  = "http://localhost:4566"
    route53resolver          = "http://localhost:4566"
    s3                       = "http://s3.localhost.localstack.cloud:4566"
    s3control                = "http://localhost:4566"
    sagemaker                = "http://localhost:4566"
    secretsmanager           = "http://localhost:4566"
    serverlessrepo           = "http://localhost:4566"
    servicediscovery         = "http://localhost:4566"
    ses                      = "http://localhost:4566"
    sesv2                    = "http://localhost:4566"
    sns                      = "http://localhost:4566"
    sqs                      = "http://localhost:4566"
    ssm                      = "http://localhost:4566"
    stepfunctions            = "http://localhost:4566"
    sts                      = "http://localhost:4566"
    swf                      = "http://localhost:4566"
    timestreamwrite          = "http://localhost:4566"
    transfer                 = "http://localhost:4566"
    waf                      = "http://localhost:4566"
    wafv2                    = "http://localhost:4566"
    xray                     = "http://localhost:4566"
  }
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "${get_env("TG_BUCKET_PREFIX", "")}terragrunt-${local.account_name}-${local.aws_region}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "terraform-locks"
    profile        = "localstack" # aws-cli
    endpoint       = "http://localhost.localstack.cloud:4566"

    access_key        = "test"
    secret_key        = "test"

    iam_endpoint      = "http://localhost:4566"
    sts_endpoint      = "http://localhost:4566"
    dynamodb_endpoint = "http://localhost:4566"

    skip_credentials_validation = true
    skip_metadata_api_check     = true

    force_path_style = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
)
