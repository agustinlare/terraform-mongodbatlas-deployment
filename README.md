# terraform-mongodbatlas-module-project

```
module "mongodb_deployment" {  
  source  = "app.terraform.io/clave/module-project/mongodbatlas"
  version = "0.0.1"

  organization_id = var.MONGODB_ATLAS_ORGANIZATION_ID
  name            = "foo-bar" # Final result will have project at the end of string
  env        = "dev"
  num_shards = 1

  regions_config = [{
    region_name     = "US_EAST_2"
    electable_nodes = 3
    priority        = 7
    read_only_nodes = 0
  }]

  disk_auto_scaling           = true
  mongodb_version             = "4.4"
  cloud_backup                = true
  disk_size_gb                = 50
  provider_instance_size_name = "M10"
  
  peering_enabled        = true
  route_table_cidr_block = "11.222.333.44/16"
  vpc_id                 = "vpc-id9384279238"
  aws_account_id         = data.aws_caller_identity.current.account_id
}
```