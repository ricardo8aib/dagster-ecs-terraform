import subprocess


class Deployer:
    """Class that helps deploying Dagster Services"""

    def __init__(
            self,
            SERVICES: dict,
            AWS_ACCOUNT_ID: str,
            AWS_REGION: str,
            TERRAFORM_DIR: str,
            MODULES: list,
    ) -> None:
        """Initialize the Deployer class.
        """
        AWS_REGISTRY = f"{AWS_ACCOUNT_ID}.dkr.ecr.{AWS_REGION}.amazonaws.com"
        # Generate REPO URIs

        for service in SERVICES:
            uri: str = f"{AWS_REGISTRY}/{SERVICES[service]["repo_name"]}"
            tag: str = f"{SERVICES[service]["repo_name"]}"

            SERVICES[service]["uri"] = uri
            SERVICES[service]["tag"] = tag

        self.MODULES = MODULES
        self.SERVICES = SERVICES
        self.AWS_REGION = AWS_REGION
        self.AWS_REGISTRY = AWS_REGISTRY
        self.TERRAFORM_DIR = TERRAFORM_DIR
        self.AWS_ACCOUNT_ID = AWS_ACCOUNT_ID

    def run_command(self, command: str) -> None:
        """Run a shell command and print the output."""
        print(f"Running command: {command}")
        result = subprocess.run(command, shell=True, check=True, text=True)
        print(result.stdout)

    def terraform_init(self) -> None:
        """Initialize Terraform."""
        self.run_command(f"cd {self.TERRAFORM_DIR} && terraform init")

    def terraform_apply(self) -> None:
        """Apply Terraform modules except ecs."""
        self.terraform_init()
        for module in self.MODULES:
            self.run_command(f"cd {self.TERRAFORM_DIR} && terraform apply -target=module.{module} -auto-approve")
        print("Terraform apply completed for all modules except ecs.")

    def docker_login(self) -> None:
        """Login to AWS ECR."""
        print("Retrieving authentication token...")
        login_command = f"aws ecr get-login-password --region {self.AWS_REGION} | docker login --username AWS --password-stdin {self.AWS_REGISTRY}"
        self.run_command(login_command)

    def build_and_tag_images(self) -> None:
        """Build and tag Docker images."""
        for service in self.SERVICES:
            uri = self.SERVICES[service]["uri"]
            repo_tag = self.SERVICES[service]["tag"]
            docker_target = self.SERVICES[service]["docker_target"]

            print(f"Building the {service} image...")
            build_command = f"docker build --platform linux/amd64 -t {repo_tag} --target {docker_target} -f dagster/Dockerfile dagster"
            self.run_command(build_command)

            print(f"Tagging {service} image...")
            tag_command = f"docker tag {repo_tag}:latest {uri}:latest"

    def docker_push(self) -> None:
        """Push Docker images to ECR."""
        print("Pushing Docker images...")
        for service in self.SERVICES:
            uri = self.SERVICES[service]["uri"]
            self.run_command(f"docker push {uri}:latest")
        print("Images pushed 🤩")

    def deploy_services(self) -> None:
        """Deploy ECS services using Terraform."""
        print("Applying Terraform configuration for the ecs module...")
        self.run_command(f"cd {self.TERRAFORM_DIR} && terraform apply -target=module.ecs -auto-approve")
        print("Terraform apply completed for the ecs module.")

    def destroy_services(self) -> None:
        """Destroy ECS services using Terraform."""
        print("Destroying Terraform configuration for the ecs module...")
        self.run_command(f"cd {self.TERRAFORM_DIR} && terraform destroy -target=module.ecs -auto-approve")
        print("Terraform destroy completed for the ecs module.")

    def terraform_destroy(self) -> None:
        """Destroy all Terraform-managed infrastructure."""
        print("Destroying all Terraform-managed infrastructure...")
        self.run_command(f"cd {self.TERRAFORM_DIR} && terraform destroy -auto-approve")
        print("Terraform destroy completed.")

    def deploy_base_infrastructure(self) -> None:
        # Example workflow
        self.terraform_init()
        self.terraform_apply()

    def build_and_push(self) -> None:
        # Example workflow
        self.docker_login()
        self.build_and_tag_images()
        self.docker_push()

    def deploy_ecs_services(self) -> None:
        # Example workflow
        self.terraform_init()
        self.deploy_services()

    def destroy_ecs_services(self) -> None:
        # Example workflow
        self.terraform_init()
        self.destroy_services()

    def destroy_everything(self) -> None:
        # Example workflow
        self.terraform_destroy()
