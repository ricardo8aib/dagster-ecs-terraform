variable "DATASYNC_ROLE_NAME" {
  description = "The name of the datasync role"
  type        = string
}

variable "DATASYNC_POLICY_NAME" {
  description = "The name of the datasync policy"
  type        = string
}

variable "ECS_ROLE_NAME" {
  description = "The name of the ECS role"
  type        = string
}

variable "ECS_POLICY_NAME" {
  description = "The name of the ECS policy"
  type        = string
}

variable "CODE_LOCATION_BUCKET_ARN" {
  description = "The arn of the code location bucket"
  type        = string
}

variable "EFS_ARN" {
  description = "The arn of the EFS"
  type        = string
}
