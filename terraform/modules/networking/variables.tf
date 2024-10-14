variable "DAGSTER_DATABASE_SG_NAME" {
  description = "The name of the dagster db security group"
  type        = string
}

variable "DAGSTER_DATABASE_SG_VPC" {
  description = "The VPC where the database is"
  type        = string
}

variable "DAGSTER_SERVICES_SG_NAME" {
  description = "The name of the dagster services security group"
  type        = string
}

variable "DAGSTER_WEBSERVER_ALB_SG_NAME" {
  description = "The name of the ALB security group"
  type        = string
}