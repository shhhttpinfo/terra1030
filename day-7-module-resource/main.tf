module "s3-bucket" {
    source = "terraform-aws-modules/s3-bucket/aws"

    bucket = "sshhttpinfo"
    acl = "private"

    control_object_ownership = true
    object_ownership = "ObjectWriter"

    versioning = {
        enabled = true
    }
  
}