terraform {
  backend "s3" {
    bucket = var.bucket-name
    key    = var.bucket-path
    region = var.region
  }
}
