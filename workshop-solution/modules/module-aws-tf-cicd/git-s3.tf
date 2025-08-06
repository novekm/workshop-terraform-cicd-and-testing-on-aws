# S3 buckets for git-remote-s3
resource "random_string" "git_remote_s3_buckets" {
  for_each = var.git_remote_s3_buckets == null ? {} : var.git_remote_s3_buckets
  length   = 4
  special  = false
  upper    = false
}

resource "aws_s3_bucket" "git_remote_s3_buckets" {
  for_each      = var.git_remote_s3_buckets == null ? {} : var.git_remote_s3_buckets
  bucket        = "${each.value.bucket_name}-${random_string.git_remote_s3_buckets[each.key].result}"
  force_destroy = true

  # tags = merge(
  #   {
  #     "Name"        = "${each.value.bucket_name}-${random_string.git_remote_s3_buckets[each.key].result}"
  #     "Description" = each.value.description
  #   },
  #   var.tags,
  #   each.value.tags
  # )
}

resource "aws_s3_bucket_versioning" "git_remote_s3_buckets" {
  for_each = var.git_remote_s3_buckets == null ? {} : var.git_remote_s3_buckets
  bucket   = aws_s3_bucket.git_remote_s3_buckets[each.key].id
  versioning_configuration {
    status = each.value.versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_public_access_block" "git_remote_s3_buckets" {
  for_each = var.git_remote_s3_buckets == null ? {} : var.git_remote_s3_buckets
  bucket   = aws_s3_bucket.git_remote_s3_buckets[each.key].id

  block_public_acls       = var.s3_public_access_block
  block_public_policy     = var.s3_public_access_block
  ignore_public_acls      = var.s3_public_access_block
  restrict_public_buckets = var.s3_public_access_block
}

# S3 bucket notifications to CloudWatch Events
resource "aws_s3_bucket_notification" "git_remote_s3_notifications" {
  for_each = var.git_remote_s3_buckets == null ? {} : var.git_remote_s3_buckets
  bucket   = aws_s3_bucket.git_remote_s3_buckets[each.key].id

  eventbridge = true

  depends_on = [aws_s3_bucket.git_remote_s3_buckets]
}
