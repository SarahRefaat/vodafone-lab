// Configure the Google Cloud provider
provider "google" {
 credentials = file("credentials.json")
 project     = "numeric-virtue-320621"
 region      = "us-central1"
}

module "network" {
 source = "./modules/network" 
 vpc_cidr = var.vpc_cidr
 vpc_name = var.vpc_name

 subnet_cidr=var.subnet_cidr
 subnet_name=var.subnet_name
}