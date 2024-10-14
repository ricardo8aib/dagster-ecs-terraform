# --------------------------------------------------------------------------------------------------------
# General Variables
# --------------------------------------------------------------------------------------------------------

variable "PROFILE" {
  description = "AWS Profile"
  type        = string
  default     = "default"
}

variable "PROJECT" {
  description = "The name of the project"
  type        = string
  default     = "poc-dagster"
}

variable "REGION" {
  description = "The region of the project"
  type        = string
  default     = "us-east-1"
}

# --------------------------------------------------------------------------------------------------------
# Subnet Variables
# --------------------------------------------------------------------------------------------------------

variable "SUBNET_IDS_FOR_ALB" {
  description = "List of subnet IDs for Dagster WebServer ALB (Should be Public)"
  type        = list(string)
  default = [
    "subnet-0db70a1c86eaa5e75", # TP Public A
    "subnet-0bc580920129a9b7d"  # TP Public B
  ]
}

variable "SUBNET_IDS_FOR_DAGSTER_WEBSERVER" {
  description = "List of subnet IDs for Dagster Webserver ECS Service"
  type        = list(string)
  default = [
    "subnet-095771a5e6abc3530", # TP Private A
    "subnet-0d01c50fd77fa07c1"  # TP Private B
  ]
}

variable "SUBNET_IDS_FOR_DAGSTER_DAEMON" {
  description = "List of subnet IDs for Dagster Daemon ECS Service (private subnet recommended)"
  type        = list(string)
  default = [
    "subnet-095771a5e6abc3530", # TP Private A
    "subnet-0d01c50fd77fa07c1"  # TP Private B
  ]
}

variable "SUBNET_IDS_FOR_DAGSTER_CODE_LOCATION" {
  description = "List of subnet IDs for Dagster Code Location ECS Service (private subnet recommended)"
  type        = list(string)
  default = [
    "subnet-095771a5e6abc3530", # TP Private A
    "subnet-0d01c50fd77fa07c1"  # TP Private B
  ]
}

variable "SUBNET_IDS_FOR_EFS" {
  description = "List of subnet IDs for EFS"
  type        = list(string)
  default = [
    "subnet-095771a5e6abc3530", # TP Private A
    "subnet-0d01c50fd77fa07c1"  # TP Private B
  ]
}

variable "SUBNET_ARN_FOR_DATASYNC_TASK" {
  description = "The ARN of the subnet for DataSync Task (private subnet recommended)"
  type        = string
  default     = "arn:aws:ec2:us-east-1:668221262652:subnet/subnet-095771a5e6abc3530"
}

# --------------------------------------------------------------------------------------------------------
# Networking Variables
# --------------------------------------------------------------------------------------------------------

variable "DAGSTER_DATABASE_SG_VPC" {
  description = "The VPC where the database is going to be located"
  default     = "vpc-0e763f5d3cc488c78"
}

variable "DAGSTER_DATABASE_SUBNET_GROUP" {
  description = <<EOT
    This is the name of the RDS Subnet group. You can check the RDS subnet
    groups by going to RDS and then to Subnet "groups".

    The subnet group has to be associated with the VPC defined in "DAGSTER_DATABASE_SG_VPC".
    If no subnet group is specified, terraform will use the default subnet group, but, if
    the value defined in the "DAGSTER_DATABASE_SG_VPC" variable is not the default VPC, you
    will get an error.
  EOT
  type        = string
  default     = "dbt-studygroup-dvdrental-subnet-group"
}

variable "DAGSTER_DATABASE_SG_NAME" {
  description = "The name of the dagster db security group"
  type        = string
  default     = "Dagster Database SG"
}

variable "DAGSTER_SERVICES_SG_NAME" {
  description = "The name of the dagster services security group"
  type        = string
  default     = "Dagster Services SG"
}

variable "DAGSTER_WEBSERVER_ALB_SG_NAME" {
  description = "The name of the ALB security group"
  type        = string
  default     = "Dagster ALB SG"
}

# --------------------------------------------------------------------------------------------------------
# ECR Variables
# --------------------------------------------------------------------------------------------------------

variable "DAGSTER_CODE_LOCATION_ECR_REPO_NAME" {
  description = "The name of the code location ECR repository"
  type        = string
  default     = "dagster-code-location"
}

variable "DAGSTER_WEB_SERVER_ECR_REPO_NAME" {
  description = "The name of the web server ECR repository"
  type        = string
  default     = "dagster-web-server"
}

variable "DAGSTER_DAEMON_ECR_REPO_NAME" {
  description = "The name of the daemon ECR repository"
  type        = string
  default     = "dagster-daemon"
}

# --------------------------------------------------------------------------------------------------------
# S3 Variables
# --------------------------------------------------------------------------------------------------------

variable "BUCKET_NAME" {
  description = "The name of the Bucket"
  type        = string
  default     = "dagster-code-locations-bucket"
}

# --------------------------------------------------------------------------------------------------------
# RDS Variables
# --------------------------------------------------------------------------------------------------------

variable "ENGINE" {
  description = "The db engine"
  type        = string
  default     = "postgres"
}

variable "ENGINE_VERSION" {
  description = "The db engine version"
  type        = string
  default     = "15.5"
}

variable "DB_INSTANCE_CLASS" {
  description = "The instance class for the database"
  type        = string
  default     = "db.t3.micro"
}

variable "DB_IDENTIFIER" {
  description = "The cluster identifier"
  type        = string
  default     = "dagsterdb-cluster"
}

variable "DB_NAME" {
  description = "The name of the database"
  type        = string
  default     = "dagsterdb"
}

variable "DB_USERNAME" {
  description = "The master username for the database"
  type        = string
  default     = "postgres"
}

variable "DB_PASSWORD" {
  description = "The master password for the database (use secret management in production)"
  default     = "YourMasterPassword123!"
}

variable "BACKUP_RETENTION_PERIOD" {
  description = "The retention period for backups in days"
  default     = 7
}

# --------------------------------------------------------------------------------------------------------
# EFS Variables
# --------------------------------------------------------------------------------------------------------

variable "EFS_NAME" {
  description = "The name of the EFS"
  type        = string
  default     = "dagster-code-location-volume-efs"
}

variable "ACCESS_NAME" {
  description = "The name of the access point"
  type        = string
  default     = "code-location-access-pointtf1"
}

# --------------------------------------------------------------------------------------------------------
# IAM Variables
# --------------------------------------------------------------------------------------------------------

variable "DATASYNC_ROLE_NAME" {
  description = "The name of the datasync role"
  type        = string
  default     = "dagster-datasync-task-role"
}

variable "DATASYNC_POLICY_NAME" {
  description = "The name of the datasync policy"
  type        = string
  default     = "dagster-datasync-task-policy"
}

variable "ECS_ROLE_NAME" {
  description = "The name of the ECS role"
  type        = string
  default     = "dagster-ecs-role"
}

variable "ECS_POLICY_NAME" {
  description = "The name of the ECS policy"
  type        = string
  default     = "dagster-ecs-policy"
}

# --------------------------------------------------------------------------------------------------------
# DataSync Variables
# --------------------------------------------------------------------------------------------------------

variable "DATASYNC_TASK_NAME" {
  description = "The name of the DataSync task"
  type        = string
  default     = "dagster_datasync_task_code_location"
}

# --------------------------------------------------------------------------------------------------------
# ECS Variables
# --------------------------------------------------------------------------------------------------------

# General Variables
variable "ECS_CLUSTER_NAME" {
  description = "The name of the ECS cluster"
  type        = string
  default     = "dagster-cluster"
}

variable "NAMESPACE_NAME" {
  description = "The name of Namespace"
  type        = string
  default     = "dagster-services-namespace"
}

variable "CODE_LOCATION_TASK_FAMILY_NAME" {
  description = "The name of the code location task family"
  type        = string
  default     = "dagster-code-location-task-definition"
}

variable "CODE_LOCATION_CONTAINER_NAME" {
  description = "The name of the code location container"
  type        = string
  default     = "dagster-code-location"
}

variable "CODE_LOCATION_MODULE_PATH" {
  description = "The name or path of the module that will be used to start the code location server."
  type        = string
  default     = "dagster_university"
}

variable "CODE_LOCATION_VOLUME_NAME" {
  description = "The name of the volume that will be created for the code location container."
  type        = string
  default     = "dagster-efs-volume"
}

variable "EFS_CODE_LOCATION_VOLUME_PATH" {
  description = "The path in the EFS that will be attached to the container."
  type        = string
  default     = "/dagster-code-location"
}

# Dagster Runs variables
variable "DAGSTER_RUNS_TASK_FAMILY_NAME" {
  description = "The name of the Dagster runs task family"
  type        = string
  default     = "dagster-runs-task-definition"
}

variable "DAGSTER_RUNS_CONTAINER_NAME" {
  description = "The name of the dagster runs container"
  type        = string
  default     = "dagster-run"
}

variable "DAEMON_TASK_FAMILY_NAME" {
  description = "The name of the Daemon task family"
  type        = string
  default     = "dagster-daemon-task-definition"
}

variable "DAEMON_CONTAINER_NAME" {
  description = "The name of the Daemon container"
  type        = string
  default     = "dagster-daemon"
}

variable "WEBSERVER_TASK_FAMILY_NAME" {
  description = "The name of the Web Server task family"
  type        = string
  default     = "dagster-webserver-task-definition"
}

variable "WEBSERVER_CONTAINER_NAME" {
  description = "The name of the Daemon container"
  type        = string
  default     = "dagster-webserver"
}

# ALB Variables
variable "ALB_TARGET_GROUP_NAME" {
  description = "The name of target group for the ALB"
  type        = string
  default     = "dagster-webserver-alb-TG"
}

variable "WEBSERVER_ALB_NAME" {
  description = "The name of the WebServer ALB"
  type        = string
  default     = "dagster-webserver-alb"
}


# --------------------------------------------------------------------------------------------------------
# StepFunction StateMachine Variables
# --------------------------------------------------------------------------------------------------------

variable "DATASYNC_STATE_MACHINE_NAME" {
  description = "The name of the datasync state machine"
  type        = string
  default     = "dagster_datasync_state_machine"
}

variable "DATASYNC_STATE_MACHINE_EXECUTION_ROLE_NAME" {
  description = "The name of the datasync state machine execution role"
  type        = string
  default     = "dagster_datasync_state_machine_role"
}

variable "CLOUDWATCH_S3_OBJECT_CREATED_RULE_NAME" {
  description = "The name of the S3 object created rule for cloudwatch"
  type        = string
  default     = "dagster_cloudwatch_s3_object_created_rule"
}

variable "DATASYNC_EVENTBRIDGE_TARGET_EXECUTION_ROLE_NAME" {
  description = "The name of the EventBridge Target Execution Role name"
  type        = string
  default     = "dagster_datasync_eventbridge_target_execution_role"
}

variable "STEP_FUNCTION_EXECUTION_POLICY_NAME" {
  description = "The name of the Step Function Execution Policy name"
  type        = string
  default     = "dagster_datasync_step_function_execution_policy"
}

variable "EVENTBRIDGE_TARGET_EXECUTION_POLICY_NAME" {
  description = "The name of the EventBridge Target Execution Policy Name"
  type        = string
  default     = "dagster_datasync_eventbridge_target_execution_policy"
}