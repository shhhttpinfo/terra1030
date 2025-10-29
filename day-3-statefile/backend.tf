terraform {
  backend "s3" {
    bucket = "sshhttpinfo"
    key = "day-3/terraform.tfstate"
    region = "us-east-1"
  }
}