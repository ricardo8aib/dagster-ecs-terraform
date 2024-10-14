# Define the EFS File System for Dagster
resource "aws_efs_file_system" "dagster_efs" {
  creation_token = "dagster-efs-token"

  # Optional settings
  performance_mode = "generalPurpose"
  encrypted        = true
  # Tags
  tags = {
    Name = var.EFS_NAME
  }
}

# Define Mount Targets for EFS in each availability zone
resource "aws_efs_mount_target" "dagster_efs_mount_target" {
  for_each = toset(var.SUBNET_IDS)

  file_system_id = aws_efs_file_system.dagster_efs.id
  subnet_id      = each.value
  security_groups = [var.DAGSTER_SERVICES_SG_ID]
}

