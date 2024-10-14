# Daemon task definition
resource "aws_ecs_task_definition" "daemon_task_definition" {
  family                   = var.DAEMON_TASK_FAMILY_NAME
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
      name             = var.DAEMON_CONTAINER_NAME
      image            = var.DAEMON_IMAGE
      cpu              = 0
      portMappings     = []
      essential        = true
      entryPoint       = ["dagster-daemon", "run"]
      environment      = [
        {
          name  = "DAGSTER_POSTGRES_USER"
          value = var.DATABASE_USERNAME
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
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/dagster-daemon"
          "awslogs-create-group"  = "true"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
          "mode"                  = "non-blocking"
          "max-buffer-size"       = "25m"
        }
      }

      systemControls = []
    }
  ])
}


# Daemon service
resource "aws_ecs_service" "daemon" {

  # Compute configuration
  cluster          = aws_ecs_cluster.dagster_cluster.id
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  # Deployment configuration
  name             = var.DAEMON_CONTAINER_NAME
  task_definition  = aws_ecs_task_definition.daemon_task_definition.arn
  desired_count    = 1
  depends_on       = [aws_ecs_cluster.dagster_cluster, aws_ecs_service.code_location]

  # Network configuration
  network_configuration {
    subnets = var.SUBNET_IDS_FOR_DAGSTER_DAEMON
    security_groups = [var.DAGSTER_SERVICES_SG]
    assign_public_ip = true
  }

  # Service Connect
  service_connect_configuration {
    enabled   = true
    namespace = aws_service_discovery_private_dns_namespace.dagster_services_namespace.arn
  }

}

