# CodePipeline

resource "random_uuid" "codepipeline_artifacts_s3_uuid" {
}

resource "random_string" "codepipeline_artifacts_s3" {
  length  = 8
  special = false
}


resource "aws_s3_bucket" "codepipeline_artifacts_bucket" {
  bucket = "codepipeline-artifacts-${random_string.codepipeline_artifacts_s3.result}"
}

resource "aws_s3_bucket_public_access_block" "codepipeline_bucket_pab" {
  bucket = aws_s3_bucket.codepipeline_artifacts_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
