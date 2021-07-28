
#------------------ values for network module
vpc_cidr                   = "10.0.0.0/16"
vpc_name                   = "my-vpc-terraform-lab"
subnet_cidr                = "10.0.1.0/24"
subnet_name                = "subnet1"

#----------------- values for gks
cluster_region             = "us-central1"
zones_list                 = ["us-central1-c","us-central1-f"]
machine_type               = "e2-standard-2"
number_of_nodes_per_zone   = 2
cluster_name               = "terraform-lab"
cluster_master_cidr        = "10.0.2.0/28"

# -------------------- values for VM
machine_name               = "for-test"
vm_machine_type            = "e2-medium"
image_type                 = "debian-cloud/debian-10"
region                     = "us-east1"
zone                       = "us-east1-c"
