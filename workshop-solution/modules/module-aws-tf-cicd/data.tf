# data "aws_codecommit_repository" "codecommit_repositories" {
#   for_each        = local.codebuild_projects_and_their_source_locations
#   repository_name = each.value.source_location

#   depends_on = [aws_codecommit_repository.codecommit_repo]
# }
data "aws_codecommit_repository" "codecommit_repositories" {
  for_each = var.codecommit_repos == null ? {} : var.codecommit_repos

  repository_name = each.value.repository_name
  depends_on      = [aws_codecommit_repository.codecommit_repo]
}


