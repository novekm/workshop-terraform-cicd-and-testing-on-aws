# Instructions: Place your core Terraform Module configuration below

resource "aws_sns_topic" "manual_approval_sns_topic" {
  name = "manual-approval-sns-topic"
}

resource "aws_sns_topic_subscription" "manual_approval_sns_subscription" {
  topic_arn = aws_sns_topic.manual_approval_sns_topic.arn
  protocol  = "email"
  endpoint  = "your@email.com" # Replace with your email address
}

module "module-aws-tf-cicd" {
  source = "../modules/module-aws-tf-cicd"

  # - Create S3 Remote State Resources -
  tf_remote_state_resource_configs = {
    # Custom Terraform Module Repo
    aws_devops_core : {
      prefix = "aws-devops-core"
    },
    example_production_workload : {
      prefix = "example-prod-workload"
    },
  }

  # - Create Git Remote S3 Buckets -
  git_remote_s3_buckets = {
    # Custom Terraform Module Repo
    module_aws_tf_cicd = {
      bucket_name = local.module_aws_tf_cicd_bucket_name
      description = "S3 bucket for git-remote-s3 containing the module-aws-tf-cicd Terraform Module."
      versioning  = true
      tags = {
        "ContentType"         = "Terraform Module"
        "PrimaryOwner"        = "Kevon Mayers"
        "PrimaryOwnerTitle"   = "Solutions Architect"
        "SecondaryOwner"      = "Naruto Uzumaki"
        "SecondaryOwnerTitle" = "Hokage"
      }
    },

    # DevOps Core Infrastructure Repo
    aws_devops_core = {
      bucket_name = local.aws_devops_core_bucket_name
      description = "S3 bucket for git-remote-s3 containing the core DevOps infrastructure."
      versioning  = true
      tags = {
        "ContentType"         = "AWS Infrastructure"
        "Scope"               = "DevOps Services"
        "PrimaryOwner"        = "Kevon Mayers"
        "PrimaryOwnerTitle"   = "Solutions Architect"
        "SecondaryOwner"      = "Naruto Uzumaki"
        "SecondaryOwnerTitle" = "Hokage"
      }
    },

    # Example Production Workload Repo
    example_production_workload = {
      bucket_name = local.example_production_workload_bucket_name
      description = "S3 bucket for git-remote-s3 containing the example production workload."
      versioning  = true
      tags = {
        "ContentType"         = "AWS Infrastructure"
        "Scope"               = "Example Production Environment"
        "PrimaryOwner"        = "Kevon Mayers"
        "PrimaryOwnerTitle"   = "Solutions Architect"
        "SecondaryOwner"      = "Naruto Uzumaki"
        "SecondaryOwnerTitle" = "Hokage"
      }
    },
  }

  # - Create CodeBuild Projects -
  codebuild_projects = {
    # Terraform Module 'module-aws-tf-cicd'
    tf_test_module_aws_tf_cicd : {
      name        = local.tf_test_module_aws_tf_cicd_codebuild_project_name
      description = "CodeBuild Project that uses the Terraform Test Framework to test the functionality of the 'module-aws-tf-cicd' Terraform Module."

      path_to_build_spec = local.tf_test_path_to_buildspec
    },
    chevkov_module_aws_tf_cicd : {
      name        = local.chevkov_module_aws_tf_cicd_codebuild_project_name
      description = "CodeBuild Project that uses Checkov to test the security of the 'module-aws-tf-cicd' Terraform Module."
      env_image   = local.checkov_image

      path_to_build_spec = local.checkov_path_to_buildspec
    },

    # DevOps Core Infrastructure 'aws-devops-core'
    tf_test_aws_devops_core : {
      name        = local.tf_test_aws_devops_core_codebuild_project_name
      description = "CodeBuild Project that uses the Terraform Test Framework to test the functionality of the DevOps Core Infrastructure."

      path_to_build_spec = local.tf_test_path_to_buildspec
    },
    chevkov_aws_devops_core : {
      name        = local.chevkov_aws_devops_core_codebuild_project_name
      description = "CodeBuild Project that uses Checkov to test the security of the DevOps Core Infrastructure."
      env_image   = local.checkov_image

      path_to_build_spec = local.checkov_path_to_buildspec
    },

    # Example Production Workload 'example-production-workload'
    tf_test_example_production_workload : {
      name        = local.tf_test_example_production_workload_codebuild_project_name
      description = "CodeBuild Project that uses the Terraform Test Framework to test the functionality of the Example Production Workload."

      path_to_build_spec = local.tf_test_path_to_buildspec
    },
    chevkov_example_production_workload : {
      name        = local.chevkov_example_production_workload_codebuild_project_name
      description = "CodeBuild Project that uses Checkov to test the security of the Example Production Workload."
      env_image   = local.checkov_image

      path_to_build_spec = local.checkov_path_to_buildspec
    },
    tf_apply_example_production_workload : {
      name        = local.tf_apply_example_production_workload_codebuild_project_name
      description = "CodeBuild Project that uses Checkov to test the security of the Example Production Workload."

      path_to_build_spec = local.tf_apply_path_to_buildspec
    },
  }

  codepipeline_pipelines = {

    # Terraform Module Validation Pipeline for 'module-aws-tf-cicd' Terraform Module
    tf_module_validation_module_aws_tf_cicd : {
      name       = local.tf_module_validation_module_aws_tf_cicd_codepipeline_pipeline_name
      git_source = "module_aws_tf_cicd"

      tags = {
        "Description"         = "Pipeline that validates functionality and security of the module-aws-tf-cicd Terraform Module.",
        "Usage"               = "Terraform Module Validation",
        "PrimaryOwner"        = "Kevon Mayers",
        "PrimaryOwnerTitle"   = "Solutions Architect",
        "SecondaryOwner"      = "Naruto Uzumaki",
        "SecondaryOwnerTitle" = "Hokage",
      }

      stages = [
        # Pull from S3 git remote, store contents in artifacts S3 Bucket
        {
          name = "Source"
          action = [
            {
              name     = "PullFromS3"
              category = "Source"
              owner    = "AWS"
              provider = "S3"
              version  = "1"
              configuration = {
                S3Bucket             = module.module-aws-tf-cicd.git_remote_s3_bucket_names["module_aws_tf_cicd"]
                S3ObjectKey          = "s3-repo/refs/heads/main/repo.zip"
                PollForSourceChanges = false
              }
              input_artifacts = []
              #  Store the output of this stage as 'source_output_artifacts' in connected the Artifacts S3 Bucket
              output_artifacts = ["source_output_artifacts"]
              run_order        = 1
            },
          ]
        },

        # Run Terraform Test Framework
        {
          name = "Build_TF_Test"
          action = [
            {
              name     = "TerraformTest"
              category = "Build"
              owner    = "AWS"
              provider = "CodeBuild"
              version  = "1"
              configuration = {
                # Reference existing CodeBuild Project
                ProjectName = local.tf_test_module_aws_tf_cicd_codebuild_project_name
              }
              # Use the 'source_output_artifacts' contents from the Artifacts S3 Bucket
              input_artifacts = ["source_output_artifacts"]
              # Store the output of this stage as 'build_tf_test_output_artifacts' in the connected Artifacts S3 Bucket
              output_artifacts = ["build_tf_test_output_artifacts"]

              run_order = 2
            },
          ]
        },

        # Run Checkov
        {
          name = "Build_Checkov"
          action = [
            {
              name     = "Checkov"
              category = "Build"
              owner    = "AWS"
              provider = "CodeBuild"
              version  = "1"
              configuration = {
                # Reference existing CodeBuild Project
                ProjectName = local.chevkov_module_aws_tf_cicd_codebuild_project_name
              }
              # Use the 'source_output_artifacts' contents from the Artifacts S3 Bucket
              input_artifacts = ["source_output_artifacts"]
              # Store the output of this stage as 'build_checkov_output_artifacts' in the connected Artifacts S3 Bucket
              output_artifacts = ["build_checkov_output_artifacts"]

              run_order = 3
            },
          ]
        },
      ]

    },


    # Terraform Deployment Pipeline for 'example-production workload'
    tf_deployment_example_production_workload : {

      name       = local.tf_deployment_example_production_workload_codepipeline_pipeline_name
      git_source = "example_production_workload"

      tags = {
        "Description"         = "Pipeline that validates functionality/security and deploys the Example Production Workload.",
        "Usage"               = "Example Production Workload",
        "PrimaryOwner"        = "Kevon Mayers",
        "PrimaryOwnerTitle"   = "Solutions Architect",
        "SecondaryOwner"      = "Naruto Uzumaki",
        "SecondaryOwnerTitle" = "Hokage",
      }

      stages = [
        # Pull from S3 git remote, store contents in artifacts S3 Bucket
        {
          name = "Source"
          action = [
            {
              name     = "PullFromS3"
              category = "Source"
              owner    = "AWS"
              provider = "S3"
              version  = "1"
              configuration = {
                S3Bucket             = module.module-aws-tf-cicd.git_remote_s3_bucket_names["example_production_workload"]
                S3ObjectKey          = "s3-repo/refs/heads/main/repo.zip"
                PollForSourceChanges = false
              }
              input_artifacts = []
              #  Store the output of this stage as 'source_output_artifacts' in connected the Artifacts S3 Bucket
              output_artifacts = ["source_output_artifacts"]
              run_order        = 1
            },
          ]
        },

        # Run Terraform Test Framework
        {
          name = "Build_TF_Test"
          action = [
            {
              name     = "TerraformTest"
              category = "Build"
              owner    = "AWS"
              provider = "CodeBuild"
              version  = "1"
              configuration = {
                # Reference existing CodeBuild Project
                ProjectName = local.tf_test_example_production_workload_codebuild_project_name
              }
              # Use the 'source_output_artifacts' contents from the Artifacts S3 Bucket
              input_artifacts = ["source_output_artifacts"]
              # Store the output of this stage as 'build_tf_test_output_artifacts' in the connected Artifacts S3 Bucket
              output_artifacts = ["build_tf_test_output_artifacts"]

              run_order = 2
            },
          ]
        },

        # Run Checkov
        {
          name = "Build_Checkov"
          action = [
            {
              name     = "Checkov"
              category = "Build"
              owner    = "AWS"
              provider = "CodeBuild"
              version  = "1"
              configuration = {
                # Reference existing CodeBuild Project
                ProjectName = local.chevkov_example_production_workload_codebuild_project_name
              }
              # Use the 'source_output_artifacts' contents from the Artifacts S3 Bucket
              input_artifacts = ["source_output_artifacts"]
              # Store the output of this stage as 'build_checkov_output_artifacts' in the connected Artifacts S3 Bucket
              output_artifacts = ["build_checkov_output_artifacts"]

              run_order = 3
            },
          ]
        },

        # Add Manual Approval
        {
          name = "Manual_Approval"
          action = [
            {
              name     = "ManualApprovalAction"
              category = "Approval"
              owner    = "AWS"
              provider = "Manual"
              version  = "1"
              configuration = {
                CustomData      = "Please approve this deployment."
                NotificationArn = aws_sns_topic.manual_approval_sns_topic.arn
              }

              input_artifacts  = []
              output_artifacts = []

              run_order = 4
            },
          ]
        },


        # Apply Terraform
        {
          name = "Apply"
          action = [
            {
              name     = "TerraformApply"
              category = "Build"
              owner    = "AWS"
              provider = "CodeBuild"
              version  = "1"
              configuration = {
                # Reference existing CodeBuild Project
                ProjectName = local.tf_apply_example_production_workload_codebuild_project_name
              }
              # Use the 'source_output_artifacts' contents from the Artifacts S3 Bucket
              input_artifacts = ["source_output_artifacts"]
              # Store the output of this stage as 'build_tf_test_output_artifacts' in the connected Artifacts S3 Bucket
              output_artifacts = ["build_tf_apply_output_artifacts"]

              run_order = 5
            },
          ]
        },

      ]

    },
  }

  # Ensure we've pushed the docker images before we configure the CodeBuild Projects
  depends_on = [null_resource.docker_push]
}
