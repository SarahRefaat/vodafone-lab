
variable "cluster_region" {}

variable "zones_list" {
    type = list(string)
}

variable "node_machine_type" {}
variable "number_of_nodes_per_zone" {}

variable "cluster_name" {}
variable "cluster_master_cidr" {}


#------------ variables for linking :)
variable "network_name" {}
variable "subnet_name" {}
variable "subnet_cidr" {}

