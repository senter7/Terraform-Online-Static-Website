provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "online-cv-terraform-state"
    key            = "terraform-remote-state/eu-west-1/online-cv.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "online-cv-terraform-states-lock-table"
  }
}