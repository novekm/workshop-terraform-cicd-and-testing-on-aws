# Instructions: Create CodeCommit Resource

resource "aws_codecommit_repository" "codecommit_repo" {
  repository_name = var.repository_name
  description     = var.description
  default_branch  = var.default_branch
  tags            = var.tags
}
