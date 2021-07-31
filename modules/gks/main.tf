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

#-------------------------- building private gke cluster
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
  enable_private_endpoint        = false 
  master_global_access_config { 
    enabled                      = true
  }
  master_ipv4_cidr_block         = var.cluster_master_cidr
  }
  #master_authorized_networks_config {
   # cidr_blocks {
    #  cidr_block                 = "0.0.0.0/0"
    #}
  #}
  master_auth {
    client_certificate_config {
      issue_client_certificate   = true
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
  lifecycle {
    ignore_changes = [
      initial_node_count
    ]
  }
  node_config {
      machine_type               = var.node_machine_type
      image_type                 = "COS_CONTAINERD"
      disk_type                  = "pd-standard"
      disk_size_gb               = 100
      service_account            = google_service_account.con-reg.email   
      oauth_scopes               = [
          "https://www.googleapis.com/auth/cloud-platform"
      ]
  }
}

#---------------------------------------------- kubernetes for namespaces and deployments
data "google_client_config" "runner"{}

provider "kubernetes" {
  host                           = "https://${google_container_cluster.primary.endpoint}"
  token                          = data.google_client_config.runner.access_token 
  cluster_ca_certificate         = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate,)
}

##create two namespaces 1-shared-services , 2-dev

resource "kubernetes_namespace" "sv" {
  metadata {
    annotations                  = {
      name                       = "shared-services"
    }
    name                         = "shared-services"
  }
}


resource "kubernetes_namespace" "dev" {
  metadata {
    annotations                  = {
      name                       = "dev"
    }
    name                         = "dev"
  }
}

## create deployments for jenkins and nexus
resource "kubernetes_pod" "jenkins" {
  metadata {
    name                        = "jenkins"
    namespace                   = kubernetes_namespace.sv.metadata.0.name
  }  
  spec {
    container {
    image                       = "gcr.io/numeric-virtue-320621/jenkins"
    name                        = "jenkins"
    port {
        container_port = 8080
      }
    }
  }
  depends_on =[
    google_container_node_pool.nodepool,
  ]
}

resource "kubernetes_pod" "nexus" {
  metadata {
    name                        = "nexus"
    namespace                   = kubernetes_namespace.sv.metadata.0.name
  }  
  spec {
    container {
    image                       = "gcr.io/numeric-virtue-320621/nexus3"
    name                        = "nexus"
    port {
        container_port = 80
      }
    }
  }
  depends_on =[
    google_container_node_pool.nodepool,
  ]
}
#gcr.io/numeric-virtue-320621/web-app
resource "kubernetes_pod" "web-app" {
  metadata {
    name                        = "web-app"
    namespace                   = kubernetes_namespace.dev.metadata.0.name
  }  
  spec {
    container {
    image                       = "gcr.io/numeric-virtue-320621/web-app"
    name                        = "web-app"
    port {
        container_port = 80
      }
    }
  }
  depends_on =[
    google_container_node_pool.nodepool,
  ]
}

#resource "kubernetes_deployment" "nexus" {
#  metadata {
#    name                        = "nexus"
#    namespace                   = kubernetes_namespace.sv.metadata.0.name
#  }  
#  spec {
#    replicas                    = 1
#    selector {
#      match_labels = {
#        app                     = "nexus"
#      }
#    }
#    template {
#      metadata {
#        labels = {
#          app                  = "nexus"
#        }
#      }
#    spec{
#    container {
#    image                       = "gcr.io/numeric-virtue-320621/nexus3"
#    name                        = "nexus"
#    port {
#        container_port          = 80
#       }
#      }
#     }
#    }
#  }
#}
