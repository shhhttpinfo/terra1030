data "aws_subnet" "subnet_3" {
  filter {
    name   = "tag:Name"
    values = ["subnet-3"]
  }
}

data "aws_subnet" "subnet_4" {
  filter {
    name   = "tag:Name"
    values = ["subnet-4"]
  }
}
resource "aws_db_subnet_group" "sub-grp" {
  name       = "mycutsubnet-2"
  subnet_ids = [data.aws_subnet.subnet_3.id, data.aws_subnet.subnet_4.id]

  tags = {
    Name = "My DB subnet group-2"
  }
}