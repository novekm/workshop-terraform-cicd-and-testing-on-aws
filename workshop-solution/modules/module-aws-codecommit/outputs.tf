output "clone_url_http" {
  value       = aws_codecommit_repository.codecommit_repo.clone_url_http
  description = "The HTTP clone URL for the CodeCommit Repo."
}
