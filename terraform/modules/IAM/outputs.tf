output "datasync_role" {
  value = {
    datasync_role_name = aws_iam_role.datasync_role.name
    datasync_role_arn  = aws_iam_role.datasync_role.arn
  }
}

output "ecs_role" {
  value = {
    ecs_role_name = aws_iam_role.ecs_task_execution_role.name
    ecs_role_arn  = aws_iam_role.ecs_task_execution_role.arn
  }
}