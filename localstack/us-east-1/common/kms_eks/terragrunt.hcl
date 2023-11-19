include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_modules/kms_eks.hcl"
  expose = true
}

dependency "data" {
  config_path = "../_data"
}

dependencies {
  paths = ["../_data"]
}

inputs = {
  key_owners = [dependency.data.outputs.caller_identity_arn]
}
