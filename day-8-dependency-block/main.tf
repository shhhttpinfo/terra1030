resource "aws_instance" "name" { 
    instance_type = "t3.micro"
     ami = "ami-07860a2d7eb515d9a"
     tags = {
       Name = "prod"
     }
     
  
}

resource "aws_s3_bucket" "name" {
    bucket = "sshhttpinfo"
    depends_on = [ aws_instance.name ]
  
}