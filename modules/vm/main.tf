#---------- define service account role for the compute instance to read from buckets
resource "google_service_account" "vm-storage" {
  account_id                    = "bucket-reader"
  display_name                  = "bucket-reader-for-vm"
}

#---------- assign storage access permission for the role account to allow it to list buckets
resource "google_project_iam_binding" "bucket-object-viewer" {
  role                          = "roles/storage.objectViewer"
  members                       = ["serviceAccount:${google_service_account.vm-storage.email}",]
  }

#---------- assign storage access permission for the role account to allow it to read/write bigqueries
resource "google_project_iam_binding" "bq-read-write" {
  role                          = "roles/bigquery.user"
  members                       = ["serviceAccount:${google_service_account.vm-storage.email}",]
  }

#-------------------------------------------------------------------------------------------------------------

#----------- build VM
resource "google_compute_instance" "default" {
  name                          = var.machine_name
  machine_type                  = var.machine_type
  zone                          = var.zone
  network_interface {
    network                     = var.network.network_name
    subnetwork                  = var.subnet.subnet_name
  }
  service_account {
    email                       = google_service_account.vm-storage.email 
    oauth_scopes                = [
          "https://www.googleapis.com/auth/cloud-platform"
      ]
  }
  boot_disk {
    initialize_params {
      image = var.image_type
    }
  }
}