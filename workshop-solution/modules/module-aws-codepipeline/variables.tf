# Instructions: Create Module Input Variables

# - Conditional Logic Variables -
variable "create_iam_resources" {
  type        = bool
  default     = false
  description = "Conditional creation of IAM Resources."

}
variable "create_s3_artifacts_bucket" {
  type        = bool
  default     = false
  description = "Conditional creation of S3 artifacts bucket."

}

# - S3 -
variable "s3_public_access_block" {
  type        = bool
  default     = true
  description = "Conditional enabling of S3 Public Access Block."

}

# CodePipeline
variable "repository_name" {
  type        = string
  default     = null
  description = "The repository name of your source for CodePipeline."

}
variable "branch_name" {
  type        = string
  default     = null
  description = "The branch name of your source for CodePipeline."

}
variable "tf_module_validation_build_project_name" {
  type        = string
  default     = null
  description = "The name of your CodeBuild Project that you wish to use in the build stage our source for CodePipeline."

}
