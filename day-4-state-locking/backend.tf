terraform {
  backend "s3" {
    bucket = "sshhttpinfo"
    key = "day-4/terraform.tfstate"
    use_lockfile = true
    region = "us-east-1"

  }
}