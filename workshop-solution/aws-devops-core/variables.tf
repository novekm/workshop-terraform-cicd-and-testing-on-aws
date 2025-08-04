# Instructions: Place your variables below

variable "aws_region" {
  type        = string
  description = "The AWS region you wish to deploy your resources to."
  default     = "us-east-1"

}

variable "checkov_ecr_repository_name" {
  type        = string
  default     = "checkov"
  description = "The name of the ECR repository you wish to create for the checkov image."
}
