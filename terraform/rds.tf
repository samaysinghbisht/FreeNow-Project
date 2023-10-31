resource "aws_db_instance" "freenow_db" {
  allocated_storage      = var.db_allocated_storage
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "12.13"
  instance_class         = var.db_instance_class
  identifier             = "freenow-rds-instance"
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  skip_final_snapshot    = true
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.freenow_db_subnet_group.id
  vpc_security_group_ids = [aws_security_group.freenow_rds_sg.id]
  tags = {
    Name = "freenow-rds"
  }
}
