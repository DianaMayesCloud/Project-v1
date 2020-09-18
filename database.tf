resource "aws_db_subnet_group" "green_subnet_group" {
  name       = "green_subnet_group"
  subnet_ids = [aws_subnet.priv2_az2_subnet.id, aws_subnet.priv2_az1_subnet.id]
  tags = {
    Name = "green_subnet_group"
  }
}

resource "aws_db_instance" "green-db-mysql" {
  name                   = "gogreendb"
  engine                 = "mysql"
  engine_version         = "5.7"
  vpc_security_group_ids = [aws_security_group.green_priv2_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.green_subnet_group.id
  username               = "admin"
  password               = "password"
  port                   = 3306
  allocated_storage      = 20
  storage_type           = "gp2"
  instance_class         = "db.t2.micro"
  storage_encrypted      = false
  #monitoring_interval                 = 10
  #monitoring_role_arn                 = "value"
  skip_final_snapshot                 = true
  delete_automated_backups            = true
  iam_database_authentication_enabled = true
  enabled_cloudwatch_logs_exports     = ["audit", "error", "general", "slowquery"]
  backup_retention_period             = 7
  apply_immediately                   = true
  tags = {
    Name = "green-db-mysql"
  }
}

# resource "aws_rds_cluster" "green_db" {
#   cluster_identifier      = "aurora-cluster-demo"
#   engine                  = "aurora-mysql"
#   availability_zones      = ["us-west-1a", "us-west-1b"]
#   database_name           = "gogreen_db"
#   master_username         = "admin"
#   master_password         = "password"
#   backup_retention_period = 5
#   preferred_backup_window = "07:00-09:00"
#   db_subnet_group_name    = aws_db_subnet_group.green_subnet_group.id
#   skip_final_snapshot     = true
# }
