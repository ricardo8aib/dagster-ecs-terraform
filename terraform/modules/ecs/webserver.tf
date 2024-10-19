# Web Server task definition
resource "aws_ecs_task_definition" "webserver_task_definition" {
  family                   = var.WEBSERVER_TASK_FAMILY_NAME
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
      name             = var.WEBSERVER_CONTAINER_NAME
      image            = var.WEBSERVER_IMAGE
      cpu              = 0
      portMappings     = [
        {
          containerPort = 3000  # Define the container port
          hostPort      = 3000   # Optional, generally can be set to 0 for dynamic allocation
          protocol      = "tcp"   # Specify the protocol
        }
      ]
      essential        = true
      entryPoint       = ["dagster-webserver", "-h", "0.0.0.0", "-p", "3000", "-w", "workspace.yaml"]
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
          "awslogs-group"         = "/ecs/dagster-webserver"
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


# Web Server service
resource "aws_ecs_service" "webserver" {

  # Compute configuration
  cluster          = aws_ecs_cluster.dagster_cluster.id
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  # Deployment configuration
  name             = var.WEBSERVER_CONTAINER_NAME
  task_definition  = aws_ecs_task_definition.webserver_task_definition.arn
  desired_count    = 1
  depends_on       = [aws_ecs_cluster.dagster_cluster]

  # Network configuration
  network_configuration {
    subnets = var.SUBNET_IDS_FOR_DAGSTER_WEBSERVER
    security_groups = [var.DAGSTER_SERVICES_SG]
    assign_public_ip = true
  }

  # Service Connect
  service_connect_configuration {
    enabled   = true
    namespace = aws_service_discovery_private_dns_namespace.dagster_services_namespace.arn
  }

  # Load Balancer
  load_balancer {
    target_group_arn = aws_lb_target_group.webserver_target_group.arn
    container_name   = var.WEBSERVER_CONTAINER_NAME
    container_port   = 3000
  }

}

