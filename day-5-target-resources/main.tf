resource "aws_instance" "name" {
    ami = "ami-07860a2d7eb515d9a"
    instance_type = "t3.micro"
    availability_zone = "us-east-1a"
    tags = {
        Name = "dev"
    }

}

resource "aws_s3_bucket" "name" {
    bucket = "sshhttpinfo"
    tags = {
      Name = "sshhttpinfo"
    }
  

}