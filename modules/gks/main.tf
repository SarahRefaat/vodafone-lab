#---------- define service account role for gks to read and get images from container registry 
resource "google_service_account" "con-reg" {
  account_id   = "container-registry-for-gks"
  display_name = "container-registry-gks"
}

resource "google_service_account_iam_binding" "storage-object-viewer" {
  service_account_id = google_service_account.sa.name
  role               = "roles/storage.objectViewer"
  }
  