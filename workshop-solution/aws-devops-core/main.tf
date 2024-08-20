# Instructions: Place your core Terraform Module configuration below
resource "aws_sns_topic" "manual_approval_sns_topic" {
  name = "manual-approval-sns-topic"
}

resource "aws_sns_topic_subscription" "manual_approval_sns_subscription" {
  topic_arn = aws_sns_topic.manual_approval_sns_topic.arn
  protocol  = "email"
  endpoint  = "novekm@amazon.com" # Replace with your email address
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

  # - Create CodeCommit Repos -
  codecommit_repos = {
    # Custom Terraform Module Repo
    module_aws_tf_cicd : {

      repository_name = local.module_aws_tf_cicd_repository_name
      description     = "The repo containing the configuration for the 'module-aws-tf-cicd' Terraform Module."
      default_branch  = "main"
      tags = {
        "ContentType"         = "Terraform Module",
        "PrimaryOwner"        = "Kevon Mayers",
        "PrimaryOwnerTitle"   = "Solutions Architect",
        "SecondaryOwner"      = "Naruto Uzumaki",
        "SecondaryOwnerTitle" = "Hokage",
      }
    },

    # DevOps Core Infrastructure Repo
    aws_devops_core : {

      repository_name = local.aws_devops_core_repository_name
      description     = "The repo containing the configuration for the core DevOps infrastructure."
      default_branch  = "main"
      tags = {
        "ContentType"         = "AWS Infrastructure",
        "Scope"               = "DevOps Services",
        "PrimaryOwner"        = "Kevon Mayers",
        "PrimaryOwnerTitle"   = "Solutions Architect",
        "SecondaryOwner"      = "Naruto Uzumaki",
        "SecondaryOwnerTitle" = "Hokage",
      }
    },

    # Example Production Workload Repo
    example_production_workload : {

      repository_name = local.example_production_workload_repository_name
      description     = "The repo containing the configuration for the core example production workload."
      default_branch  = "main"
      tags = {
        "ContentType"         = "AWS Infrastructure",
        "Scope"               = "Example Production Environment",
        "PrimaryOwner"        = "Kevon Mayers",
        "PrimaryOwnerTitle"   = "Solutions Architect",
        "SecondaryOwner"      = "Naruto Uzumaki",
        "SecondaryOwnerTitle" = "Hokage",
      }
    },
  }

  # - Create CodeBuild Projects -
  codebuild_projects = {
    # Terraform Module 'module'aws-tf-cicd'
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
    module_aws_tf_cicd : {
      name = local.tf_module_validation_module_aws_tf_cicd_codepipeline_pipeline_name

      tags = {
        "Description"         = "Pipeline that validates functionality and security of the module-aws-tf-cicd Terraform Module.",
        "Usage"               = "Terraform Module Validation",
        "PrimaryOwner"        = "Kevon Mayers",
        "PrimaryOwnerTitle"   = "Solutions Architect",
        "SecondaryOwner"      = "Naruto Uzumaki",
        "SecondaryOwnerTitle" = "Hokage",
      }

      stages = [
        # Clone from CodeCommit, store contents in  artifacts S3 Bucket
        {
          name = "Source"
          action = [
            {
              name     = "PullFromCodeCommit"
              category = "Source"
              owner    = "AWS"
              provider = "CodeCommit"
              version  = "1"
              configuration = {
                BranchName           = "main"
                RepositoryName       = local.module_aws_tf_cicd_repository_name
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
    example_production_workload : {

      name = local.tf_deployment_example_production_workload_codepipeline_pipeline_name
      tags = {
        "Description"         = "Pipeline that validates functionality/security and deploys the Example Production Workload.",
        "Usage"               = "Example Production Workload",
        "PrimaryOwner"        = "Kevon Mayers",
        "PrimaryOwnerTitle"   = "Solutions Architect",
        "SecondaryOwner"      = "Naruto Uzumaki",
        "SecondaryOwnerTitle" = "Hokage",
      }

      stages = [
        # Clone from CodeCommit, store contents in  artifacts S3 Bucket
        {
          name = "Source"
          action = [
            {
              name     = "PullFromCodeCommit"
              category = "Source"
              owner    = "AWS"
              provider = "CodeCommit"
              version  = "1"
              configuration = {
                BranchName           = "main"
                RepositoryName       = local.example_production_workload_repository_name
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
              # Store the output of this stage as 'build_checkov_output_artifacts' in the connected Artifacts S3 Bucket
              output_artifacts = ["build_tf_apply_output_artifacts"]

              run_order = 5
            },
          ]
        },

      ]

    },
  }
}

