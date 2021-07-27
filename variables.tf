
#for network module

variable "vpc_cidr" {}
variable "vpc_name" {}
variable "subnet_cidr" {}
variable "subnet_name" {}

#for gks module
variable "cluster_region" {}
variable "zones_list" {
    type = list(string)
}
variable "machine_type" {}