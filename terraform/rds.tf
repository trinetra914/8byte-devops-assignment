resource "aws_db_subnet_group" "postgres" {
  name = "byte8-postgres-subnet-group"

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  tags = {
    name = "byte8-postgres-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier = var.rds_identifier

  engine         = "postgres"
  engine_version = "17"

  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp3"

  db_name  = var.rds_database_name
  username = var.rds_username
  password = var.rds_password

  port = var.rds_port

  db_subnet_group_name = aws_db_subnet_group.postgres.name

  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]

  publicly_accessible = false
  skip_final_snapshot = true
  deletion_protection = false
  multi_az            = false

  backup_retention_period = 1

  tags = {
    Name = "8byte-postgres"
  }
}