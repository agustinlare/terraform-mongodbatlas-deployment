resource "mongodbatlas_project" "project" {
  org_id = var.organization_id
  name   = "${var.name}-project"
}

resource "mongodbatlas_cluster" "cluster" {
  name         = "${var.cluster_name}-cluster"
  project_id   = mongodbatlas_project.project.id
  cluster_type = "REPLICASET"

  replication_specs {
    num_shards = var.num_shards

    dynamic "regions_config" {
      for_each = var.regions_config
      iterator = rule

      content {
        region_name     = rule.value.region_name
        electable_nodes = rule.value.electable_nodes
        priority        = rule.value.priority
        read_only_nodes = rule.value.read_only_nodes
      }
    }
  }

  labels {
    key   = "env"
    value = var.env
  }

  auto_scaling_disk_gb_enabled = var.disk_auto_scaling
  mongo_db_major_version       = var.mongodb_version
  cloud_backup                 = var.cloud_backup

  disk_size_gb                = var.disk_size_gb
  provider_name               = "AWS"
  provider_instance_size_name = var.provider_instance_size_name

  depends_on = [
    mongodbatlas_project.project
  ]
}

resource "mongodbatlas_network_peering" "test" {
  count                  = local.enabled ? 1 : 0
  accepter_region_name   = replace(lower(var.regions_config[0]["region_name"]), "_", "-")
  project_id             = mongodbatlas_project.project.id
  container_id           = mongodbatlas_cluster.cluster.container_id
  provider_name          = "AWS"
  route_table_cidr_block = var.route_table_cidr_block
  vpc_id                 = var.vpc_id
  aws_account_id         = var.aws_account_id

  depends_on = [
    mongodbatlas_project.project,
    mongodbatlas_cluster.cluster
  ]
}

resource "mongodbatlas_project_ip_access_list" "cidr" {
  project_id = mongodbatlas_project.project.id
  cidr_block = var.route_table_cidr_block
  comment    = "Manged by Terraform"

  depends_on = [
    mongodbatlas_project.project,
    mongodbatlas_cluster.cluster
  ]
}

resource "aws_vpc_peering_connection_accepter" "peer_accepter" {
  count = local.enabled ? 1 : 0

  vpc_peering_connection_id = mongodbatlas_network_peering.test[0].connection_id
  auto_accept               = true

  tags = {
    Terraform = true
    Origin    = "MongoDB Atlas"
    Name      = "vpc-peering-to-mongodb-atlas-${mongodbatlas_project.project.id}"
  }

  depends_on = [
    mongodbatlas_network_peering.test
  ]
}

resource "aws_route" "routes" {
  # Only create routes for this route table if input dictates it, and in that case, for all combinations
  count                     = length(local.routes)
  route_table_id            = local.routes[count.index].rts_id
  destination_cidr_block    = local.routes[count.index].dest_cidr
  vpc_peering_connection_id = mongodbatlas_network_peering.test[0].connection_id

  depends_on = [
    aws_vpc_peering_connection_accepter.peer_accepter
  ]
}