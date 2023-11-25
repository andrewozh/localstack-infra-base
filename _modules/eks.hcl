terraform {
  source = "${local.base_source_url}?version=19.20.0"
}

locals {
  base_source_url = "tfr:///terraform-aws-modules/eks/aws"

  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  account = local.account_vars.locals.account_name
  region  = local.region_vars.locals.aws_region
  env     = local.environment_vars.locals.environment

  cluster_name    = "eks-${local.env}"
  cluster_version = "1.26"

  tags_all = merge(
   local.account_vars.locals.tags,
   local.region_vars.locals.tags,
   local.environment_vars.locals.tags
  )
}

inputs = {
  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version

  cluster_endpoint_public_access  = false
  cluster_endpoint_private_access = true
  enable_irsa                     = true

  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]

    attach_cluster_primary_security_group = true
    
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
      labels = {
        Environment = local.env
      }

      taints = {
        dedicated = {
          key    = "dedicated"
          value  = "gpuGroup"
          effect = "NO_SCHEDULE"
        }
      }

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 10
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            delete_on_termination = true
          }
        }
      }

      update_config = {
        max_unavailable_percentage = 33 # or set `max_unavailable`
      }

      tags = {
        ExtraTag = "example"
      }
    }
  }

  tags = local.tags_all
}
