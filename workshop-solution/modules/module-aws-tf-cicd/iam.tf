# Instructions: Create resources for IAM

resource "random_string" "random_string" {
  length  = 4
  special = false
  upper   = false
}


# - Trust Relationships -
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
# CloudWatch
data "aws_iam_policy_document" "cloudwatch_trust_relationship" {
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

# - Policies -
# CodePipeline
data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }

  # - Challenge: resolve Checkov issues -
  #checkov:skip=CKV_AWS_356: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions"
}
resource "aws_iam_policy" "codepipeline_policy" {
  count       = var.create_codepipeline_service_role ? 1 : 0
  name        = "${var.project_prefix}-codepipeline-service-role-policy-${random_string.random_string.result}"
  description = "Policy granting AWS CodePipeling restricted access to _____"
  policy      = data.aws_iam_policy_document.codepipeline_policy.json
}

# CodePipeline - CloudWatch
data "aws_iam_policy_document" "cloudwatch_policy" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }

  # - Challenge: resolve Checkov issues -
  #checkov:skip=CKV_AWS_356: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions"
}
resource "aws_iam_policy" "cloudwatch_policy" {
  count       = var.create_cloudwatch_service_role ? 1 : 0
  name        = "${var.project_prefix}-cloudwatch-service-role-policy-${random_string.random_string.result}"
  description = "Policy granting AWS CodePipeling restricted access to _____"
  policy      = data.aws_iam_policy_document.cloudwatch_policy.json
}

# CodeBuild
data "aws_iam_policy_document" "codebuild_policy" {
  count = var.create_codebuild_service_role ? 1 : 0
  statement {
    effect  = "Allow"
    actions = ["codecommit:*"]
    resources = [
      "*",
      # each.value.repository_name
    ]
  }

  # - Challenge: resolve Checkov issues -
  #checkov:skip=CKV_AWS_356: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions""
  #checkov:skip=CKV_AWS_111: "Ensure IAM policies does not allow write access without constraints"
}
resource "aws_iam_policy" "codebuild_policy" {
  count       = var.create_codebuild_service_role ? 1 : 0
  name        = "${var.project_prefix}-codebuild-service-role-policy${random_string.random_string.result}"
  description = "Policy granting AWS CodePipeling restricted access to _____"
  policy      = data.aws_iam_policy_document.codebuild_policy[0].json
}


# - IAM Roles -
# CodePipeline
resource "aws_iam_role" "codepipeline_service_role" {
  count              = var.create_codepipeline_service_role ? 1 : 0
  name               = "${var.project_prefix}-codepipeline-service-role-${random_string.random_string.result}"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_trust_relationship.json
  managed_policy_arns = [

    "arn:aws:iam::aws:policy/AdministratorAccess",
    # aws_iam_policy.codepipeline_policy[0].arn,
  ]

  # - Challenge: resolve Checkov issues -
  #checkov:skip=CKV_AWS_274: "Disallow IAM roles, users, and groups from using the AWS AdministratorAccess policy"
}

# Cloudwatch
resource "aws_iam_role" "cloudwatch_service_role" {
  count              = var.create_cloudwatch_service_role ? 1 : 0
  name               = "${var.project_prefix}-cloudwatch-service-role-${random_string.random_string.result}"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_trust_relationship.json
  managed_policy_arns = [

    "arn:aws:iam::aws:policy/AdministratorAccess",
    # aws_iam_policy.codepipeline_policy[0].arn,
  ]

  # - Challenge: resolve Checkov issues -
  #checkov:skip=CKV_AWS_274: "Disallow IAM roles, users, and groups from using the AWS AdministratorAccess policy"
}

# CodeBuild
resource "aws_iam_role" "codebuild_service_role" {
  count              = var.create_codebuild_service_role ? 1 : 0
  name               = "${var.project_prefix}-codebuild-service-role-${random_string.random_string.result}"
  assume_role_policy = data.aws_iam_policy_document.codebuild_trust_relationship.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
    # aws_iam_policy.codebuild_policy[0].arn,
  ]

  # - Challenge: resolve Checkov issues -
  #checkov:skip=CKV_AWS_274: "Disallow IAM roles, users, and groups from using the AWS AdministratorAccess policy"
}


