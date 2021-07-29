#----------- Configure the Google Cloud provider
provider "google" {
  credentials                   = file("credentials.json")
  project                       = "numeric-virtue-320621"
  region                        = "us-central1"
}

#--------------- module for network which includes VPC , subnet and firewall rules
module "network" {
  source                         = "./modules/network"

   vpc_cidr                      = var.vpc_cidr
   vpc_name                      = var.vpc_name
   subnet_cidr                   = var.subnet_cidr
   subnet_name                   = var.subnet_name
}

#----------------- module for gks which includes 
module "gks" {
  source                          = "./modules/gks"

    cluster_region                = var.cluster_region 
    zones_list                    = var.zones_list
    node_machine_type             = var.node_machine_type
    number_of_nodes_per_zone      = var.number_of_nodes_per_zone
    cluster_name                  = var.cluster_name
    cluster_master_cidr           = var.cluster_master_cidr
    network_name                  = module.network.network_name
    subnet_name                   = module.network.subnet_name
    subnet_cidr                   = var.subnet_cidr
}

#-------------------- module for VM
module "vm" {
  source                          = "./modules/vm"
 
    machine_name               = var.machine_name
    machine_type               = var.vm_machine_type
    image_type                 = var.image_type
    region                     = var.region
    zone                       = var.zone
    network_name               = module.network.network_name
    subnet_name                = module.network.subnet_name
}

#------------------------ module for buckets
module "bucket1" {
  source = "./modules/bucket"
    
    bucket_name                = var.bucket1_name
    bucket_storage_class      = var.bucket1_storage_class
  
}


module "bucket2" {
  source = "./modules/bucket"
    
    bucket_name                = var.bucket2_name
    bucket_storage_class      = var.bucket2_storage_class
  
}


module "bucket3" {
  source = "./modules/bucket"
    
    bucket_name                = var.bucket3_name
    #bucket1_storage_class      = var.bucket3_storage_class
  
}

#----------------------------- module for bigqueries
module "bq" {
  source = "./modules/bq"
 
    for_each = toset(var.bqs)

      dataset_name = each.value
  
}