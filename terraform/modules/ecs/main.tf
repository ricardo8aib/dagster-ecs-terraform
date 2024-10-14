# ECS Cluster
resource "aws_ecs_cluster" "dagster_cluster" {
  name = var.ECS_CLUSTER_NAME
}

# Namespace
resource "aws_service_discovery_private_dns_namespace" "dagster_services_namespace" {
  name        = var.NAMESPACE_NAME
  vpc         = var.VPC_ID
  description = "Namespace for Dagster Services"
}


