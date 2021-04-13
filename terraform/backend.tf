terraform {
  backend "gcs" {
    bucket  = "test-terraform-bucket-1007"
    prefix  = "terraform/state"
  }
}
