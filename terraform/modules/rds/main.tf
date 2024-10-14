resource "aws_db_instance" "dagster_postgres" {
  allocated_storage      = 20
  engine                 = var.ENGINE
  engine_version         = var.ENGINE_VERSION
  instance_class         = var.DB_INSTANCE_CLASS
  identifier             = var.DB_IDENTIFIER
  db_name                = var.DB_NAME
  username               = var.DB_USERNAME
  password               = var.DB_PASSWORD
  storage_type           = "gp2"
  vpc_security_group_ids = [var.DAGSTER_DATABASE_SG_ID]
  db_subnet_group_name   = var.DAGSTER_DATABASE_SUBNET_GROUP
  skip_final_snapshot    = true
  publicly_accessible    = true
  storage_encrypted      = false
  apply_immediately      = false
}

