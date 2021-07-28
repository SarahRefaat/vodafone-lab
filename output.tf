#------------- output the vpc
output "network_name" {
  value                = module.network.network_name
}

#--------------- output the subnet
output "subnet_name" {
  value                = module.network.subnet_name
}