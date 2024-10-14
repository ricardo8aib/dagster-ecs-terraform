variable "DATASYNC_TASK_NAME" {
  description = "The name of the DataSync task"
  type        = string
}

variable "DATASYNC_TASK_ROLE_ARN" {
  description = "The ARN of the DataSync task role"
  type        = string
}

variable "CODE_LOCATION_BUCKET_ARN" {
  description = "The ARN of the code location Bucket"
  type        = string
}

variable "CODE_LOCATION_BUCKET_NAME" {
  description = "The name of the code location Bucket"
  type        = string
}

variable "EFS_ARN" {
  description = "The ARN of the EFS"
  type        = string
}

variable "DAGSTER_SERVICES_SG_ARN" {
  description = "The dagster services SG ARN"
  type        = string
}

variable "SUBNET_ARN" {
  description = "The ARN of the subnet where the resources are"
  type        = string
}