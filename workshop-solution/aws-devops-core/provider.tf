# Instructions: Place your provider configuration below

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # Instructions: Add S3 Remote Backend Configuration
  backend "s3" {
    bucket         = "your-s3-bucket"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "your-tf-state-lock-dynamodb-table"
  }
}


# Configure the AWS Provider
provider "aws" {
  region = var.aws_region


  default_tags {
    tags = {
      Management = "Terraform"
    }
  }
}
