#------------- vpc resource
resource "google_compute_network" "network" {
  name                            = var.vpc_name
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  #project                        = "numeric-virtue-320621"
}

#---------------- subnet resource

resource "google_compute_subnetwork" "subnet" {
  name                           = var.subnet_name
  ip_cidr_range                  = var.subnet_cidr 
  region                         = "us-central1"
  network                        = google_compute_network.network.id 
  private_ip_google_access       = true
}

#---------------- firewall resource
resource "google_compute_firewall" "firewall" {
  name                           = "terrafrom-firewall"
  network                        = google_compute_network.network.name
  source_ranges                  = ["35.235.240.0/20"]
  allow{
      protocol = "tcp"
      ports = [ "22" , "80" ,"8080" , "3389" ]
  } 
}