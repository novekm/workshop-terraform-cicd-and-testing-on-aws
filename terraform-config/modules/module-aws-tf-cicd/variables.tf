# Instructions: Create Module Input Variables

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
  default     = "tf-cicd-workshop"
  description = "The prefix for the current project"

  validation {
    condition     = length(var.project_prefix) > 1 && length(var.project_prefix) <= 40
    error_message = "The defined 'project_prefix' has too many characters (${length(var.project_prefix)}). This can cause deployment failures for AWS resources with smaller character limits. Please reduce the character count and try again."
  }

}
