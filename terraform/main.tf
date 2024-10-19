module "ecr" {
  source                              = "./modules/ecr"
  CODE_LOCATIONS_DICT                 = var.CODE_LOCATIONS_DICT
  DAGSTER_DAEMON_ECR_REPO_NAME        = var.DAGSTER_DAEMON_ECR_REPO_NAME
  DAGSTER_WEB_SERVER_ECR_REPO_NAME    = var.DAGSTER_WEB_SERVER_ECR_REPO_NAME
}

module "networking" {
  source                        = "./modules/networking"
  DAGSTER_DATABASE_SG_VPC       = var.DAGSTER_DATABASE_SG_VPC
  DAGSTER_DATABASE_SG_NAME      = var.DAGSTER_DATABASE_SG_NAME
  DAGSTER_SERVICES_SG_NAME      = var.DAGSTER_SERVICES_SG_NAME
  DAGSTER_WEBSERVER_ALB_SG_NAME = var.DAGSTER_WEBSERVER_ALB_SG_NAME
}

module "s3" {
  source      = "./modules/s3"
  BUCKET_NAME = var.BUCKET_NAME
}

module "rds" {
  source                        = "./modules/rds"
  DAGSTER_DATABASE_SG_ID        = module.networking.security_group_ids["dagster_database_sg"]
  REGION                        = var.REGION
  ENGINE                        = var.ENGINE
  ENGINE_VERSION                = var.ENGINE_VERSION
  DB_INSTANCE_CLASS             = var.DB_INSTANCE_CLASS
  DB_IDENTIFIER                 = var.DB_IDENTIFIER
  DB_NAME                       = var.DB_NAME
  DB_USERNAME                   = var.DB_USERNAME
  DB_PASSWORD                   = var.DB_PASSWORD
  BACKUP_RETENTION_PERIOD       = var.BACKUP_RETENTION_PERIOD
  DAGSTER_DATABASE_SUBNET_GROUP = var.DAGSTER_DATABASE_SUBNET_GROUP
}

module "efs" {
  source                 = "./modules/efs"
  DAGSTER_SERVICES_SG_ID = module.networking.security_group_ids["dagster_services_sg"]
  SUBNET_IDS             = var.SUBNET_IDS_FOR_EFS
  ACCESS_NAME            = var.ACCESS_NAME
  EFS_NAME               = var.EFS_NAME
}

module "IAM" {
  source                   = "./modules/IAM"
  ECS_ROLE_NAME            = var.ECS_ROLE_NAME
  ECS_POLICY_NAME          = var.ECS_POLICY_NAME
  DATASYNC_POLICY_NAME     = var.DATASYNC_POLICY_NAME
  DATASYNC_ROLE_NAME       = var.DATASYNC_ROLE_NAME
  CODE_LOCATION_BUCKET_ARN = module.s3.code_location_bucket_arn["code_location_bucket_arn"]
  EFS_ARN                  = module.efs.efs["efs_arn"]
}

module "datasync" {
  source                    = "./modules/datasync"
  DATASYNC_TASK_ROLE_ARN    = module.IAM.datasync_role["datasync_role_arn"]
  CODE_LOCATION_BUCKET_ARN  = module.s3.code_location_bucket_arn["code_location_bucket_arn"]
  EFS_ARN                   = module.efs.efs["efs_arn"]
  DAGSTER_SERVICES_SG_ARN   = module.networking.security_group_ids["dagster_services_sg_arn"]
  SUBNET_ARN                = var.SUBNET_ARN_FOR_DATASYNC_TASK
  DATASYNC_TASK_NAME        = var.DATASYNC_TASK_NAME
  CODE_LOCATION_BUCKET_NAME = var.BUCKET_NAME
}

module "ecs" {
  source = "./modules/ecs"

  # General Variables
  DATABASE_HOST           = module.rds.db_instance["db_instance_endpoint"]
  DATABASE_NAME           = module.rds.db_instance["db_name"]
  DATABASE_USERNAME       = module.rds.db_instance["db_username"]
  DATABASE_PASSWORD       = module.rds.db_instance["db_password"]
  TASK_ROLE_ARN           = module.IAM.ecs_role["ecs_role_arn"]
  TASK_EXECUTION_ROLE_ARN = module.IAM.ecs_role["ecs_role_arn"]
  EFS_ID                  = module.efs.efs["efs_id"]
  VPC_ID                  = var.DAGSTER_DATABASE_SG_VPC
  DAGSTER_SERVICES_SG     = module.networking.security_group_ids["dagster_services_sg"]
  ECS_CLUSTER_NAME        = var.ECS_CLUSTER_NAME
  NAMESPACE_NAME          = var.NAMESPACE_NAME

  # Code Location Variables
  CODE_LOCATIONS_DICT                  = var.CODE_LOCATIONS_DICT
  SUBNET_IDS_FOR_DAGSTER_CODE_LOCATION = var.SUBNET_IDS_FOR_DAGSTER_CODE_LOCATION

  # Daemon Variables
  DAEMON_TASK_FAMILY_NAME       = var.DAEMON_TASK_FAMILY_NAME
  DAEMON_CONTAINER_NAME         = var.DAEMON_CONTAINER_NAME
  DAEMON_IMAGE                  = module.ecr.dagster_ecr_urls["dagster_daemon"]
  SUBNET_IDS_FOR_DAGSTER_DAEMON = var.SUBNET_IDS_FOR_DAGSTER_DAEMON

  # WebServer Variables
  WEBSERVER_TASK_FAMILY_NAME       = var.WEBSERVER_TASK_FAMILY_NAME
  WEBSERVER_CONTAINER_NAME         = var.WEBSERVER_CONTAINER_NAME
  WEBSERVER_IMAGE                  = module.ecr.dagster_ecr_urls["dagster_web_server"]
  SUBNET_IDS_FOR_DAGSTER_WEBSERVER = var.SUBNET_IDS_FOR_DAGSTER_WEBSERVER

  # ALB Variables
  ALB_TARGET_GROUP_NAME = var.ALB_TARGET_GROUP_NAME
  ALB_SECURITY_GROUP    = module.networking.security_group_ids["webserver_alb_sg"]
  SUBNET_IDS_FOR_ALB    = var.SUBNET_IDS_FOR_ALB
  WEBSERVER_ALB_NAME    = var.WEBSERVER_ALB_NAME
}

module "stepfunction" {
  source                                          = "./modules/stepfunction"
  DATASYNC_STATE_MACHINE_NAME                     = var.DATASYNC_STATE_MACHINE_NAME
  DATASYNC_STATE_MACHINE_EXECUTION_ROLE_NAME      = var.DATASYNC_STATE_MACHINE_EXECUTION_ROLE_NAME
  DATASYNC_TASK_ARN                               = module.datasync.datasync_task["datasync_task_arn"]
  CLOUDWATCH_S3_OBJECT_CREATED_RULE_NAME          = var.CLOUDWATCH_S3_OBJECT_CREATED_RULE_NAME
  BUCKET_NAME                                     = var.BUCKET_NAME
  DATASYNC_EVENTBRIDGE_TARGET_EXECUTION_ROLE_NAME = var.DATASYNC_EVENTBRIDGE_TARGET_EXECUTION_ROLE_NAME
  STEP_FUNCTION_EXECUTION_POLICY_NAME             = var.STEP_FUNCTION_EXECUTION_POLICY_NAME
  EVENTBRIDGE_TARGET_EXECUTION_POLICY_NAME        = var.EVENTBRIDGE_TARGET_EXECUTION_POLICY_NAME
}