# Variables
variable "DAGSTER_SERVICES_SG_ID" {
  description = "The ID of the security group for Dagster services"
  type        = string
}

variable "EFS_NAME" {
  description = "The name of the EFS"
  type        = string
}

variable "ACCESS_NAME" {
  description = "The name of the access point"
  type        = string
}

variable "SUBNET_IDS" {
  description = "List with subnet ids"
  type        = list
}