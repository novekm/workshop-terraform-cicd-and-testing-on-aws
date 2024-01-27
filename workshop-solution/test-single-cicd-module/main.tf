# Instructions: Place your core Terraform configuration below

# - CodeCommit Repositories -
# CodeCommit Repo - CodeCommit Terraform Module
module "codecommit-module-aws-codecommit" {
  source = "../modules/module-aws-tf-cicd"

  codecommit_repos = {
    ModuleAWSCodeCommit : {
      repository_name = "module-aws-codecommit"
      description     = "The repo contains the configuration for the CodeCommit Terraform Module."
      default_branch  = "main"
      tags = {
        "ContentType"         = "Terraform Module",
        "PrimaryOwner"        = "Kevon Mayers",
        "PrimaryOwnerTitle"   = "Solutions Architect",
        "SecondaryOwner"      = "Naruto Uzumaki",
        "SecondaryOwnerTitle" = "Hokage",
      }
    },
  }

  codebuild_projects = {
    CheckovModuleAWSCodeCommit : {
      name        = "Checkov-module-aws-codecommit"
      description = "CodeBuild Project that uses Checkov to test the security of the `module-aws-codecommit` Terraform Module."
      source_type = "CODECOMMIT"
      # source_location    = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/module-aws-codecommit" // make data source
      path_to_build_spec = "./buildspec/checkov-buildspec.yml"

    },
  }

}
