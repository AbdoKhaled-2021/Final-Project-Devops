terraform {
  backend "s3" {
    bucket = "sprints-bootcamp-tf-state-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "sprints"
  }
}