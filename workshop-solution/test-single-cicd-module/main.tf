# Instructions: Place your core Terraform configuration below

# - CodeCommit Repositories -
# CodeCommit Repo - CodeCommit Terraform Module
module "codecommit-module-aws-codecommit" {
  source = "../modules/module-aws-tf-cicd"

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

      repository_name = local.aws_example_production_workload_repository_name
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
      # Source Type can be an S3 bucket, Git repo, or no source. If using a Git repo, the CodeBuild project can pull assets directly from that repo. However, since this CodeBuild project is part of a CodePipeline pipeline, and that pipeline has a source stage that fetches the data from the Git repo already, this would be redundant. When CodePipeline clones the repo, it stores it in the S3 Artifacts bucket, which we can simply reference as the source of the CodeBuild Project. This removes the redundancy. Typically you would only set the source of a CodeBuild Project to be a Git repo is you are NOT using it within a CodePipeline pipeline.

      # You can use CodeBuild and CodeDeploy standalone, or you can use CodePipeline for orchestration. If using CodePipeline to orchestrate these services, you can use the provided 'artifacts bucket' as a centralized location to pass data to CodeBuild or CodeDeploy.
      # ACTUALLY you can set the Source Type as "NO_SOURCE" because with CodePipeline you can pass values from the artifacts S3 bucket to any of the stages with the 'input_artifacts' variable (which in this case correspond to our CodeBuild Projects). In this case, the artifacts bucket is the single source of truth. If CodeBuild doesn't have correct access to that bucket, the builds will fail due to incorrect permissions.

      # A main benefit of CodePipeline is that this artifacts bucket is a centralized location that you can use to easily pass data between any of your stages. This prevents you from having to re-download or re-clone the same data over and over again.

      path_to_build_spec = local.tf_test_path_to_buildspec

    },
    chevkov_module_aws_tf_cicd : {
      name        = local.chevkov_module_aws_tf_cicd_codebuild_project_name
      description = "CodeBuild Project that uses Checkov to test the security of the 'module-aws-tf-cicd' Terraform Module."

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
      name = local.tf_module_validation_module_aws_tf_cicd_codepipeline_pipeline_name

      # name = "tf-module-validation-module-aws-tf-cicd"

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
                BranchName     = "main"
                RepositoryName = local.module_aws_tf_cicd_repository_name
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

              run_order = 1
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

              run_order = 1
            },
          ]
        },

      ]

    },


    # Terraform Deployment Pipeline for 'example-production workload'
    tf_deployment_example_production_workload : {

      name = local.tf_deployment_example_production_workload_codepipeline_pipeline_name
      tags = {
        "Description"         = "Pipeline that validates functionality/security and deploys the Example Production Workload.",
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
                BranchName     = "main"
                RepositoryName = local.module_aws_tf_cicd_repository_name
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

              run_order = 1
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

              run_order = 1
            },
          ]
        },

      ]

    },

  }

}
