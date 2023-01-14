locals {
  peering     = var.peering_enabled ? 1 : 0
  rts_ids_new = data.aws_route_tables.vpc_rts.ids
  #rts_ids     = length(data.aws_subnet_ids.subnets.ids) == 0 ? local.rts_ids_new : data.aws_route_table.subnet_rts[*].route_table_id
  rts_ids    = length(var.subnets_id) == 0 ? local.rts_ids_new : data.aws_route_table.subnet_rts[*].route_table_id
  dest_cidrs = toset([data.mongodbatlas_network_container.this.atlas_cidr_block])
  routes = [
    for pair in setproduct(local.rts_ids, local.dest_cidrs) : {
      rts_id    = pair[0]
      dest_cidr = pair[1]
    }
  ]
}