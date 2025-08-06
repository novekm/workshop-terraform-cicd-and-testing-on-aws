# AWS DevOps Core
output "aws_devops_core_s3_bucket_name" {
  value = module.module-aws-tf-cicd.tf_state_s3_buckets_names["aws_devops_core"]
}
output "aws_devops_core_ddb_table_name" {
  value = module.module-aws-tf-cicd.tf_state_ddb_table_names["aws_devops_core"]
}

# Example Production Workload
output "example_production_workload_s3_bucket_name" {
  value = module.module-aws-tf-cicd.tf_state_s3_buckets_names["example_production_workload"]
}
output "example_production_workload_ddb_table_name" {
  value = module.module-aws-tf-cicd.tf_state_ddb_table_names["example_production_workload"]
}

# Git Remote S3 Buckets
output "git_remote_s3_bucket_names" {
  description = "Names of S3 buckets created for git-remote-s3"
  value       = module.module-aws-tf-cicd.git_remote_s3_bucket_names
}

output "git_remote_s3_bucket_arns" {
  description = "ARNs of S3 buckets created for git-remote-s3"
  value       = module.module-aws-tf-cicd.git_remote_s3_bucket_arns
}

output "codepipeline_artifacts_bucket_names" {
  description = "Names of S3 buckets created for CodePipeline artifacts"
  value       = module.module-aws-tf-cicd.codepipeline_artifacts_bucket_names
}

# Individual Git Remote S3 Bucket Names for easy reference
output "module_aws_tf_cicd_git_bucket_name" {
  description = "S3 bucket name for module-aws-tf-cicd git remote"
  value       = module.module-aws-tf-cicd.git_remote_s3_bucket_names["module_aws_tf_cicd"]
}

output "aws_devops_core_git_bucket_name" {
  description = "S3 bucket name for aws-devops-core git remote"
  value       = module.module-aws-tf-cicd.git_remote_s3_bucket_names["aws_devops_core"]
}

output "example_production_workload_git_bucket_name" {
  description = "S3 bucket name for example-production-workload git remote"
  value       = module.module-aws-tf-cicd.git_remote_s3_bucket_names["example_production_workload"]
}