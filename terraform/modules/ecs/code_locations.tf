# --------------------------------------------------------------------------------------------------------
# Code Locations Runs Taks Definitions
# --------------------------------------------------------------------------------------------------------
resource "aws_ecs_task_definition" "runs_task_definitions" {
  for_each                = var.CODE_LOCATIONS_DICT
  family                  = "${each.value.task_family_name}-runs"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = "1024"
  memory                  = "3072"
  task_role_arn           = var.TASK_ROLE_ARN
  execution_role_arn      = var.TASK_EXECUTION_ROLE_ARN

  runtime_platform {
    cpu_architecture       = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name       = "${each.value.container_name}-runs"
      image      = "${each.value.accountnumber}.dkr.ecr.${each.value.region}.amazonaws.com/${each.value.repo_name}"
      cpu        = 0
      essential  = true
      entryPoint = ["dagster", "code-server", "start", "-h", "0.0.0.0", "-p", "4000", "-m", "${each.value.module_path}"]
      environment = [
        {
          name  = "DAGSTER_POSTGRES_USER"
          value = var.DATABASE_USERNAME
        },
        {
          name  = "DAGSTER_CURRENT_IMAGE"
          value = "${each.value.accountnumber}.dkr.ecr.${each.value.region}.amazonaws.com/${each.value.repo_name}"
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
          containerPort = 4000
          hostPort      = 4000
          protocol      = "tcp"
          appProtocol   = "grpc"
          name          = "${each.value.container_name}"
        }
      ]

      mountPoints = [
        {
          sourceVolume  = "${each.value.code_location_volume_name}"
          containerPath = "/opt/dagster/dagster_home"
          readOnly      = false
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"        = "/ecs/${each.value.task_family_name}"
          "awslogs-create-group" = "true"
          "awslogs-region"       = "${each.value.region}"
          "awslogs-stream-prefix" = "ecs"
          "mode"                 = "non-blocking"
          "max-buffer-size"      = "25m"
        }
      }
    }
  ])

  volume {
    name = "${each.value.code_location_volume_name}"

    efs_volume_configuration {
      file_system_id     = var.EFS_ID
      root_directory     = "${each.value.volume_path}"
      transit_encryption = "ENABLED"
    }
  }
}






# --------------------------------------------------------------------------------------------------------
# Code Locations Task Definitions
# --------------------------------------------------------------------------------------------------------
resource "aws_ecs_task_definition" "task_definitions" {
  for_each                = var.CODE_LOCATIONS_DICT
  family                  = "${each.value.task_family_name}"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = "1024"
  memory                  = "3072"
  task_role_arn           = var.TASK_ROLE_ARN
  execution_role_arn      = var.TASK_EXECUTION_ROLE_ARN

  runtime_platform {
    cpu_architecture       = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name       = "${each.value.container_name}"
      image      = "${each.value.accountnumber}.dkr.ecr.${each.value.region}.amazonaws.com/${each.value.repo_name}"
      cpu        = 0
      essential  = true
      entryPoint = ["dagster", "code-server", "start", "-h", "0.0.0.0", "-p", "4000", "-m", "${each.value.module_path}"]
      environment = [
        {
          name  = "DAGSTER_POSTGRES_USER"
          value = var.DATABASE_USERNAME
        },
        {
          name  = "DAGSTER_CONTAINER_CONTEXT"
          value = "{\"ecs\": {\"task_definition_arn\": \"arn:aws:ecs:${each.value.region}:${each.value.accountnumber}:task-definition/${each.value.task_family_name}-runs\", \"container_name\": \"${each.value.container_name}-runs\", \"volumes\": [{\"name\": \"${each.value.code_location_volume_name}\", \"efsVolumeConfiguration\": {\"fileSystemId\": \"${var.EFS_ID}\", \"rootDirectory\": \"/${each.value.volume_path}\"}}], \"mount_points\": [{\"sourceVolume\": \"${each.value.code_location_volume_name}\", \"containerPath\": \"/opt/dagster/dagster_home\"}]}}"
        },
        {
          name  = "DAGSTER_CURRENT_IMAGE"
          value = "${each.value.accountnumber}.dkr.ecr.${each.value.region}.amazonaws.com/${each.value.repo_name}"
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
          containerPort = 4000
          hostPort      = 4000
          protocol      = "tcp"
          appProtocol   = "grpc"
          name          = "${each.value.container_name}"
        }
      ]

      mountPoints = [
        {
          sourceVolume  = "${each.value.code_location_volume_name}"
          containerPath = "/opt/dagster/dagster_home"
          readOnly      = false
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"        = "/ecs/${each.value.task_family_name}"
          "awslogs-create-group" = "true"
          "awslogs-region"       = "${each.value.region}"
          "awslogs-stream-prefix" = "ecs"
          "mode"                 = "non-blocking"
          "max-buffer-size"      = "25m"
        }
      }
    }
  ]
  )

  volume {
    name = "${each.value.code_location_volume_name}"

    efs_volume_configuration {
      file_system_id     = var.EFS_ID
      root_directory     = "${each.value.volume_path}"
      transit_encryption = "ENABLED"
    }
  }
  depends_on = [aws_ecs_task_definition.runs_task_definitions]
}


# --------------------------------------------------------------------------------------------------------
# Code Locations ECS Containers (Services)
# --------------------------------------------------------------------------------------------------------
# Code location service
resource "aws_ecs_service" "code_location" {
  
  for_each         = var.CODE_LOCATIONS_DICT
  # Compute configuration
  cluster          = aws_ecs_cluster.dagster_cluster.id
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  # Deployment configuration
  name             = "${each.value.container_name}"
  task_definition  = "arn:aws:ecs:${each.value.region}:${each.value.accountnumber}:task-definition/${each.value.task_family_name}"
  desired_count    = 1
  depends_on       = [aws_ecs_cluster.dagster_cluster, aws_ecs_task_definition.task_definitions]

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
      discovery_name = "${each.value.container_name}"
      port_name      = "${each.value.container_name}"
      client_alias {
        dns_name = "${each.value.container_name}"
        port     = 4000
      }
    }
  }
}