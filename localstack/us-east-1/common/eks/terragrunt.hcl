include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_modules/eks.hcl"
  expose = true
}

dependency "vpc" {
  config_path = "../vpc"
}

dependencies {
  paths = [
    "../vpc",
  ]
}

inputs = {
  vpc_id                   = dependency.vpc.outputs.vpc_id
  subnet_ids               = dependency.vpc.outputs.private_subnets
  control_plane_subnet_ids = dependency.vpc.outputs.intra_subnets
}
