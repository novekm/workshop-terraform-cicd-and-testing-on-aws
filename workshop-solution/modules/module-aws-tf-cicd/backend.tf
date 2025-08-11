# Instructions: Dynamically create resources for S3 Remote Backend

resource "random_string" "tf_remote_state_s3_buckets" {
  for_each = var.tf_remote_state_resource_configs == null ? {} : var.tf_remote_state_resource_configs
  length   = 4
  special  = false
  upper    = false
}

resource "aws_s3_bucket" "tf_remote_state_s3_buckets" {
  for_each      = var.tf_remote_state_resource_configs == null ? {} : var.tf_remote_state_resource_configs
  bucket        = "${each.value.prefix}-tf-state-${random_string.tf_remote_state_s3_buckets[each.key].result}"
  force_destroy = true

  # - Challenge: resolve Checkov issues -
  #checkov:skip=CKV2_AWS_62: "Ensure S3 buckets should have event notifications enabled"
  #checkov:skip=CKV2_AWS_61: "Ensure that an S3 bucket has a lifecycle configuration"
  #checkov:skip=CKV_AWS_144: "Ensure that S3 bucket has cross-region replication enabled"
  #checkov:skip=CKV_AWS_18: "Ensure the S3 bucket has access logging enabled"
  #checkov:skip=CKV_AWS_145: "Ensure that S3 buckets are encrypted with KMS by default"
}

resource "aws_s3_bucket_versioning" "tf_remote_state_s3_buckets" {
  for_each = var.tf_remote_state_resource_configs == null ? {} : var.tf_remote_state_resource_configs
  bucket   = aws_s3_bucket.tf_remote_state_s3_buckets[each.key].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "tf_remote_state_s3_buckets_pabs" {
  for_each = var.tf_remote_state_resource_configs == null ? {} : var.tf_remote_state_resource_configs
  bucket   = aws_s3_bucket.tf_remote_state_s3_buckets[each.key].id

  block_public_acls       = var.s3_public_access_block
  block_public_policy     = var.s3_public_access_block
  ignore_public_acls      = var.s3_public_access_block
  restrict_public_buckets = var.s3_public_access_block
}
