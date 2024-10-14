variable "DATASYNC_STATE_MACHINE_NAME" {
  description = "The name of the datasync state machine"
  type        = string
}

variable "DATASYNC_STATE_MACHINE_EXECUTION_ROLE_NAME" {
  description = "The name of the datasync state machine execution role"
  type        = string
}

variable "DATASYNC_TASK_ARN" {
  description = "The ARN of the DataSync task that will be triggered"
  type        = string
}

variable "CLOUDWATCH_S3_OBJECT_CREATED_RULE_NAME" {
  description = "The name of the S3 object created rule for cloudwatch"
  type        = string
}

variable "BUCKET_NAME" {
  description = "The name of the Bucket that will trigger the setp function"
  type        = string
}

variable "DATASYNC_EVENTBRIDGE_TARGET_EXECUTION_ROLE_NAME" {
  description = "The name of the EventBridge Targete Execution Role name"
  type        = string
}

variable "STEP_FUNCTION_EXECUTION_POLICY_NAME" {
  description = "The name of the Step Function Execution Policy name"
  type        = string
}

variable "EVENTBRIDGE_TARGET_EXECUTION_POLICY_NAME" {
  description = "The name of the EventBridge Target Execution Policy Name"
  type        = string
}