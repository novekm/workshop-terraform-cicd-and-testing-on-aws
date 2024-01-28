# Instructions: Create resources for S3

resource "random_string" "codepipeline_artifacts_s3_buckets" {
  for_each = var.codepipeline_pipelines == null ? {} : var.codepipeline_pipelines
  length   = 4
  special  = false
  upper    = false
}

resource "aws_s3_bucket" "codepipeline_artifacts_buckets" {
  for_each = var.codepipeline_pipelines == null ? {} : var.codepipeline_pipelines
  bucket   = "pipeline-artifacts-${each.value.name}-${random_string.codepipeline_artifacts_s3_buckets[each.key].result}"
}

resource "aws_s3_bucket_public_access_block" "codepipeline_bucket_pabs" {
  for_each = var.codepipeline_pipelines == null ? {} : var.codepipeline_pipelines
  bucket   = aws_s3_bucket.codepipeline_artifacts_buckets[each.key].id

  block_public_acls       = var.s3_public_access_block
  block_public_policy     = var.s3_public_access_block
  ignore_public_acls      = var.s3_public_access_block
  restrict_public_buckets = var.s3_public_access_block
}


