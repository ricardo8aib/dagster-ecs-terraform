AWS_ACCOUNT_ID = "668221262652"
AWS_REGION = "us-east-1"
TERRAFORM_DIR = "terraform"
MODULES = ["IAM", "networking", "ecr", "rds", "s3", "efs", "datasync", "stepfunction"]

SERVICES: dict = {
    "daemon": {
        "repo_name": "dagster-daemon",
        "docker_target": "dagster"
    },
    "webserver": {
        "repo_name": "dagster-web-server",
        "docker_target": "webserver"
    },
    "backend-dev": {
        "repo_name": "dagster-backend-dev",
        "docker_target": "backend_dev"
    },
    "marketing-dev": {
        "repo_name": "dagster-marketing-dev",
        "docker_target": "marketing_dev"
    },
    "finance-dev": {
        "repo_name": "dagster-finance-dev",
        "docker_target": "finance_dev"
    },
    "fraud-dev": {
        "repo_name": "dagster-fraud-dev",
        "docker_target": "fraud_dev"
    },
    "servicing-dev": {
        "repo_name": "dagster-servicing-dev",
        "docker_target": "servicing_dev"
    },
}
