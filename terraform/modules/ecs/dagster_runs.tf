# Dagster runs task definition
resource "aws_ecs_task_definition" "dagster_runs_task_definition" {
  family                   = var.DAGSTER_RUNS_TASK_FAMILY_NAME
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "3072"
  task_role_arn            = var.TASK_ROLE_ARN
  execution_role_arn       = var.TASK_EXECUTION_ROLE_ARN

  runtime_platform {
    cpu_architecture       = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name             = var.DAGSTER_RUNS_CONTAINER_NAME
      image            = var.CODE_LOCATION_IMAGE
      cpu              = 0
      essential        = true
      environment      = [
        {
          name  = "DAGSTER_POSTGRES_USER"
          value = var.DATABASE_USERNAME
        },
        {
          name  = "DAGSTER_CURRENT_IMAGE"
          value = var.CODE_LOCATION_IMAGE
        },
        {
          name  = "DAGSTER_POSTGRES_DB"
          value = var.DATABASE_NAME
        },
        {
          name  = "DAGSTER_POSTGRES_HOSTNAME"
          value = var.DATABASE_HOST
        },
        {
          name  = "DAGSTER_POSTGRES_PASSWORD"
          value = var.DATABASE_PASSWORD
        }
      ]

      portMappings = [
        {
          name          = var.DAGSTER_RUNS_CONTAINER_NAME
          containerPort = 4000
          hostPort      = 4000
          protocol      = "tcp"
          appProtocol   = "grpc"
        }
      ]

      mountPoints = [
        {
          sourceVolume  = "dagster-efs-volume"
          containerPath = "/opt/dagster/dagster_home"
          readOnly      = false
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"        = "/ecs/dagster-code-location-task-definition"
          "awslogs-create-group" = "true"
          "awslogs-region"       = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
          "mode"                 = "non-blocking"
          "max-buffer-size"      = "25m"
        }
      }

      systemControls = []
    }
  ])

  volume {
    name = "dagster-efs-volume"

    efs_volume_configuration {
      file_system_id     = var.EFS_ID
      root_directory     = "/dagster-code-location"
      transit_encryption = "ENABLED"
    }
  }
}
