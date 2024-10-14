# Step Function
resource "aws_sfn_state_machine" "datasync_state_machine" {
  name     = var.DATASYNC_STATE_MACHINE_NAME
  role_arn = aws_iam_role.sfn_execution_role.arn

  definition = <<DEFINITION
{
  "Comment": "A Step Function to start a DataSync task",
  "StartAt": "Start DataSync Task",
  "States": {
    "Start DataSync Task": {
      "Type": "Task",
      "Resource": "arn:aws:states:::aws-sdk:datasync:startTaskExecution",
      "Parameters": {
        "TaskArn": "${var.DATASYNC_TASK_ARN}"
      },
      "End": true
    }
  }
}
DEFINITION
}

# EventBridge Rule
resource "aws_cloudwatch_event_rule" "s3_object_created_rule" {
  name        = var.CLOUDWATCH_S3_OBJECT_CREATED_RULE_NAME
  description = "Trigger Step Function when an object is created in S3"
  event_pattern = jsonencode({
    "source": ["aws.s3"],
    "detail-type": ["Object Created", "Object Deleted"],
    "detail": {
      "bucket": {
        "name": ["${var.BUCKET_NAME}"]
      }
    }
  })
}

# EventBridge Target
resource "aws_cloudwatch_event_target" "invoke_sfn" {
  rule      = aws_cloudwatch_event_rule.s3_object_created_rule.name
  arn       = aws_sfn_state_machine.datasync_state_machine.arn
  role_arn  = aws_iam_role.eventbridge_target_execution_role.arn
}
