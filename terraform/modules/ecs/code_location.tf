# Code location task definition
resource "aws_ecs_task_definition" "code_location_task_definition" {
  family                   = var.CODE_LOCATION_TASK_FAMILY_NAME
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
      name             = var.CODE_LOCATION_CONTAINER_NAME
      image            = var.CODE_LOCATION_IMAGE
      cpu              = 0
      essential        = true
      entryPoint       = ["dagster", "code-server", "start", "-h", "0.0.0.0", "-p", "4000", "-m", "${var.CODE_LOCATION_MODULE_PATH}"]
      environment      = [
        {
          name  = "DAGSTER_POSTGRES_USER"
          value = var.DATABASE_USERNAME
        },
        {
          name  = "DAGSTER_CONTAINER_CONTEXT"
          value = "{\"ecs\": {\"task_definition_arn\": \"${aws_ecs_task_definition.dagster_runs_task_definition.arn}\", \"container_name\": \"${var.DAGSTER_RUNS_CONTAINER_NAME}\", \"volumes\": [{\"name\": \"dagster-efs-volume\", \"efsVolumeConfiguration\": {\"fileSystemId\": \"${var.EFS_ID}\", \"rootDirectory\": \"/dagster-code-location\"}}], \"mount_points\": [{\"sourceVolume\": \"dagster-efs-volume\", \"containerPath\": \"/opt/dagster/dagster_home\"}]}}"
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
          name          = var.CODE_LOCATION_CONTAINER_NAME
          containerPort = 4000
          hostPort      = 4000
          protocol      = "tcp"
          appProtocol   = "grpc"
        }
      ]

      mountPoints = [
        {
          sourceVolume  = var.CODE_LOCATION_VOLUME_NAME
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
    name = var.CODE_LOCATION_VOLUME_NAME

    efs_volume_configuration {
      file_system_id     = var.EFS_ID
      root_directory     = var.EFS_CODE_LOCATION_VOLUME_PATH
      transit_encryption = "ENABLED"
    }
  }
}


# Code location service
resource "aws_ecs_service" "code_location" {

  # Compute configuration
  cluster          = aws_ecs_cluster.dagster_cluster.id
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  # Deployment configuration
  name             = var.CODE_LOCATION_CONTAINER_NAME
  task_definition  = aws_ecs_task_definition.code_location_task_definition.arn
  desired_count    = 1
  depends_on       = [aws_ecs_cluster.dagster_cluster]

  # Network configuration
  network_configuration {
    subnets = var.SUBNET_IDS_FOR_DAGSTER_CODE_LOCATION
    security_groups = [var.DAGSTER_SERVICES_SG]
    assign_public_ip = true
  }

  # Service Connect
  service_connect_configuration {
    enabled   = true
    namespace = aws_service_discovery_private_dns_namespace.dagster_services_namespace.arn
    service {
      discovery_name = var.CODE_LOCATION_CONTAINER_NAME
      port_name      = var.CODE_LOCATION_CONTAINER_NAME
      client_alias {
        dns_name = var.CODE_LOCATION_CONTAINER_NAME
        port     = 4000
      }
    }
  }

}

