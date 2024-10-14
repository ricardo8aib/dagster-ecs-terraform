# --------------------------------------------------------------------------------------------------------
# GENERAL Variables
# --------------------------------------------------------------------------------------------------------

variable "ECS_CLUSTER_NAME" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "NAMESPACE_NAME" {
  description = "The name of Namespace"
  type        = string
}

variable "VPC_ID" {
  description = "The VPC ID for the namespace"
  type        = string
}

variable "TASK_ROLE_ARN" {
  description = "The ARN of the task role"
  type        = string
}

variable "TASK_EXECUTION_ROLE_ARN" {
  description = "The ARN of the task execution role"
  type        = string
}

variable "DATABASE_HOST" {
  description = "The database host"
  type        = string
}

variable "DATABASE_NAME" {
  description = "The database name"
  type        = string
}

variable "DATABASE_USERNAME" {
  description = "The database host"
  type        = string
}

variable "DATABASE_PASSWORD" {
  description = "The database host"
  type        = string
}

variable "EFS_ID" {
  description = "The EFS id"
  type        = string
}

variable "DAGSTER_SERVICES_SG" {
  description = "The name of the dagster services security group"
  type        = string
}

# --------------------------------------------------------------------------------------------------------
# CODE LOCATION Variables
# --------------------------------------------------------------------------------------------------------

variable "CODE_LOCATION_TASK_FAMILY_NAME" {
  description = "The name of the code location task family"
  type        = string
}

variable "SUBNET_IDS_FOR_DAGSTER_CODE_LOCATION" {
  description = "List with subnet ids"
  type        = list
}

variable "CODE_LOCATION_CONTAINER_NAME" {
  description = "The name of the code location container"
  type        = string
}

variable "CODE_LOCATION_IMAGE" {
  description = "The code location image"
  type        = string
}

variable "CODE_LOCATION_MODULE_PATH" {
  description = "The name or path of the module that will be used to start the code location server."
  type        = string
}

variable "CODE_LOCATION_VOLUME_NAME" {
  description = "The name of the volume that will be created for the code location container."
  type        = string
}

variable "EFS_CODE_LOCATION_VOLUME_PATH" {
  description = "The path in the EFS that will be attached to the container."
  type        = string
}

# --------------------------------------------------------------------------------------------------------
# DAGSTER RUNS Variables
# --------------------------------------------------------------------------------------------------------

variable "DAGSTER_RUNS_TASK_FAMILY_NAME" {
  description = "The name of the Dagster runs task family"
  type        = string
}

variable "DAGSTER_RUNS_CONTAINER_NAME" {
  description = "The name of the dagster runs container"
  type        = string
}

# --------------------------------------------------------------------------------------------------------
# DAEMON Variables
# --------------------------------------------------------------------------------------------------------

variable "DAEMON_TASK_FAMILY_NAME" {
  description = "The name of the Daemon task family"
  type        = string
}

variable "DAEMON_CONTAINER_NAME" {
  description = "The name of the Daemon container"
  type        = string
}

variable "DAEMON_IMAGE" {
  description = "The Daemon image"
  type        = string
}

variable "SUBNET_IDS_FOR_DAGSTER_DAEMON" {
  description = "List with subnet ids"
  type        = list
}

# --------------------------------------------------------------------------------------------------------
# WEBSERVER Variables
# --------------------------------------------------------------------------------------------------------

variable "WEBSERVER_TASK_FAMILY_NAME" {
  description = "The name of the Web Server task family"
  type        = string
}

variable "WEBSERVER_CONTAINER_NAME" {
  description = "The name of the Daemon container"
  type        = string
}

variable "WEBSERVER_IMAGE" {
  description = "The Web Server image"
  type        = string
}

variable "SUBNET_IDS_FOR_DAGSTER_WEBSERVER" {
  description = "List with subnet ids"
  type        = list
}

# --------------------------------------------------------------------------------------------------------
# ALB Variables
# --------------------------------------------------------------------------------------------------------

variable "WEBSERVER_ALB_NAME" {
  description = "The name of the ALB for the WebServer"
  type        = string
}

variable "ALB_SECURITY_GROUP" {
  description = "The Security Gorup ID for the ALB"
  type        = string
}

variable "ALB_TARGET_GROUP_NAME" {
  description = "The name of the target group for the ALB"
  type        = string
}

variable "SUBNET_IDS_FOR_ALB" {
  description = "List with subnet ids"
  type        = list
}
