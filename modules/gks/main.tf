#---------- define service account role for gks to read and get images from container registry 
resource "google_service_account" "con-reg" {
  account_id             = "container-registry-for-gks"
  display_name           = "container-registry-gks"
}
#---------- assign storage access permission for the role account to allow it to pull need images
resource "google_project_iam_binding" "storage-object-viewer" {
  role                   = "roles/storage.objectViewer"
  members                 = ["serviceAccount:${google_service_account.con-reg.email}",]
  }

