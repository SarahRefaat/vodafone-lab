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
    machine_type                  = var.machine_type
    number_of_nodes_per_zone      = var.number_of_nodes_per_zone
    cluster_name                  = var.cluster_name
    cluster_master_cidr           = var.cluster_master_cidr
    network_name                  = module.network.network_name
    subnet_name                   = module.network.subnet_name
    subnet_cidr                   = var.subnet_cidr
}