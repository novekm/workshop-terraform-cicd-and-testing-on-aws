# Instructions: Create resources for S3 below

resource "random_string" "codepipeline_artifacts_s3_buckets" {
  for_each = var.codepipeline_pipelines == null ? {} : var.codepipeline_pipelines
  length   = 4
  special  = false
  upper    = false
}

resource "aws_s3_bucket" "codepipeline_artifacts_buckets" {
  for_each = var.codepipeline_pipelines == null ? {} : var.codepipeline_pipelines
  bucket   = "pipeline-artifacts-${each.value.name}-${random_string.codepipeline_artifacts_s3_buckets[each.key].result}"
  force_destroy = true

  # - Challenge: resolve Checkov issues -
  #checkov:skip=CKV2_AWS_62: "Ensure S3 buckets should have event notifications enabled"
  #checkov:skip=CKV2_AWS_61: "Ensure that an S3 bucket has a lifecycle configuration"
  #checkov:skip=CKV_AWS_144: "Ensure that S3 bucket has cross-region replication enabled"
  #checkov:skip=CKV_AWS_18: "Ensure the S3 bucket has access logging enabled"
  #checkov:skip=CKV_AWS_21: "Ensure all data stored in the S3 bucket have versioning enabled"
  #checkov:skip=CKV_AWS_145: "Ensure that S3 buckets are encrypted with KMS by default"

}

resource "aws_s3_bucket_public_access_block" "codepipeline_bucket_pabs" {
  for_each = var.codepipeline_pipelines == null ? {} : var.codepipeline_pipelines
  bucket   = aws_s3_bucket.codepipeline_artifacts_buckets[each.key].id

  block_public_acls       = var.s3_public_access_block
  block_public_policy     = var.s3_public_access_block
  ignore_public_acls      = var.s3_public_access_block
  restrict_public_buckets = var.s3_public_access_block
}

# CloudWatch Event Rules for S3 notifications to trigger CodePipeline
resource "aws_cloudwatch_event_rule" "s3_trigger_codepipeline" {
  for_each    = var.codepipeline_pipelines == null ? {} : var.codepipeline_pipelines
  name        = "s3-trigger-${each.value.name}-codepipeline"
  description = "Trigger CodePipeline when objects are created in git remote S3 bucket"

  event_pattern = jsonencode({
    source      = ["aws.s3"]
    detail-type = ["Object Created"]
    detail = {
      bucket = {
        name = [
          # Direct mapping based on pipeline name patterns
          each.key == "tf_module_validation_module_aws_tf_cicd" ? aws_s3_bucket.git_remote_s3_buckets["module_aws_tf_cicd"].id :
          each.key == "tf_deployment_example_production_workload" ? aws_s3_bucket.git_remote_s3_buckets["example_production_workload"].id :
          ""
        ]
      }
      object = {
        key = [{
          prefix = "s3-repo/refs/heads/main/repo.zip"
        }]
      }
    }
  })

  tags = merge(
    var.tags,
    {
      "Name" = "s3-trigger-${each.value.name}"
    }
  )
}

resource "aws_cloudwatch_event_target" "s3_trigger_codepipeline" {
  for_each  = var.codepipeline_pipelines == null ? {} : var.codepipeline_pipelines
  rule      = aws_cloudwatch_event_rule.s3_trigger_codepipeline[each.key].name
  target_id = "TriggerCodePipeline"
  arn       = aws_codepipeline.codepipeline[each.key].arn
  role_arn  = aws_iam_role.s3_trigger_codepipeline.arn
}