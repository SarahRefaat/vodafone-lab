#---------- define service account role for gks to read and get images from container registry 
resource "google_service_account" "con-reg" {
  account_id                   = "container-registry-for-gks"
  display_name                 = "container-registry-gks"
}

#---------- assign storage access permission for the role account to allow it to pull need images
resource "google_project_iam_binding" "storage-object-viewer" {
  role                          = "roles/storage.objectViewer"
  members                       = ["serviceAccount:${google_service_account.con-reg.email}",]
  }
#---------------------------------------------------------------------------------------------------------

#-------------------------- building private gke
resource "google_container_cluster" "primary" {
  name                           = var.cluster_name
  location                       = var.zones_list[0]
  node_locations                 = [var.zones_list[1]]
  network                        = var.network_name
  networking_mode                = "VPC_NATIVE"
  ip_allocation_policy {
    cluster_ipv4_cidr_block      = "192.168.0.0/16"   
  } 
  subnetwork                     = var.subnet_name
  cluster_autoscaling {
    enabled                      = false
  }
  private_cluster_config {
  enable_private_nodes           = true 
  enable_private_endpoint        = true
  master_ipv4_cidr_block         = var.cluster_master_cidr
  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block                 = var.subnet_cidr
    }
  }
  #service_account                = google_service_account.con-reg.account_id
  remove_default_node_pool       = true
  initial_node_count             = 1
}

#--------------------- assign node pool for the cluster after removing the default one
resource "google_container_node_pool" "nodepool" { 
  name                           = "pool1"
  cluster                        = google_container_cluster.primary.id
  location                       = var.cluster_region 
  node_count                     = var.number_of_nodes_per_zone
  node_config {
      machine_type               = var.machine_type
      image_type                 = "COS_CONTAINERD"
      disk_type                  = "pd-standard"
      disk_size_gb               = 100
      service_account            = google_service_account.con-reg.email   
      oauth_scopes               = [
          "https://www.googleapis.com/auth/cloud-platform"
      ]
  }
}

