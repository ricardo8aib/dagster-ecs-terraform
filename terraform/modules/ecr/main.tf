resource "aws_ecr_repository" "dagster_code_location_repository" {
  name                 = var.DAGSTER_CODE_LOCATION_ECR_REPO_NAME
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "dagster_web_server_repository" {
  name                 = var.DAGSTER_WEB_SERVER_ECR_REPO_NAME
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "dagster_daemon_repository" {
  name                 = var.DAGSTER_DAEMON_ECR_REPO_NAME
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}