terraform {
  backend "s3" {
    bucket = "sshhttpinfo"
    key = "day-2/terraform.tfstate"
    region = "us-east-1"
  }
}