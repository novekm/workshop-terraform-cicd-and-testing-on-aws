# Instructions: Create resources for IAM

# - Trust Relationships -
# CodePipeline Trust Relationship
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


# IAM Roles
resource "aws_iam_role" "codepipeline_codecommit_access" {
  # count               = var.create_codecommit_repo ? 1 : 0
  # count = var.create_codecommit_repo ? 1 : 0
  # name                = "${var.amplify_codecommit_role_name}-${var.app_name}"
  name                = "${var.project_prefix}-codepipeline_codecommit_access_role"
  assume_role_policy  = data.aws_iam_policy_document.codepipeline_trust_relationship.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"]
}

# Amplify Trust Relationship
