terraform {
  backend "s3" {
    bucket = "sshhttpinfo"
    key = "day-1/terraform.tfstate"
    region = "us-east-1"
  }
}