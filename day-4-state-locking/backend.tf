terraform {
  backend "s3" {
    bucket = "sshhttpinfo"
    key = "day-4/terraform.tfstate"
    region = "us-east-1"
  }
}