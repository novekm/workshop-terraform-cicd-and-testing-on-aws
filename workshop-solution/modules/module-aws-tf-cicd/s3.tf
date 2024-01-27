# Instructions: Create resources for S3

resource "random_string" "codepipeline_artifacts_s3_bucket" {
  count   = var.create_codepipeline_artifacts_bucket ? 1 : 0
  length  = 4
  special = false
  upper   = false
}

resource "aws_s3_bucket" "codepipeline_artifacts_bucket" {
  count  = var.create_codepipeline_artifacts_bucket ? 1 : 0
  bucket = "${var.project_prefix}-codepipeline-artifacts-${random_string.codepipeline_artifacts_s3_bucket[0].result}"
}

resource "aws_s3_bucket_public_access_block" "codepipeline_bucket_pab" {
  count  = var.create_codepipeline_artifacts_bucket ? 1 : 0
  bucket = aws_s3_bucket.codepipeline_artifacts_bucket[0].id

  block_public_acls       = var.s3_public_access_block
  block_public_policy     = var.s3_public_access_block
  ignore_public_acls      = var.s3_public_access_block
  restrict_public_buckets = var.s3_public_access_block
}
