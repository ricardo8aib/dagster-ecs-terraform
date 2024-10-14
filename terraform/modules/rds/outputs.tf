output "db_instance" {
  value = {
    db_instance_endpoint = split(":", aws_db_instance.dagster_postgres.endpoint)[0]
    db_name              = var.DB_NAME
    db_username          = var.DB_USERNAME
    db_password          = var.DB_PASSWORD
  }
}
