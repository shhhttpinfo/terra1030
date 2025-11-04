data "aws_db_instance" "default" {
    db_instance_identifier = "book-rds"
  
}

resource "aws_db_instance" "read_replica" {
  identifier             = "book-rds-replica"
  replicate_source_db    = data.aws_db_instance.default.db_instance_identifier
  instance_class         = "db.t3.micro"
  publicly_accessible    = false
  skip_final_snapshot    = true
  deletion_protection    = false

  tags = {
    Name = "book-rds-replica"
  }

}