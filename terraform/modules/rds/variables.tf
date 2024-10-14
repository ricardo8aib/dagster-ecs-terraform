# Variables
variable "REGION" {
  description = "The region of the project"
  type        = string
}

variable "ENGINE" {
  description = "The db engine"
  type        = string
}

variable "ENGINE_VERSION" {
  description = "The db engine version"
  type        = string
}

variable "DB_INSTANCE_CLASS" {
  description = "The instance class for the database"
  type        = string
}

variable "DB_IDENTIFIER" {
  description = "The cluster identifier"
  type        = string
}

variable "DB_NAME" {
  description = "The name of the database"
  type        = string
}

variable "DB_USERNAME" {
  description = "The master username for the database"
  type        = string
}

variable "DB_PASSWORD" {
  description = "The master password for the database (use secret management in production)"
  type        = string
}

variable "BACKUP_RETENTION_PERIOD" {
  description = "The retention period for backups in days"
  type        = number
}

variable "DAGSTER_DATABASE_SG_ID" {
  description = "Security group ID for Dagster Database"
  type        = string
}

variable "DAGSTER_DATABASE_SUBNET_GROUP" {
  description = "The subnet group for the RDS db"
  type        = string
}


