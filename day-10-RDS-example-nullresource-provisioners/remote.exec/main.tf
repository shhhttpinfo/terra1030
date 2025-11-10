# Example EC2 instance (replace with yours if already existing)
resource "aws_instance" "sql_runner" {
  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type          = "t3.micro"
  key_name               = "RDS"                # Replace with your key pair name
  associate_public_ip_address = true

  tags = {
    Name = "SQL Runner"
  }
}

# Deploy SQL remotely using null_resource + remote-exec
resource "null_resource" "remote_sql_exec" {
  depends_on = [aws_db_instance.default, aws_instance.sql_runner]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/RDS.pem")   # Replace with your PEM file path
    host        = aws_instance.sql_runner.public_ip
  }

  provisioner "file" {
    source      = "init.sql"
    destination = "/tmp/init.sql"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y mysql", 
      "echo 'Waiting 90 seconds for RDS to become available...'",
      "sleep 90",
      "mysql -h ${aws_db_instance.default.address} -u admin -pCloud123 < /tmp/init.sql"
    ]
  }

  triggers = {
    always_run = timestamp() #trigger every time apply 
  }
}




# ADD RDS creation script only accessbale interanlly si disable public access 
# Remote provisioner server also should create insame vpc 
# enable secrets from secret manager and call secrets into RDS for this process vpc endpoint is require or nat gateway is required to access secrets to rds internall as secremanger is not in side VPC sefrvice 
resource "aws_db_instance" "default" {
  allocated_storage       = 10
  db_name                 = "mydb"
  identifier              = "rds-test"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                = "admin"
  password                = "Cloud123"
  publicly_accessible     = true
  db_subnet_group_name    = aws_db_subnet_group.sub-grp.id
  parameter_group_name    = "default.mysql8.0"

  # Enable backups and retention
  backup_retention_period  = 7   # Retain backups for 7 days
  backup_window            = "02:00-03:00" # Daily backup window (UTC)

  # Enable monitoring (CloudWatch Enhanced Monitoring)
  monitoring_interval      = 60  # Collect metrics every 60 seconds
  monitoring_role_arn      = aws_iam_role.rds_monitoring.arn

  # Enable performance insights
  # performance_insights_enabled          = true
  # performance_insights_retention_period = 7  # Retain insights for 7 days

  # Maintenance window
  maintenance_window = "sun:04:00-sun:05:00"  # Maintenance every Sunday (UTC)

  # Enable deletion protection (to prevent accidental deletion)
  # deletion_protection = true

  # Skip final snapshot
  skip_final_snapshot = true
}

# # IAM Role for RDS Enhanced Monitoring
resource "aws_iam_role" "rds_monitoring" {
  name = "rds-monitoring-role-new"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
    }]
  })
}

#IAM Policy Attachment for RDS Monitoring
resource "aws_iam_role_policy_attachment" "rds_monitoring_attach" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}


# resource "aws_db_subnet_group" "sub-grp" {
#   name       = "mycutsubnet"
#   subnet_ids = ["subnet-0f9ebfb0d2f86e0c1", "subnet-064f1dab86a2f7860"]

#   tags = {
#     Name = "My DB subnet group"
#   }
# }




####### with data source ###########
data "aws_subnet" "subnet_1" {
  filter {
    name   = "tag:Name"
    values = ["subnet-1"]
  }
}

data "aws_subnet" "subnet_2" {
  filter {
    name   = "tag:Name"
    values = ["subnet-2"]
  }
}
resource "aws_db_subnet_group" "sub-grp" {
  name       = "mycutsubnet"
  subnet_ids = [data.aws_subnet.subnet_1.id, data.aws_subnet.subnet_2.id]

  tags = {
    Name = "My DB subnet group"
  }
}