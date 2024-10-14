# Define the security group for the Dagster Database
resource "aws_security_group" "dagster_database_sg" {
  name        = var.DAGSTER_DATABASE_SG_NAME
  description = "Security group for the Dagster database"
  vpc_id      = var.DAGSTER_DATABASE_SG_VPC

  # Allow all outbound traffic
  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.DAGSTER_DATABASE_SG_NAME
  }
}

# Define the security group for Dagster Services
resource "aws_security_group" "dagster_services_sg" {
  name        = var.DAGSTER_SERVICES_SG_NAME
  description = "Security group for the Dagster services"
  vpc_id      = var.DAGSTER_DATABASE_SG_VPC
  depends_on = [aws_security_group.dagster_database_sg]

  # Allow all outbound traffic
  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # Allow inbound traffic from the ALB security group
  ingress {
    description      = "Allow traffic from ALB"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    security_groups  = [aws_security_group.dagster_webserver_alb_sg.id]
  }

  # Allow inbound traffic from the Dagster database security group
  ingress {
    description = "Allow traffic from Dagster database"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.dagster_database_sg.id]
  }

  # Allow traffic from itself (self-referencing security group)
  ingress {
    description = "Allow traffic within Dagster services (SELF)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  tags = {
    Name = var.DAGSTER_SERVICES_SG_NAME
  }
}

# Define the security group for WebServer ALB
resource "aws_security_group" "dagster_webserver_alb_sg" {
  name        = var.DAGSTER_WEBSERVER_ALB_SG_NAME
  description = "Security group for the Dagster WebServer ALB"
  vpc_id      = var.DAGSTER_DATABASE_SG_VPC

  # Allow all outbound traffic
  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # Allow HTTP traffic from the internet
  ingress {
    description      = "Allow HTTP traffic from the internet"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # Allow HTTPS traffic from the internet
  ingress {
    description      = "Allow HTTPS traffic from the internet"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.DAGSTER_WEBSERVER_ALB_SG_NAME
  }
}

# Define specific ingress rules using aws_security_group_rule
resource "aws_security_group_rule" "dagster_to_db" {
  type                   = "ingress"
  from_port              = 5432
  to_port                = 5432
  protocol               = "tcp"
  security_group_id      = aws_security_group.dagster_database_sg.id
  source_security_group_id = aws_security_group.dagster_services_sg.id
}