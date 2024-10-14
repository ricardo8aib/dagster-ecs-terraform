# DataSync S3 location (source)
resource "aws_datasync_location_s3" "s3_source" {
  s3_bucket_arn = var.CODE_LOCATION_BUCKET_ARN
  subdirectory = "/dagster-code-locations/"

  s3_config {
    bucket_access_role_arn = var.DATASYNC_TASK_ROLE_ARN   # This role is auto generated when creating this from the console
  }
}

# DataSync EFS location (destination)
resource "aws_datasync_location_efs" "efs_dest" {
  efs_file_system_arn = var.EFS_ARN

  ec2_config {
    security_group_arns = [var.DAGSTER_SERVICES_SG_ARN]  # When creating from the console it uses the default SG
    subnet_arn          = var.SUBNET_ARN  # When creating from the console it uses the default Subnet
  }
}

# DataSync Task
resource "aws_datasync_task" "s3_to_efs" {
  name                     = var.DATASYNC_TASK_NAME
  source_location_arn      = aws_datasync_location_s3.s3_source.arn
  destination_location_arn = aws_datasync_location_efs.efs_dest.arn

  options {
    verify_mode     = "POINT_IN_TIME_CONSISTENT"
    overwrite_mode  = "ALWAYS"
    atime           = "BEST_EFFORT"
    mtime           = "PRESERVE"
    preserve_deleted_files = "REMOVE"
  }
}

