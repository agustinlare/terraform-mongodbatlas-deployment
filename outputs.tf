output "project_name" {
  value = mongodbatlas_project.project.name
}

output "project_id" {
  value = mongodbatlas_project.project.id
}

output "connection_strings" {
  # Example return string: standard_srv = "mongodb+srv://cluster-atlas.ygo1m.mongodb.net"
  value = mongodbatlas_cluster.cluster.connection_strings[0].standard_srv
}

output "container_id" {
  value = mongodbatlas_cluster.cluster.container_id
}