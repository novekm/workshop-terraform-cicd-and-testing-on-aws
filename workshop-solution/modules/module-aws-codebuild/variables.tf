# Instructions: Create Module Input Variables

# - Conditional Logic Variables -
variable "create_iam_resources" {
  type        = bool
  default     = true
  description = "Conditional creation of IAM Resources."

}

# - CodeBuild -
variable "project_name" {
  type        = string
  default     = null
  description = "The name of your CodeBuild Project."

  validation {
    condition     = var.project_name != null
    error_message = "A CodeBuild Project Name is required but was not defined. Please add a name for the CodeBuild Project.'"
  }
}
variable "project_description" {
  type        = string
  default     = null
  description = "The description of your CodeBuild Project."

}

variable "codebuild_build_timeout" {
  type        = number
  default     = 60
  description = "The number of minutes from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any build that does not get marked as completed. This option is not available for the 'Lambda' compute type."

  validation {
    condition     = var.codebuild_build_timeout > 5 && var.codebuild_build_timeout < 480
    error_message = "The defined 'codebuild_build_timeout' (${var.codebuild_build_timeout}) is not an acceptable value. The build_timeout must be greater than 5 or lesss than 480"
  }

}
variable "codebuild_env_compute_type" {
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
  description = "The compute configuration of the CodeBuild server."

}
variable "codebuild_env_image" {
  type        = string
  default     = "hashicorp/terraform:latest"
  description = "The Docker image to use for this build project. Valid values include Docker images provided by CodeBuild, Docker Hub images, and full Docker repository URIs sucj as those for ECR."

}
variable "codebuild_env_type" {
  type        = string
  default     = "LINUX_CONTAINER"
  description = "The Type of build environment to use for related builds."

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
variable "codebuild_source_location" {
  type        = string
  description = "The location of the source from git or s3"
  default     = null

}
variable "codebuild_source_clone_depth" {
  type        = number
  description = ""
  default     = 1

}
variable "path_to_build_spec" {
  type        = string
  default     = null
  description = "The path to the location of your build_spec file. Use if 'build_spec' is not defined."

}
variable "build_spec" {
  type        = string
  default     = null
  description = "The actual content of your build_spec. Use if 'path_to_build_spec' is not defined."
}
variable "source_version" {
  type        = string
  default     = "main"
  description = "ersion of the build input to be built for this project. If not specified, the latest version is used."
}


variable "tags" {
  type        = map(any)
  default     = {}
  description = "The tags for yoru CodeBuild Project."
}
