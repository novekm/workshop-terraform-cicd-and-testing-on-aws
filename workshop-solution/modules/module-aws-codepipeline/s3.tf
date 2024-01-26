#  Create resources for S3 here

resource "random_uuid" "codepipeline_artifacts_bucket_uuid" {
}

resource "random_string" "codepipeline_artifacts_bucket" {
  count   = var.create_s3_artifacts_bucket ? 1 : 0
  length  = 8
  special = false
}


resource "aws_s3_bucket" "codepipeline_artifacts_bucket" {
  count  = var.create_s3_artifacts_bucket ? 1 : 0
  bucket = "tf-workshop-codepipeline-artifacts-${random_string.codepipeline_artifacts_bucket[0].result}"
}

resource "aws_s3_bucket_public_access_block" "codepipeline_artifacts_bucket_pab" {
  bucket = aws_s3_bucket.codepipeline_artifacts_bucket[0].id

  block_public_acls       = var.s3_public_access_block
  block_public_policy     = var.s3_public_access_block
  ignore_public_acls      = var.s3_public_access_block
  restrict_public_buckets = var.s3_public_access_block
}
