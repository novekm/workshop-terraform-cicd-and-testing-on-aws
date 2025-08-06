# Instructions: Create resources for IAM
resource "random_string" "random_string" {
  length  = 4
  special = false
  upper   = false
}


# - Trust Relationships -
# EventBridge (for S3 event notifications)
data "aws_iam_policy_document" "eventbridge_trust_relationship" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}
# CodeBuild
data "aws_iam_policy_document" "codebuild_trust_relationship" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}
# CodePipeline
data "aws_iam_policy_document" "codepipeline_trust_relationship" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

# - Policies -
# S3 Event Notifications - Invoke CodePipeline
data "aws_iam_policy_document" "s3_trigger_codepipeline_policy" {
  statement {
    effect = "Allow"
    actions = [
      "codepipeline:StartPipelineExecution",
    ]
    resources = [
      "*"
    ]
  }

  # - Challenge: resolve Checkov issues -
  #checkov:skip=CKV_AWS_356: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions""
  #checkov:skip=CKV_AWS_111: "Ensure IAM policies does not allow write access without constraints"
}
resource "aws_iam_policy" "s3_trigger_codepipeline_policy" {
  name        = "${var.project_prefix}-s3-trigger-codepipeline-${random_string.random_string.result}"
  description = "Policy that allows S3 event notifications to trigger CodePipeline executions."
  policy      = data.aws_iam_policy_document.s3_trigger_codepipeline_policy.json

  tags = merge(
    var.tags,
    {
      Name = "${var.project_prefix}-s3-trigger-codepipeline"
    },
  )
}

# CodeBuild
data "aws_iam_policy_document" "codebuild_policy" {
  count = var.create_codebuild_service_role ? 1 : 0
  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      "*",
    ]
  }

  # - Challenge: resolve Checkov issues -
  #checkov:skip=CKV_AWS_356: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions""
  #checkov:skip=CKV_AWS_111: "Ensure IAM policies does not allow write access without constraints"
  #checkov:skip=CKV_AWS_108: "Ensure IAM policies does not allow data exfiltration"
  #checkov:skip=CKV_AWS_109: "Ensure IAM policies does not allow permissions management / resource exposure without constraints"
}
resource "aws_iam_policy" "codebuild_policy" {
  count       = var.create_codebuild_service_role ? 1 : 0
  name        = "${var.project_prefix}-codebuild-service-role-policy${random_string.random_string.result}"
  description = "Policy granting AWS CodePipeling restricted access to _____"
  policy      = data.aws_iam_policy_document.codebuild_policy[0].json
}
# CodePipeline
data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
    ]
    resources = ["*"]
  }

  # - Challenge: resolve Checkov issues -
  #checkov:skip=CKV_AWS_356: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions"
  #checkov:skip=CKV_AWS_111: "Ensure IAM policies does not allow write access without constraints"
  #checkov:skip=CKV_AWS_108: "Ensure IAM policies does not allow data exfiltration"
  #checkov:skip=CKV_AWS_109: "Ensure IAM policies does not allow permissions management / resource exposure without constraints"
}
resource "aws_iam_policy" "codepipeline_policy" {
  count       = var.create_codepipeline_service_role ? 1 : 0
  name        = "${var.project_prefix}-codepipeline-service-role-policy-${random_string.random_string.result}"
  description = "Policy granting AWS CodePipeline access to Amazon S3."
  policy      = data.aws_iam_policy_document.codepipeline_policy.json
}



# - IAM Roles -
# S3 Event Notifications to trigger CodePipeline
resource "aws_iam_role" "s3_trigger_codepipeline" {
  name                  = "${var.project_prefix}-s3-trigger-codepipeline-${random_string.random_string.result}"
  assume_role_policy    = data.aws_iam_policy_document.eventbridge_trust_relationship.json
  force_detach_policies = var.enable_force_detach_policies
  tags = merge(
    var.tags,
    {
      Name = "${var.project_prefix}-s3-trigger-codepipeline"
    },
  )
}
resource "aws_iam_role_policy_attachment" "s3_trigger_codepipeline" {
  role       = aws_iam_role.s3_trigger_codepipeline.name
  policy_arn = aws_iam_policy.s3_trigger_codepipeline_policy.arn
}


# CodeBuild
resource "aws_iam_role" "codebuild_service_role" {
  count              = var.create_codebuild_service_role ? 1 : 0
  name               = "${var.project_prefix}-codebuild-service-role-${random_string.random_string.result}"
  assume_role_policy = data.aws_iam_policy_document.codebuild_trust_relationship.json
}
resource "aws_iam_role_policy_attachment" "codebuild_service_role" {
  count      = var.create_codebuild_service_role ? 1 : 0
  role       = aws_iam_role.codebuild_service_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

  # - Challenge: resolve Checkov issues -
  #checkov:skip=CKV_AWS_274: "Disallow IAM roles, users, and groups from using the AWS AdministratorAccess policy"
}

# CodePipeline
resource "aws_iam_role" "codepipeline_service_role" {
  count              = var.create_codepipeline_service_role ? 1 : 0
  name               = "${var.project_prefix}-codepipeline-service-role-${random_string.random_string.result}"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_trust_relationship.json
}
resource "aws_iam_role_policy_attachment" "codepipeline_service_role" {
  count      = var.create_codepipeline_service_role ? 1 : 0
  role       = aws_iam_role.codepipeline_service_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

  # - Challenge: resolve Checkov issues -
  #checkov:skip=CKV_AWS_274: "Disallow IAM roles, users, and groups from using the AWS AdministratorAccess policy"
}