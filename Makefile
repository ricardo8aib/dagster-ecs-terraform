# --------------------------------------------------------------------------------------------------------
# Custom Variables
# --------------------------------------------------------------------------------------------------------

# AWS Configuration (these can be customized)
AWS_ACCOUNT_ID := 668221262652
AWS_REGION := us-east-1

# Docker repository names (customizable)
CODE_LOCATION_REPO_NAME := dagster-code-location
WEBSERVER_REPO_NAME := dagster-web-server
DAEMON_REPO_NAME := dagster-daemon

# Terraform variables
TERRAFORM_DIR := terraform
MODULES := IAM networking ecr rds s3 efs datasync stepfunction

# --------------------------------------------------------------------------------------------------------
# Actual Make commands
# --------------------------------------------------------------------------------------------------------

# AWS Registry and URIs
AWS_REGISTRY := $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com
CODE_LOCATION_REPO_URI := $(AWS_REGISTRY)/$(CODE_LOCATION_REPO_NAME)
WEBSERVER_REPO_URI := $(AWS_REGISTRY)/$(WEBSERVER_REPO_NAME)
DAEMON_REPO_URI := $(AWS_REGISTRY)/$(DAEMON_REPO_NAME)

# Docker tags
CODE_LOCATION_REPO_TAG := $(notdir $(CODE_LOCATION_REPO_URI))
WEBSERVER_REPO_TAG := $(notdir $(WEBSERVER_REPO_URI))
DAEMON_REPO_TAG := $(notdir $(DAEMON_REPO_URI))

# Default target when running 'make'
all: terraform_apply build_and_push

# Navigate to the Terraform folder and initialize
terraform_init:
	cd $(TERRAFORM_DIR) && terraform init

# Apply Terraform modules
terraform_apply: terraform_init
	@for module in $(MODULES); do \
		echo "Applying Terraform configuration for module: $$module"; \
		cd $(TERRAFORM_DIR) && terraform apply -target=module.$$module -auto-approve && cd ..; \
	done
	@echo "Terraform apply completed for all modules except ecs."

# Build and push Docker images
build_and_push: docker_login docker_build_and_tag docker_push

# Login to AWS ECR
docker_login:
	@echo "Retrieving authentication token..."
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(AWS_REGISTRY)
	@echo "Authentication token retrieved 🤖"

# Build and tag Docker images
docker_build_and_tag: build_code_location build_webserver build_daemon

build_code_location:
	@echo "Building the Code Location image..."
	docker build --platform linux/amd64 -t $(CODE_LOCATION_REPO_TAG) --target user_code -f dagster/Dockerfile dagster
	@echo "Code Location Docker image built 📄"
	@echo "Tagging Code Location image..."
	docker tag $(CODE_LOCATION_REPO_TAG):latest $(CODE_LOCATION_REPO_URI):latest

build_webserver:
	@echo "Building the Web Server image..."
	docker build --platform linux/amd64 -t $(WEBSERVER_REPO_TAG) --target webserver -f dagster/Dockerfile dagster
	@echo "Web Server Docker image built 💻"
	@echo "Tagging Web Server image..."
	docker tag $(WEBSERVER_REPO_TAG):latest $(WEBSERVER_REPO_URI):latest

build_daemon:
	@echo "Building the Daemon image..."
	docker build --platform linux/amd64 -t $(DAEMON_REPO_TAG) --target dagster -f dagster/Dockerfile dagster
	@echo "Daemon Docker image built 🛠️"
	@echo "Tagging Daemon image..."
	docker tag $(DAEMON_REPO_TAG):latest $(DAEMON_REPO_URI):latest

# Push Docker images to ECR
docker_push:
	@echo "Pushing Docker images..."
	docker push $(CODE_LOCATION_REPO_URI):latest
	@echo "Code Location image pushed"
	docker push $(WEBSERVER_REPO_URI):latest
	@echo "WebServer image pushed"
	docker push $(DAEMON_REPO_URI):latest
	@echo "Daemon image pushed"
	@echo "Images pushed 🤩"

# Deploy ECS services using Terraform
deploy_services:
	@echo "Applying Terraform configuration for the ecs module..."
	cd $(TERRAFORM_DIR) && terraform apply -target=module.ecs -auto-approve
	@echo "Terraform apply completed for the ecs module."

# Destroy ECS services using Terraform
destroy_services:
	@echo "Destroying Terraform configuration for the ecs module..."
	cd $(TERRAFORM_DIR) && terraform destroy -target=module.ecs -auto-approve
	@echo "Terraform destroy completed for the ecs module."


# Destroy all Terraform-managed infrastructure
terraform_destroy:
	@echo "Destroying all Terraform-managed infrastructure..."
	cd $(TERRAFORM_DIR) && terraform destroy -auto-approve
	@echo "Terraform destroy completed."

# Phony targets
.PHONY: all terraform_init terraform_apply build_and_push docker_login docker_build_and_tag docker_push build_code_location build_webserver build_daemon
