#
resource "google_storage_bucket" "bucket"{
  name                         = "numeric-virtue-320621-${var.bucket_name}"
  location                     = "US-CENTRAL1"
  force_destroy                = true 
  storage_class                = var.bucket_storage_class
  versioning {
      enabled                  = true
  }
  uniform_bucket_level_access  = true 
}