# Create VPC
resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "Cust_vpc"
    }
  
}

# Create Subnets
resource "aws_subnet" "name-1" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    tags = {
      Name = "public-subnet"
    }
  
}

resource "aws_subnet" "name-2" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1b"
    tags = {
      Name = "private-subnet"
    }

}

# Create IG and attach to VPC
resource "aws_internet_gateway" "name" {
    vpc_id = aws_vpc.name.id
    tags = {
      Name = "cust-ig"
    }
  
}

# Create Route table and edit route
resource "aws_route_table" "name-1" {
    vpc_id = aws_vpc.name.id

    route {

        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.name.id

    }

    tags = {
      Name = "cust-rt-public"
    }
  
}

# Create subnet association

resource "aws_route_table_association" "name" {
    subnet_id = aws_subnet.name-1.id
    route_table_id = aws_route_table.name-1.id
  
}

# Create EIP
resource "aws_eip" "nat" {
    domain = "vpc"
    tags = {
      Name = "nat"
    }
  
}

# Create NAT
resource "aws_nat_gateway" "name" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.name-1.id
    tags = {
      Name = "cust-nat"
    }
  depends_on = [ aws_internet_gateway.name ]
}

# Create Route table 2 and edit route 
resource "aws_route_table" "name-2" {
    vpc_id = aws_vpc.name.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.name.id
    }
    tags = {
      Name = "cust-rt-private"
    }

}

# Create subnet association
resource "aws_route_table_association" "name2" {
    subnet_id = aws_subnet.name-2.id
    route_table_id = aws_route_table.name-2.id
  
}

# Create SG
resource "aws_security_group" "dev_sg" {
  name   = "allow_tls"
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "dev-sg"
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create servers
resource "aws_instance" "public" {
    ami = "ami-07860a2d7eb515d9a"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.name-1.id
    vpc_security_group_ids = [ aws_security_group.dev_sg.id ]
    associate_public_ip_address = true
    tags = {
      Name = "public-ec2"
    }
  
}
resource "aws_instance" "private" {
    ami = "ami-0bdd88bd06d16ba03"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.name-2.id
    vpc_security_group_ids = [ aws_security_group.dev_sg.id ]
    associate_public_ip_address = false
    tags = {
      Name = "private-ec2"
    }

}