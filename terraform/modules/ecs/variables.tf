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

# --------------------------------------------------------------------------------------------------------
# CODE LOCATIONS Variables
# --------------------------------------------------------------------------------------------------------

variable "CODE_LOCATIONS_DICT" {
  description = "A dictionary with the code location parameters"
  type = map(object({
    environment               = string # Test, Dev or Prod
    task_family_name          = string # The name of the Task family for the Code Location
    container_name            = string # The name of the container for the Code Location
    repo_name                 = string # This will be used to get the image
    region                    = string # This will be used to get the image
    accountnumber             = string # This will be used to get the image
    module_path               = string # The folder with the assets. This will be initialized by the dagster bash command.
    volume_path               = string # The path of the EFS (Or S3) that will be attached to the container.
    code_location_volume_name = string # The name of the volume that will be created for the code location container
  }))
}

variable "SUBNET_IDS_FOR_DAGSTER_CODE_LOCATION" {
  description = "List of subnet IDs for Dagster Code Location ECS Service (private subnet recommended)"
  type        = list(string)
}
