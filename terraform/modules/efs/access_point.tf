# Define the EFS Access Point
resource "aws_efs_access_point" "code_location_access_point" {
  file_system_id = aws_efs_file_system.dagster_efs.id

  # Access point name
  tags = {
    Name = var.ACCESS_NAME
  }

  # Root directory
  root_directory {
    path = "/"
  }

  # Ensure the access point is available
  lifecycle {
    create_before_destroy = true
  }
}
