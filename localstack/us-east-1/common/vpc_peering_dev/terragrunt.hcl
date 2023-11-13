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
  origin_vpc_cidr_block = dependency.vpc_this.outputs.vpc_cidr_block
  origin_vpc_id = dependency.vpc_this.outputs.vpc_id
  origin_vpc_name = dependency.vpc_this.outputs.name
  origin_vpc_route_table_ids = concat(dependency.vpc_this.outputs.public_route_table_ids, dependency.vpc_this.outputs.private_route_table_ids, [dependency.vpc_this.outputs.vpc_main_route_table_id])
  num_origin_vpc_route_tables = length(concat(dependency.vpc_this.outputs.public_route_table_ids, dependency.vpc_this.outputs.private_route_table_ids, [dependency.vpc_this.outputs.vpc_main_route_table_id]))

  destination_vpc_cidr_block = dependency.vpc_peer.outputs.vpc_cidr_block
  destination_vpc_id = dependency.vpc_peer.outputs.vpc_id
  destination_vpc_name = dependency.vpc_peer.outputs.name
  destination_vpc_route_table_ids = concat(dependency.vpc_peer.outputs.public_route_table_ids, dependency.vpc_peer.outputs.private_route_table_ids, [dependency.vpc_peer.outputs.vpc_main_route_table_id])
  num_destination_vpc_route_tables = length(concat(dependency.vpc_peer.outputs.public_route_table_ids, dependency.vpc_peer.outputs.private_route_table_ids, [dependency.vpc_peer.outputs.vpc_main_route_table_id]))
}
