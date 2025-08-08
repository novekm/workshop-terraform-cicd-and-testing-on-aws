# Instructions: Create output values for the module

output "tf_state_s3_buckets_names" {
  value = tomap({
    for k, bucket in aws_s3_bucket.tf_remote_state_s3_buckets : k => bucket.id
  })
}

output "git_remote_s3_bucket_names" {
  description = "Names of S3 buckets created for git-remote-s3"
  value = tomap({
    for k, bucket in aws_s3_bucket.git_remote_s3_buckets : k => bucket.id
  })
}

output "git_remote_s3_bucket_arns" {
  description = "ARNs of S3 buckets created for git-remote-s3"
  value = tomap({
    for k, bucket in aws_s3_bucket.git_remote_s3_buckets : k => bucket.arn
  })
}

output "codepipeline_artifacts_bucket_names" {
  description = "Names of S3 buckets created for CodePipeline artifacts"
  value = tomap({
    for k, bucket in aws_s3_bucket.codepipeline_artifacts_buckets : k => bucket.id
  })
}
