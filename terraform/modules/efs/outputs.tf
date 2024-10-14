output "efs" {
  value = {
    efs_arn = aws_efs_file_system.dagster_efs.arn
    efs_id = aws_efs_file_system.dagster_efs.id
  }
}