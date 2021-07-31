
#for network module

variable "vpc_cidr" {}
variable "vpc_name" {}
variable "subnet_cidr" {}
variable "subnet_name" {}

#------------------------------------------------

#for gks module

variable "cluster_region" {}
variable "zones_list" {
    type = list(string)
}
variable "node_machine_type" {}
variable "number_of_nodes_per_zone" {}
variable "cluster_name" {}
variable "cluster_master_cidr" {}
variable "username" {}
variable "password" {}

#--------------------------------

#for VM

variable "machine_name" {}
variable "vm_machine_type" {}
variable "image_type" {}
variable "region" {}
variable "zone" {}

#---------------------------------

#for buckets
variable "bucket1_name" {}
variable "bucket1_storage_class" {}

variable "bucket2_name" {}
variable "bucket2_storage_class" {}

variable "bucket3_name" {}

#--------------------------------------

#for bq
variable "bqs" {
    type = list(string)
}