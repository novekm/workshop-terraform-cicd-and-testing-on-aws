# Instructions: Create Module Input Variables

# - Conditional Logic Variables -
variable "create_codepipeline_artifacts_bucket" {
  type        = bool
  default     = true
  description = "Conditional creation of CodePipeline artifacts S3 Bucket."

}
variable "create_codepipeline_service_role" {
  type        = bool
  default     = true
  description = "Conditional creation of CodePipeline IAM Role."

}
variable "create_codebuild_service_role" {
  type        = bool
  default     = true
  description = "Conditional creation of CodeBuild IAM Role."

}
variable "create_s3_remote_backend" {
  type        = bool
  default     = false
  description = "Conditional creation of S3 bucket to store Terraform state file."

}

# - Codecommit -
variable "codecommit_repos" {
  type = map(object({
    repository_name = string
    description     = optional(string, null)
    default_branch  = optional(string, "main")
    tags            = optional(map(any), { "ContentType" = "Terraform Module" })
  }))
  description = "Collection of AWS CodeCommit Repositories you wish to create"
  default     = {}

  validation {
    condition     = alltrue([for repo in values(var.codecommit_repos) : length(repo.repository_name) > 1 && length(repo.repository_name) <= 100])
    error_message = "The name of one of the defined CodeCodecommit Repositories is too long. Repository names can be a maxmium of 100 characters, as the names are used by other resources throughout this module. This can cause deployment failures for AWS resources with smaller character limits for naming. Please ensure all repository names are 100 characters or less, and try again."
  }
}

# - CodeBuild -
variable "codebuild_projects" {
  type = map(object({

    name          = string
    description   = optional(string, null)
    build_timeout = optional(number, 60)

    env_compute_type = optional(string, "BUILD_GENERAL1_SMALL")
    env_image        = optional(string, "hashicorp/terraform:latest")
    env_type         = optional(string, "LINUX_CONTAINER")

    source_version     = optional(string, "main")
    source_type        = optional(string, "NO_SOURCE")
    source_location    = optional(string, null)
    source_clone_depth = optional(number, 1)
    path_to_build_spec = optional(string, null)
    build_spec         = optional(string, null)

    tags = optional(map(any), { "ContentType" = "Terraform Module" })

  }))
  description = "Collection of AWS CodeBuild Projects you wish to create"
  default     = {}

  validation {
    condition     = alltrue([for project in values(var.codebuild_projects) : length(project.name) > 3 && length(project.name) <= 40])
    error_message = "The name of one of the defined CodeBuild Projects is too long. Project names can be a maxmium of 40 characters, as the names are used by other resources throughout this module. This can cause deployment failures for AWS resources with smaller character limits for naming. Please ensure all project names are 40 characters or less, and try again."
  }
}
variable "codebuild_service_role_arn" {
  type        = string
  default     = null
  description = "The ARN of the IAM Role you wish to use with CodeBuild."

}

# - CodePipeline -
variable "codepipeline_pipelines" {
  type = map(object({

    name                    = string
    pipeline_type           = optional(string, "V2")
    stages                  = list(any)
    existing_s3_bucket_name = optional(string, null)


    tags = optional(map(any), { "Description" = "Pipeline" })

  }))
  description = "Collection of AWS CodePipeline Pipelines you wish to create"
  default     = {}

  validation {
    condition     = alltrue([for pipeline in values(var.codepipeline_pipelines) : length(pipeline.name) > 3 && length(pipeline.name) <= 40])
    error_message = "The name of one of the defined CodePipeline pipelines is too long. Pipeline names can be a maxmium of 40 characters, as the names are used by other resources throughout this module. This can cause deployment failures for AWS resources with smaller character limits for naming. Please ensure all pipeline names are 40 characters or less, and try again."
  }
}
variable "codepipeline_service_role_arn" {
  type        = string
  default     = null
  description = "The ARN of the IAM Role you wish to use with CodePipeline."

}


# - S3 -
variable "existing_s3_bucket_name" {
  type        = string
  default     = null
  description = "The name of the existing S3 bucket you wish to store the CodePipeline artifacts in."

}
variable "s3_public_access_block" {
  type        = bool
  default     = true
  description = "Conditional enabling of S3 Public Access Block."

}

# - Project Prefix -
variable "project_prefix" {
  type        = string
  default     = "tf-workshop"
  description = "The prefix for the current project"

  validation {
    condition     = length(var.project_prefix) > 1 && length(var.project_prefix) <= 40
    error_message = "The defined 'project_prefix' has too many characters (${length(var.project_prefix)}). This can cause deployment failures for AWS resources with smaller character limits. Please reduce the character count and try again."
  }

}
