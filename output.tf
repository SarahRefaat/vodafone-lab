#------------- output the vpc
output "network_name" {
  value                = module.network.network_name
}

#--------------- output the subnet
output "subnet_name" {
  value                = module.network.subnet_name
}
output "load_balancer_ip" {
  value               = module.gks.load_balancer_ip
}

output "jenkins_ip" {
  value               = module.gks.jenkins_ip 
}