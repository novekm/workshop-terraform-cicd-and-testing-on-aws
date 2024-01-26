# # # TODO - UPDATE THIS FILE

# # resource "aws_codepipeline" "codepipeline" {
# #   name     = "tf-test-pipeline"
# #   role_arn = aws_iam_role.codepipeline_role.arn

# #   artifact_store {
# #     location = aws_s3_bucket.codepipeline_bucket.bucket
# #     type     = "S3"

# #     encryption_key {
# #       id   = data.aws_kms_alias.s3kmskey.arn
# #       type = "KMS"
# #     }
# #   }

# #   stage {
# #     name = "Source"

# #     action {
# #       name     = "Source"
# #       category = "Source"
# #       owner    = "AWS"
# #       provider = "CodeStarSourceConnection"
# #       # provider         = "CodeStarSourceConnection" // only used if you need to use external git provider
# #       version          = "1"
# #       output_artifacts = ["source_output"]

# #       configuration = {
# #         ConnectionArn    = aws_codestarconnections_connection.example.arn
# #         FullRepositoryId = "my-organization/example"
# #         BranchName       = "main"
# #       }
# #     }
# #   }

# #   stage {
# #     name = "Build"

# #     action {
# #       name             = "Build"
# #       category         = "Build"
# #       owner            = "AWS"
# #       provider         = "CodeBuild"
# #       input_artifacts  = ["source_output"]
# #       output_artifacts = ["build_output"]
# #       version          = "1"

# #       configuration = {
# #         ProjectName = "test"
# #       }
# #     }
# #   }

# #   stage {
# #     name = "Deploy"

# #     action {
# #       name            = "Deploy"
# #       category        = "Deploy"
# #       owner           = "AWS"
# #       provider        = "CloudFormation"
# #       input_artifacts = ["build_output"]
# #       version         = "1"

# #       configuration = {
# #         ActionMode     = "REPLACE_ON_FAILURE"
# #         Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
# #         OutputFileName = "CreateStackOutput.json"
# #         StackName      = "MyStack"
# #         TemplatePath   = "build_output::sam-templated.yaml"
# #       }
# #     }
# #   }
# # }

# # # Only needed if connecting to external git provider
# # # resource "aws_codestarconnections_connection" "example" {
# # #   name          = "example-connection"
# # #   provider_type = "GitHub" // valid values are "BitBucket", "GitHub", or "GitHubEnterpriseServer"
# # # }


# # resource "aws_iam_role" "codepipeline_role" {
# #   name               = "test-role"
# #   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# # }

# # data "aws_iam_policy_document" "codepipeline_policy" {
# #   statement {
# #     effect = "Allow"

# #     actions = [
# #       "s3:GetObject",
# #       "s3:GetObjectVersion",
# #       "s3:GetBucketVersioning",
# #       "s3:PutObjectAcl",
# #       "s3:PutObject",
# #     ]

# #     resources = [
# #       aws_s3_bucket.codepipeline_bucket.arn,
# #       "${aws_s3_bucket.codepipeline_bucket.arn}/*"
# #     ]
# #   }

# #   statement {
# #     effect    = "Allow"
# #     actions   = ["codestar-connections:UseConnection"]
# #     resources = [aws_codestarconnections_connection.example.arn]
# #   }

# #   statement {
# #     effect = "Allow"

# #     actions = [
# #       "codebuild:BatchGetBuilds",
# #       "codebuild:StartBuild",
# #     ]

# #     resources = ["*"]
# #   }
# # }

# # resource "aws_iam_role_policy" "codepipeline_policy" {
# #   name   = "codepipeline_policy"
# #   role   = aws_iam_role.codepipeline_role.id
# #   policy = data.aws_iam_policy_document.codepipeline_policy.json
# # }

# # data "aws_kms_alias" "s3kmskey" {
# #   name = "alias/myKmsKey"
# # }


# #  NEW
# resource "aws_codepipeline" "this" {

#   name     = var.project_name
#   role_arn = aws_iam_role.this.arn

#   artifact_store {
#     type     = var.artifacts_store_type
#     location = var.s3_bucket_id
#   }

#   stage {
#     name = "Source"
#     action {
#       name             = "Source"
#       category         = "Source"
#       owner            = "AWS"
#       provider         = var.source_provider
#       version          = "1"
#       output_artifacts = [var.output_artifacts]
#       configuration = {
#         FullRepositoryId     = var.full_repository_id
#         BranchName           = var.branch_name
#         ConnectionArn        = var.codestar_connector_credentials
#         OutputArtifactFormat = var.output_artifact_format
#       }
#     }
#   }

#   stage {
#     name = "Apply" #"Plan"
#     action {
#       name            = "Build"
#       category        = "Build"
#       provider        = "CodeBuild"
#       version         = "1"
#       owner           = "AWS"
#       input_artifacts = [var.input_artifacts]
#       configuration = {
#         ProjectName = var.project_name
#       }
#     }
#   }

#   # stage {
#   #   name = "Approve"

#   #   action {
#   #     name            = "Approval"
#   #     category        = "Approval"
#   #     owner           = "AWS"
#   #     provider        = "Manual"
#   #     version         = "1"
#   #     input_artifacts = [var.input_artifacts]
#   #     configuration = {
#   #       #NotificationArn = var.approve_sns_arn
#   #       CustomData = var.approve_comment
#   #       #ExternalEntityLink = var.approve_url
#   #     }
#   #   }
#   # }

#   # stage {
#   #   name = "Deploy"
#   #   action {
#   #     name            = "Deploy"
#   #     category        = "Build"
#   #     provider        = "CodeBuild"
#   #     version         = "1"
#   #     owner           = "AWS"
#   #     input_artifacts = [var.input_artifacts]
#   #     configuration = {
#   #       ProjectName = var.project_name
#   #     }
#   #   }
#   # }

# }
