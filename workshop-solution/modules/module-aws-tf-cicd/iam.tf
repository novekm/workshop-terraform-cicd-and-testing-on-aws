# Instructions: Create resources for IAM

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
# CodeBuild
data "aws_iam_policy_document" "codepipeline_trust_relationship" {
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
# TODO - restrict access
data "aws_iam_policy_document" "codepipeline_policy_restricted_access" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}
resource "aws_iam_policy" "codepipeline_policy_restricted_access" {
  count       = var.create_codepipeline_resources ? 1 : 0
  name        = "${var.project_prefix}-codepipeline-service-role-policy-restricted-access"
  description = "Policy granting AWS CodePipeling restricted access to _____"
  policy      = data.aws_iam_policy_document.codepipeline_policy_restricted_access.json
}

# CodeBuild
data "aws_iam_policy_document" "codebuild_policy_restricted_access" {
  for_each = var.codecommit_repos == null ? {} : var.codecommit_repos
  statement {
    effect  = "Allow"
    actions = ["codecommit:*"]
    resources = [
      "*",
      each.value
    ]
  }

}
resource "aws_iam_policy" "codebuild_policy_restricted_access" {
  count       = var.create_codepipeline_resources ? 1 : 0
  name        = "${var.project_prefix}-codebuild-service-role-policy-restricted-access"
  description = "Policy granting AWS CodePipeling restricted access to _____"
  policy      = data.aws_iam_policy_document.codebuild_policy_restricted_access.json
}


# - IAM Roles -
# CodePipeline
resource "aws_iam_role" "codepipeline_service_role" {
  count              = var.create_codepipeline_resources ? 1 : 0
  name               = "${var.project_prefix}-codepipeline-service-role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_trust_relationship.json
  managed_policy_arns = [

    "arn:aws:iam::aws:policy/AdministratorAccess",
    # "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess",
    "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess",
    "arn:aws:iam::aws:policy/AWSCodeBuildFullAccess",
    "arn:aws:iam::aws:policy/AmazonCloudWatchFullAccess",
    aws_iam_policy.codepipeline_policy_restricted_access.arn,
  ]
}
# CodeBuild
resource "aws_iam_role" "codebuild_service_role" {
  count              = var.create_codebuild_resources ? 1 : 0
  name               = "${var.project_prefix}-codebuild-service-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_trust_relationship.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
    # "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess",
    "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess",
    "arn:aws:iam::aws:policy/AmazonCloudWatchFullAccess",
    aws_iam_policy.codebuild_policy_restricted_access.arn,
  ]
}


