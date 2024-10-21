# --------------------------------------------------------------------------------------------------------
# Custom Variables
# --------------------------------------------------------------------------------------------------------

# AWS Configuration (these can be customized)
AWS_ACCOUNT_ID := 668221262652
AWS_REGION := us-east-1

# Docker repository names (customizable)
BACKEND_DEV_REPO_NAME := dagster-backend-dev
MARKETING_DEV_REPO_NAME := dagster-marketing-dev
FINANCE_DEV_REPO_NAME := dagster-finance-dev
FRAUD_DEV_REPO_NAME := dagster-fraud-dev
SERVICING_DEV_REPO_NAME := dagster-servicing-dev
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

BACKEND_DEV_REPO_URI := $(AWS_REGISTRY)/$(BACKEND_DEV_REPO_NAME)
MARKETING_DEV_REPO_URI := $(AWS_REGISTRY)/$(MARKETING_DEV_REPO_NAME)
FINANCE_DEV_REPO_URI := $(AWS_REGISTRY)/$(FINANCE_DEV_REPO_NAME)
FRAUD_DEV_REPO_URI := $(AWS_REGISTRY)/$(FRAUD_DEV_REPO_NAME)
SERVICING_DEV_REPO_URI := $(AWS_REGISTRY)/$(SERVICING_DEV_REPO_NAME)

WEBSERVER_REPO_URI := $(AWS_REGISTRY)/$(WEBSERVER_REPO_NAME)
DAEMON_REPO_URI := $(AWS_REGISTRY)/$(DAEMON_REPO_NAME)

# Docker tags
BACKEND_DEV_REPO_TAG := $(notdir $(BACKEND_DEV_REPO_URI))
MARKETING_DEV_REPO_TAG := $(notdir $(MARKETING_DEV_REPO_URI))
FINANCE_DEV_REPO_TAG := $(notdir $(FINANCE_DEV_REPO_URI))
FRAUD_DEV_REPO_TAG := $(notdir $(FRAUD_DEV_REPO_URI))
SERVICING_DEV_REPO_TAG := $(notdir $(SERVICING_DEV_REPO_URI))

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
	@echo "     "
	@echo "-------------------------------✅"

# Build and tag Docker images
docker_build_and_tag: build_backend_dev build_marketing_dev build_finance_dev build_fraud_dev build_servicing_dev build_webserver build_daemon

build_backend_dev:
	@echo "Building the Backend image..."
	docker build --platform linux/amd64 -t $(BACKEND_DEV_REPO_TAG) --target backend_dev -f dagster/Dockerfile dagster
	@echo "Code Location Docker image built 📄"
	@echo "Tagging Code Location image..."
	docker tag $(BACKEND_DEV_REPO_TAG):latest $(BACKEND_DEV_REPO_URI):latest
	@echo "     "
	@echo "-------------------------------✅"

build_marketing_dev:
	@echo "Building the Marketing image..."
	docker build --platform linux/amd64 -t $(MARKETING_DEV_REPO_TAG) --target marketing_dev -f dagster/Dockerfile dagster
	@echo "Code Location Docker image built 📄"
	@echo "Tagging Code Location image..."
	docker tag $(MARKETING_DEV_REPO_TAG):latest $(MARKETING_DEV_REPO_URI):latest
	@echo "     "
	@echo "-------------------------------✅"

build_finance_dev:
	@echo "Building the Finance image..."
	docker build --platform linux/amd64 -t $(FINANCE_DEV_REPO_TAG) --target finance_dev -f dagster/Dockerfile dagster
	@echo "Code Location Docker image built 📄"
	@echo "Tagging Code Location image..."
	docker tag $(FINANCE_DEV_REPO_TAG):latest $(FINANCE_DEV_REPO_URI):latest
	@echo "     "
	@echo "-------------------------------✅"

build_fraud_dev:
	@echo "Building the Fraud image..."
	docker build --platform linux/amd64 -t $(FRAUD_DEV_REPO_TAG) --target fraud_dev -f dagster/Dockerfile dagster
	@echo "Code Location Docker image built 📄"
	@echo "Tagging Code Location image..."
	docker tag $(FRAUD_DEV_REPO_TAG):latest $(FRAUD_DEV_REPO_URI):latest
	@echo "     "
	@echo "-------------------------------✅"

build_servicing_dev:
	@echo "Building the Servicing image..."
	docker build --platform linux/amd64 -t $(SERVICING_DEV_REPO_TAG) --target servicing_dev -f dagster/Dockerfile dagster
	@echo "Code Location Docker image built 📄"
	@echo "Tagging Code Location image..."
	docker tag $(SERVICING_DEV_REPO_TAG):latest $(SERVICING_DEV_REPO_URI):latest
	@echo "     "
	@echo "-------------------------------✅"


build_webserver:
	@echo "Building the Web Server image..."
	docker build --platform linux/amd64 -t $(WEBSERVER_REPO_TAG) --target webserver -f dagster/Dockerfile dagster
	@echo "Web Server Docker image built 💻"
	@echo "Tagging Web Server image..."
	docker tag $(WEBSERVER_REPO_TAG):latest $(WEBSERVER_REPO_URI):latest
	@echo "     "
	@echo "-------------------------------✅"

build_daemon:
	@echo "Building the Daemon image..."
	docker build --platform linux/amd64 -t $(DAEMON_REPO_TAG) --target dagster -f dagster/Dockerfile dagster
	@echo "Daemon Docker image built 🛠️"
	@echo "Tagging Daemon image..."
	docker tag $(DAEMON_REPO_TAG):latest $(DAEMON_REPO_URI):latest
	@echo "     "
	@echo "-------------------------------✅"

# Push Docker images to ECR
docker_push:
	@echo "Pushing Docker images..."
	docker push $(BACKEND_DEV_REPO_URI):latest
	docker push $(MARKETING_DEV_REPO_URI):latest
	docker push $(FINANCE_DEV_REPO_URI):latest
	docker push $(FRAUD_DEV_REPO_URI):latest
	docker push $(SERVICING_DEV_REPO_URI):latest
	@echo "Code Locations images pushed"
	docker push $(WEBSERVER_REPO_URI):latest
	@echo "WebServer image pushed"
	docker push $(DAEMON_REPO_URI):latest
	@echo "Daemon image pushed"
	@echo "Images pushed 🤩"
	@echo "     "
	@echo "-------------------------------✅"

# Deploy ECS services using Terraform
deploy_services:
	@echo "Applying Terraform configuration for the ecs module..."
	cd $(TERRAFORM_DIR) && terraform apply -target=module.ecs -auto-approve
	@echo "Terraform apply completed for the ecs module."
	@echo "     "
	@echo "-------------------------------✅"

# Destroy ECS services using Terraform
destroy_services:
	@echo "Destroying Terraform configuration for the ecs module..."
	cd $(TERRAFORM_DIR) && terraform destroy -target=module.ecs -auto-approve
	@echo "Terraform destroy completed for the ecs module."
	@echo "     "
	@echo "-------------------------------✅"


# Destroy all Terraform-managed infrastructure
terraform_destroy:
	@echo "Destroying all Terraform-managed infrastructure..."
	cd $(TERRAFORM_DIR) && terraform destroy -auto-approve
	@echo "Terraform destroy completed."

# Phony targets
.PHONY: all terraform_init terraform_apply build_and_push docker_login docker_build_and_tag docker_push build_code_location build_webserver build_daemon
