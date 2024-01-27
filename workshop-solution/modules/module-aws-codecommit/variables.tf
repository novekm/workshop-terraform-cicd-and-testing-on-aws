# Instructions: Create Module Input Variables for CodeCommit Module

variable "repository_name" {
  type        = string
  default     = null
  description = "The name for your AWS CodeCommit Repository."

}
variable "description" {
  type        = string
  default     = null
  description = "The description for your AWS CodeCommit Repository."

}
variable "default_branch" {
  type        = string
  default     = "main"
  description = "The default branch for your CodeCommit Repository."

}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "The tags for yoru CodeCommit Repository."
}
