# Instructions: Create resources for IAM

resource "random_string" "codebuild_service_role" {
  length  = 2
  special = false
}


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
    effect    = "Allow"
    actions   = ["codecommit:*"]
    resources = ["*"]
  }

}
resource "aws_iam_policy" "codebuild_policy_restricted_access" {
  count       = var.create_iam_resources ? 1 : 0
  name        = "tf-workshop-codebuild-service-role-policy-restricted-access-${random_string.codebuild_service_role.result}"
  description = "Policy granting AWS CodePipeling restricted access to _____"
  policy      = data.aws_iam_policy_document.codebuild_policy_restricted_access.json
}


# - IAM Roles -
# CodeBuild
resource "aws_iam_role" "codebuild_service_role" {
  count              = var.create_iam_resources ? 1 : 0
  name               = "tf-workshop-codebuild-service-role-${random_string.codebuild_service_role.result}"
  assume_role_policy = data.aws_iam_policy_document.codebuild_trust_relationship.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
    aws_iam_policy.codebuild_policy_restricted_access[0].arn,
  ]

  force_detach_policies = true
}


