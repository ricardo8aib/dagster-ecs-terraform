output "dagster_ecr_arns" {
  value = {
    dagster_code_location = aws_ecr_repository.dagster_code_location_repository.arn
    dagster_web_server    = aws_ecr_repository.dagster_web_server_repository.arn
    dagster_daemon        = aws_ecr_repository.dagster_daemon_repository.arn
  }
}

output "dagster_ecr_urls" {
  value = {
    dagster_code_location = aws_ecr_repository.dagster_code_location_repository.repository_url
    dagster_web_server    = aws_ecr_repository.dagster_web_server_repository.repository_url
    dagster_daemon        = aws_ecr_repository.dagster_daemon_repository.repository_url
  }
}
