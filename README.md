# Infrastructure Management with Terraform and Docker

This project uses Terraform for infrastructure management and Docker for building and deploying containerized applications. The following instructions outline the key commands to manage the infrastructure.

## Prerequisites

Before running the commands, ensure you have the following installed:

- [Terraform](https://www.terraform.io/downloads.html)
- [Docker](https://docs.docker.com/get-docker/)
- [AWS CLI](https://aws.amazon.com/cli/)

Make sure to configure your AWS CLI with the appropriate credentials:

```bash
aws configure
```

## Key Commands

### 1. Initialize Terraform

To initialize the Terraform working directory, run:

```bash
make terraform_init
```

### 2. Apply Terraform Configuration

To apply the Terraform configurations for all modules (excluding ECS), run:

```bash
make terraform_apply
```

### 3. Build and Push Docker Images

To build and push the Docker images to AWS ECR, run:

```bash
make build_and_push
```

### 4. Deploy ECS Services

To deploy the ECS services using Terraform, run:

```bash
make deploy_services
```

### 5. Destroy All Infrastructure

To destroy all resources managed by Terraform, run:

```bash
make terraform_destroy
```

## Customization

You can customize the AWS account ID, region, and repository names in the `Makefile`:

- **AWS_ACCOUNT_ID**: Your AWS account number.
- **AWS_REGION**: The AWS region where your resources are deployed.
- **CODE_LOCATION_REPO_NAME, WEBSERVER_REPO_NAME, DAEMON_REPO_NAME**: Names of your Docker repositories.
