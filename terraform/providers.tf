terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.52.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region  = var.REGION
  profile = var.PROFILE
  default_tags {
    tags = {
      comments  = "this resource is managed by terraform"
      terraform = "true"
      project   = var.PROJECT
    }
  }
}
