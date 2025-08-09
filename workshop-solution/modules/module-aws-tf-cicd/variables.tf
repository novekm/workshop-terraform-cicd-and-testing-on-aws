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
variable "create_cloudwatch_service_role" {
  type        = bool
  default     = true
  description = "Conditional creation of Cloudwatch IAM Role."

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

# - Git Remote S3 Buckets -
variable "git_remote_s3_buckets" {
  type = map(object({
    bucket_name = string
    description = optional(string, null)
    versioning  = optional(bool, true)
    tags        = optional(map(any), { "ContentType" = "Git Remote S3" })
  }))
  description = <<-EOT
    Collection of S3 buckets to use as git remotes with git-remote-s3. This is dynamic and lets you configure each bucket separately.

    Object fields:
    - bucket_name: The name of the S3 bucket
    - description: Description of the bucket (optional)
    - versioning: Enable S3 bucket versioning (default: true)
    - tags: Tags to apply to the bucket (default: {"ContentType" = "Git Remote S3"})
  EOT
  default     = {}

  validation {
    condition     = alltrue([for bucket in values(var.git_remote_s3_buckets) : length(bucket.bucket_name) > 1 && length(bucket.bucket_name) <= 63])
    error_message = "The name of one of the defined S3 buckets is invalid. S3 bucket names must be between 3 and 63 characters long. Please ensure all bucket names meet this requirement and try again."
  }
}

# - CodeBuild -
variable "codebuild_projects" {
  type = map(object({

    name          = string
    description   = optional(string, null)
    build_timeout = optional(number, 60)

    env_compute_type            = optional(string, "BUILD_GENERAL1_SMALL")
    env_image                   = optional(string, "public.ecr.aws/hashicorp/terraform:latest")
    env_type                    = optional(string, "LINUX_CONTAINER")
    image_pull_credentials_type = optional(string, "SERVICE_ROLE")

    source_version     = optional(string, "main")
    source_type        = optional(string, "NO_SOURCE")
    source_location    = optional(string, null)
    source_clone_depth = optional(number, 1)
    path_to_build_spec = optional(string, null)
    build_spec         = optional(string, null)

    tags = optional(map(any), { "ContentType" = "Terraform Module" })

  }))
  description = <<-EOT
    Collection of AWS CodeBuild Projects you wish to create. This is dynamic and lets you configure each project separately.

    Object fields:
    - name: The name of the CodeBuild project
    - description: Description of the project (optional)
    - build_timeout: Build timeout in minutes (default: 60)
    - env_compute_type: Compute type for build environment (default: "BUILD_GENERAL1_SMALL")
    - env_image: Docker image for build environment (default: "public.ecr.aws/hashicorp/terraform:latest")
    - env_type: Environment type (default: "LINUX_CONTAINER")
    - image_pull_credentials_type: Credentials type for pulling images (default: "SERVICE_ROLE")
    - source_version: Source version/branch (default: "main")
    - source_type: Source type (default: "NO_SOURCE")
    - source_location: Source location URL (optional)
    - source_clone_depth: Git clone depth (default: 1)
    - path_to_build_spec: Path to buildspec file (optional)
    - build_spec: Inline buildspec content (optional)
    - tags: Tags to apply to the project (default: {"ContentType" = "Terraform Module"})
  EOT
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
    git_source              = string
    pipeline_type           = optional(string, "V2")
    stages                  = list(any)
    existing_s3_bucket_name = optional(string, null)
    event_pattern           = optional(string, null)


    tags = optional(map(any), { "Description" = "Pipeline" })

  }))
  description = <<-EOT
    Collection of AWS CodePipeline Pipelines you wish to create. This is dynamic and lets you configure each pipeline separately.

    Object fields:
    - name: The name of the CodePipeline pipeline
    - git_source: Key from the git_remote_s3_buckets map that this pipeline monitors for git changes. Must match an existing key in git_remote_s3_buckets.
    - pipeline_type: The type of pipeline (default: "V2")
    - stages: List of pipeline stages configuration
    - existing_s3_bucket_name: Name of existing S3 bucket for artifacts (optional)
    - event_pattern: Custom event pattern for triggering (optional)
    - tags: Tags to apply to the pipeline (default: {"Description" = "Pipeline"})
  EOT
  default     = {}

  validation {
    condition     = alltrue([for pipeline in values(var.codepipeline_pipelines) : length(pipeline.name) > 3 && length(pipeline.name) <= 40])
    error_message = "The name of one of the defined CodePipeline pipelines is too long. Pipeline names can be a maxmium of 40 characters, as the names are used by other resources throughout this module. This can cause deployment failures for AWS resources with smaller character limits for naming. Please ensure all pipeline names are 40 characters or less, and try again."
  }

  validation {
    condition = alltrue([
      for pipeline in values(var.codepipeline_pipelines) :
      contains(keys(var.git_remote_s3_buckets), pipeline.git_source)
    ])
    error_message = "Pipeline git_source must reference an existing key in git_remote_s3_buckets. Available keys: ${join(", ", keys(var.git_remote_s3_buckets))}"
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



# - IAM -
variable "enable_force_detach_policies" {
  description = "Enable force detaching any policies from IAM roles."
  type        = bool
  default     = true
}


# Terraform Remote State Resources
variable "tf_remote_state_resource_configs" {
  type = map(object({
    prefix           = optional(string, "my-prefix")
  }))
  description = <<-EOT
    Configurations for Terraform State Resources. This is dynamic and lets you configure state backend resources.

    Object fields:
    - prefix: Prefix for resource names (default: "my-prefix")
  EOT
  default     = {}

  validation {
    condition     = alltrue([for config in values(var.tf_remote_state_resource_configs) : length(config.prefix) > 3 && length(config.prefix) <= 40])
    error_message = "The prefix of one of the defined Terraform Remote State Resource Configs is too long. A prefix can be a maxmium of 40 characters, as the names are used by other resources throughout this module. This can cause deployment failures for AWS resources with smaller character limits for naming. Please ensure all prefixes are 40 characters or less, and try again."
  }
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

# - Tags -
variable "tags" {
  type        = map(any)
  description = "Tags to apply to resources."
  default = {
    "IAC_PROVIDER" = "Terraform"
  }
}
