resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = var.dataset_name
  friendly_name               = var.dataset_name
  location                    = "US-CENTRAL1"
}