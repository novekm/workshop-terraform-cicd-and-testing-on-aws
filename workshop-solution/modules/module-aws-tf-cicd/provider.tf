# Instructions: Create required_providers to ensure compatibility with the resources used in this module
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}