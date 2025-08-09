# Instructions: Place your outputs below# Instructions: Place your outputs below

# AWS DevOps Core
output "aws_devops_core_s3_bucket_name" {
  value = module.module-aws-tf-cicd.tf_state_s3_buckets_names["aws_devops_core"]
}

# Example Production Workload
output "example_production_workload_s3_bucket_name" {
  value = module.module-aws-tf-cicd.tf_state_s3_buckets_names["example_production_workload"]
}

# Git Remote S3 Buckets
output "git_remote_s3_bucket_names" {
  description = "Names of S3 buckets created for git-remote-s3"
  value       = module.module-aws-tf-cicd.git_remote_s3_bucket_names
}
