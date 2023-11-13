include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_modules/vpc.hcl"
  expose = true
}

dependency "data" {
  config_path = "../_data"
}

dependencies {
  paths = ["../_data"]
}

inputs = {
  cidr            = "10.1.0.0/16"
  private_subnets = ["10.1.0.0/19", "10.1.32.0/19", "10.1.64.0/19"]
  public_subnets  = ["10.1.96.0/19", "10.1.128.0/19", "10.1.160.0/19"]
  azs             = dependency.data.outputs.availability_zones_names
}
