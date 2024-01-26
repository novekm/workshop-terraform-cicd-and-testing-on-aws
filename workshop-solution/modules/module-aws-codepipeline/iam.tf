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
  count       = var.create_iam_resources ? 1 : 0
  name        = "tf-codepipeline-service-role-policy-restricted-access"
  description = "Policy granting AWS CodePipeling restricted access to _____"
  policy      = data.aws_iam_policy_document.codepipeline_policy_restricted_access.json
}


# - IAM Roles -
# CodePipeline
resource "aws_iam_role" "codepipeline_service_role" {
  count              = var.create_iam_resources ? 1 : 0
  name               = "tf-workshop-codepipeline-service-role"
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



