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
      name               = "TerraformTest-module-aws-tf-cicd"
      description        = "CodeBuild Project that uses the Terraform Test Framework to test the functionality of the 'module-aws-tf-cicd' Terraform Module."
      source_type        = "CODECOMMIT"
      source_location    = "https://git-codecommit.${data.aws_region.current.name}.amazonaws.com/v1/repos/${local.module_aws_tf_cicd_repository_name}"
      path_to_build_spec = "./buildspec/checkov-buildspec.yml"

    },
    chevkov_module_aws_tf_cicd : {
      name               = "Checkov-module-aws-tf-cicd"
      description        = "CodeBuild Project that uses Checkov to test the security of the 'module-aws-tf-cicd' Terraform Module."
      source_type        = "CODECOMMIT"
      source_location    = "https://git-codecommit.${data.aws_region.current.name}.amazonaws.com/v1/repos/${local.module_aws_tf_cicd_repository_name}"
      path_to_build_spec = "./buildspec/checkov-buildspec.yml"

    },

    # DevOps Core Infrastructure 'aws-devops-core'
    tf_test_aws_devops_core : {
      name               = "TerraformTest-aws-devops-core"
      description        = "CodeBuild Project that uses the Terraform Test Framework to test the functionality of the DevOps Core Infrastructure."
      source_type        = "CODECOMMIT"
      source_location    = "https://git-codecommit.${data.aws_region.current.name}.amazonaws.com/v1/repos/${local.aws_devops_core_repository_name}"
      path_to_build_spec = "./buildspec/checkov-buildspec.yml"

    },
    chevkov_aws_devops_core : {
      name               = "Checkov-aws-devops-core"
      description        = "CodeBuild Project that uses Checkov to test the security of the DevOps Core Infrastructure."
      source_type        = "CODECOMMIT"
      source_location    = "https://git-codecommit.${data.aws_region.current.name}.amazonaws.com/v1/repos/${local.aws_devops_core_repository_name}"
      path_to_build_spec = "./buildspec/checkov-buildspec.yml"

    },

    # Example Production Workload 'example-production-workload'
    tf_test_example_production_workload : {
      name               = "TerraformTest-example-production-workload"
      description        = "CodeBuild Project that uses the Terraform Test Framework to test the functionality of the Example Production Workload."
      source_type        = "CODECOMMIT"
      source_location    = "https://git-codecommit.${data.aws_region.current.name}.amazonaws.com/v1/repos/${local.aws_example_production_workload_repository_name}"
      path_to_build_spec = "./buildspec/checkov-buildspec.yml"

    },
    chevkov_example_production_workload : {
      name               = "Checkov-example-production-workload"
      description        = "CodeBuild Project that uses Checkov to test the security of the Example Production Workload."
      source_type        = "CODECOMMIT"
      source_location    = "https://git-codecommit.${data.aws_region.current.name}.amazonaws.com/v1/repos/${local.aws_example_production_workload_repository_name}"
      path_to_build_spec = "./buildspec/checkov-buildspec.yml"

    },

  }

}
