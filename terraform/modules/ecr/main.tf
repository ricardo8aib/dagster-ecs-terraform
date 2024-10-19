# Create one ECR repository for each element in the CODE_LOCATIONS_DICT dictionary
resource "aws_ecr_repository" "dagster_code_location_repository" {
  for_each             = var.CODE_LOCATIONS_DICT
  name                 = each.value.repo_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Create an ECR repository for the WebServer
resource "aws_ecr_repository" "dagster_web_server_repository" {
  name                 = var.DAGSTER_WEB_SERVER_ECR_REPO_NAME
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Create an ECR repository for the Dagster Daemon
resource "aws_ecr_repository" "dagster_daemon_repository" {
  name                 = var.DAGSTER_DAEMON_ECR_REPO_NAME
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}