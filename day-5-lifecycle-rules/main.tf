resource "aws_instance" "dev" {
    ami = "ami-07860a2d7eb515d9a"
    instance_type = "t3.micro"
    tags = {
      Name = "prod"
    }

    # lifecycle {
    #   create_before_destroy = true
    # }
    # lifecycle {
    #   ignore_changes = [tags,  ]
    # }
    # lifecycle {
    #   prevent_destroy = true
    # }
  
}