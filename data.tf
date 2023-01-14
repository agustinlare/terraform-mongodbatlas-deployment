# Get vpc info
data "aws_vpc" "vpc" {
  id = var.vpc_id
}

#Vpc subnets ids
data "aws_subnet_ids" "subnets" {
  vpc_id = var.vpc_id
}

# Get all route tables from vpcs
data "aws_route_tables" "vpc_rts" {
  vpc_id = var.vpc_id
}

# get subnets info
# data "aws_subnet" "this" {
#   count    = length(local.subnet_ids)
#   id       = local.subnet_ids[count.index]
# }

# Get info for only those route tables associated with the given subnets
data "aws_route_table" "subnet_rts" {
  count     = length(var.subnets_id)
  subnet_id = var.subnets_id[count.index]
  # count     = length(local.subnet_ids)
  # subnet_id = local.subnet_ids[count.index]
}

#get atlas_cidr_block
data "mongodbatlas_network_container" "this" {
  project_id   = var.project_id
  container_id = var.container_id
}