output "datasync_task" {
  value = {
    datasync_task_arn = aws_datasync_task.s3_to_efs.arn
    datasync_task_name  = aws_datasync_task.s3_to_efs.name
  }
}