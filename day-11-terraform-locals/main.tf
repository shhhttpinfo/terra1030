# locals {
#   bucket-name = "${var.layer}-${var.env}-bucket-hydnaresh"
#   region = "us-west-2"
#   #provider = aws.oregon
# }

# resource "aws_s3_bucket" "demo" {
#     # bucket = "web-dev-bucket"
#     # bucket = "${var.layer}-${var.env}-bucket-hyd"
#     bucket = local.bucket-name
#     region = local.region
#     #provider = local.provider
#     tags = {
#         # Name = "${var.layer}-${var.env}-bucket-hyd"
#         Name = local.bucket-name
#         Environment = var.env
#     }
    

  
# }


locals {
  region        = "us-east-1"
  instance_type = "t3.micro"
  ami           = "ami-0cae6d6fe6048ca2c"
}

resource "aws_instance" "example" {
  ami = local.ami
  instance_type = local.instance_type
  tags = {
    Name = "App-${local.region}"
  }
}