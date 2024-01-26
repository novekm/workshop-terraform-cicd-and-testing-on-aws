# Instructions: Create Module Input Variables

# Conditional Logic Variables
variable "create_codepipeline_resources" {
  type        = bool
  default     = false
  description = "Conditional creation of CodePipeline and related AWS Services"

}
variable "create_codebuild_resources" {
  type        = bool
  default     = false
  description = "Conditional creation of CodePipeline and related AWS Services"

}
variable "create_s3_remote_backend" {
  type        = bool
  default     = false
  description = "Conditional creation of S3 bucket to store Terraform state file"

}

variable "codecommit_repos" {
  type = map(object({
    repo_name      = string
    description    = optional(string, null)
    default_branch = optional(string, "main")
    tags           = optional(map(any), { "ContentType" = "Terraform Module" })
  }))
  description = "Collection of AWS CodeCommit Repositories you wish to create"
  default     = {}
}

variable "project_prefix" {
  type        = string
  default     = "tf-workshop"
  description = "The prefix for the current project"

  validation {
    condition     = length(var.project_prefix) > 1 && length(var.project_prefix) <= 40
    error_message = "The defined 'project_prefix' has too many characters (${length(var.project_prefix)}). This can cause deployment failures for AWS resources with smaller character limits. Please reduce the character count and try again."
  }

}


# - S3 -

variable "s3_public_access_block" {
  type        = bool
  default     = true
  description = "Conditional enabling of S3 Public Access Block"


}


# - CodeBuild -
variable "codebuild_projects" {
  type = map(object({
    repo_name      = string
    description    = optional(string, null)
    default_branch = optional(string, "main")
    tags           = optional(map(any), { "ContentType" = "Terraform Module" })
  }))
  description = "Collection of AWS CodeBuild Projects you wish to create"
  default     = {}
}

variable "codebuild_build_timeout" {
  type        = number
  default     = 60
  description = "The number of minutes from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any build that does not get marked as completed. This option is not available for the 'Lambda' compute type."

  validation {
    condition     = var.codebuild_build_timeout < 5 && var.codebuild_build_timeout > 480
    error_message = "The defined 'codebuild_build_timeout' (${var.codebuild_build_timeout}) is not an acceptable value. The build_timeout must be greater than 5 or lesss than 480"
  }

}
variable "codebuild_env_compute_type" {
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
  description = "The compute configuration of the CodeBuild server. See the docs for more info:https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html#environment.types"

}
variable "codebuild_env_image" {
  type        = string
  default     = "hashicorp/terraform:latest"
  description = "The Docker image to use for this build project. Valid values include Docker images provided by CodeBuild, Docker Hub images, and full Docker repository URIs sucj as those for ECR"

}
variable "codebuild_source_type" {
  type        = string
  description = "The type of repository that contains the source doe to be built. Valid values are 'CODECOMMIT', 'CODEPIPELINE', 'GITHUB', 'GITHUB_ENTERPRISE', 'BITBUCKET', 'S3' and 'NO_SOURCE'."
  default     = null

  validation {
    condition     = var.codebuild_source_type != null
    error_message = "A CodeBuild source type must be defined. Valid values are 'CODECOMMIT', 'CODEPIPELINE', 'GITHUB', 'GITHUB_ENTERPRISE', 'BITBUCKET', 'S3' and 'NO_SOURCE'"
  }
}

