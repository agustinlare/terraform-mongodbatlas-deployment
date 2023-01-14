variable "organization_id" {
  type        = string
  description = "The ID of the organization you want to create the project within."
}

variable "name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "regions_config" {
  type = list(object({
    region_name     = string
    electable_nodes = number
    priority        = number
    read_only_nodes = number
  }))

  description = "Physical location of the region. Each regionsConfig document describes the region's priority in elections and the number and type of MongoDB nodes Atlas deploys to the region. You must order each regionsConfigs document by regionsConfig.priority, descending."

  default = [{
    region_name     = "US_EAST_1"
    electable_nodes = 3
    priority        = 7
    read_only_nodes = 0
  }]
}

variable "mongodb_version" {
  type        = string
  default     = null
  description = "Version of the cluster to deploy."
}

ariable "num_shards" {
  type        = number
  description = "Selects whether the cluster is a replica set or a sharded cluster. If you use the replicationSpecs parameter, you must set num_shards."
}

variable "disk_size_gb" {
  type        = number
  description = "Capacity, in gigabytes, of the host's root volume. Increase this number to add capacity, up to a maximum possible value of 4096 (i.e., 4 TB). This value must be a positive integer."
  default     = 10
}

variable "cloud_backup" {
  type        = bool
  description = "Flag indicating if the cluster uses Cloud Backup for backups."
  default     = true
}

variable "disk_auto_scaling" {
  description = "Specifies whether disk auto-scaling is enabled."
  type        = bool
}

variable "provider_instance_size_name" {
  type        = string
  description = "Atlas provides different instance sizes, each with a default storage capacity and RAM size. The instance size you select is used for all the data-bearing servers in your cluster. See https://docs.atlas.mongodb.com/reference/api/clusters-create-one/ providerSettings.instanceSizeName for valid values and default resources."
}

variable "perring_enabled" {
  type        = bool
  defualt     = false
  description = "Whatever if a peering connection is establish with an AWS VPC"
}

variable "aws_account_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "route_table_cidr_block" {
  type = string
}

variable "container_id" {
  type = string
}

variable "region_name" {
  type = string
}

variable "subnets_id" {
  type = list(any)
}