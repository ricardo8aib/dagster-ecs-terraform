import argparse
from config import (
    SERVICES,
    AWS_ACCOUNT_ID,
    AWS_REGION,
    TERRAFORM_DIR,
    MODULES
)
from deployer import Deployer

make = Deployer(
    SERVICES=SERVICES,
    AWS_ACCOUNT_ID=AWS_ACCOUNT_ID,
    AWS_REGION=AWS_REGION,
    TERRAFORM_DIR=TERRAFORM_DIR,
    MODULES=MODULES
)


def main():
    parser = argparse.ArgumentParser(description="Run specific functions")
    parser.add_argument(
        "command",
        choices=[
            "deploy_base_infrastructure",
            "build_and_push",
            "deploy_ecs_services",
            "destroy_ecs_services",
            "destroy_everything",
        ],
        help="Command to run"
    )

    args = parser.parse_args()

    if args.command == "deploy_base_infrastructure":
        make.deploy_base_infrastructure()
    elif args.command == "build_and_push":
        make.build_and_push()
    elif args.command == "deploy_ecs_services":
        make.deploy_ecs_services()
    elif args.command == "destroy_ecs_services":
        make.destroy_ecs_services()
    elif args.command == "destroy_everything":
        make.destroy_everything()


if __name__ == "__main__":
    main()
