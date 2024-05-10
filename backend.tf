terraform {
  backend "s3" {
    bucket = var.bucket-name
    key    = var.bucket-path
    region = var.region
    dynamodb_table = var.dynamodb-table-name // locking state file for preventing concurrent access for the same state file  
  }
}
