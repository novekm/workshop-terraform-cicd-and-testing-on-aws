# Instructions: Create resources for IAM

# - Trust Relationships -
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
# CodeBuild
data "aws_iam_policy_document" "codebuild_policy_restricted_access" {
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
  count       = var.create_iam_resources ? 1 : 0
  name        = "tf-workshop-codebuild-service-role-policy-restricted-access"
  description = "Policy granting AWS CodePipeling restricted access to _____"
  policy      = data.aws_iam_policy_document.codebuild_policy_restricted_access.json
}


# - IAM Roles -
# CodeBuild
resource "aws_iam_role" "codebuild_service_role" {
  count              = var.create_iam_resources ? 1 : 0
  name               = "tf-workshop-codebuild-service-role"
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


