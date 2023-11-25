#!/bin/bash -x

function terragrunt_noupd {
  local cmd="$@"
  /usr/bin/expect <<EOF
  set timeout -1
  spawn terragrunt ${cmd}
  expect {
    -re "Remote state S3 bucket .* Would you like Terragrunt to (create|update) it.*" {
      send "n\r"
      send_user "Sent 'n' to Terragrunt\n"
      exp_continue
    }
    eof
  }
EOF
}

function terragrunt_apply {
  local path="$1"
  cd ${path}
  terragrunt_noupd init
  terragrunt_noupd apply -auto-approve
  cd -
}

function terragrunt_reapply {
  local path="$1"
  cd ${path}
  rm -rf .terraform.lock.hcl .terragrunt-cache
  terragrunt_noupd init
  terragrunt_noupd apply -auto-approve
  cd -
}

terragrunt_reapply localstack/us-east-1/common/_data
terragrunt_reapply localstack/us-east-1/common/vpc
terragrunt_reapply localstack/us-east-1/dev/_data
terragrunt_reapply localstack/us-east-1/dev/vpc
terragrunt_reapply localstack/us-east-1/common/vpc_peering_dev
terragrunt_reapply localstack/us-east-1/common/kms_eks
terragrunt_reapply localstack/us-east-1/dev/kms_eks
terragrunt_reapply localstack/us-east-1/common/eks
