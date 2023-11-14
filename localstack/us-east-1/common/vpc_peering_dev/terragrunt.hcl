include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_modules/vpc_peering.hcl"
  expose = true
}

dependency "vpc_this" {
  config_path = "../vpc"
}

dependency "vpc_peer" {
  config_path = "../../dev/vpc"
}

dependencies {
  paths = [
    "../vpc",
    "../../dev/vpc"
  ]
}

inputs = {
  requestor_vpc_id = dependency.vpc_this.outputs.vpc_id
  acceptor_vpc_id  = dependency.vpc_peer.outputs.vpc_id
}
