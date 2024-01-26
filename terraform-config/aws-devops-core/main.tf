# Instructions: Place your core Terraform configuration below

# Create CodeCommit Repositiories
module "codecommit-repos" {
  source = "../modules/module-aws-tf-cicd"

  project_prefix = "devops_core"
  # project_prefix = "this_is_a_project_prefix_and_it_is_way_too_long_and_will_cause_a_failure"

  codecommit_repos = {
    # CodeCommit Repo for 'module-aws-tf-cicd' Terraform Module
    AWS_TF_CICD_Module_Repo : {
      repo_name      = "module-aws-tf-cicd"
      description    = "The repo contains the config files for a Terraform module that can dynamically create AWS CodeCommit Repositories, AWS CodePipelines (and related necessary services) on AWS."
      default_branch = "main"
      tags = {
        "ContentType"         = "Terraform Module",
        "PrimaryOwner"        = "Kevon Mayers",
        "PrimaryOwnerTitle"   = "Solutions Architect",
        "SecondaryOwner"      = "Naruto Uzumaki",
        "SecondaryOwnerTitle" = "Hokage",

      }
    },
    # CodeCommit Repo for core AWS infrastructure for the account
    AWS_Core_Infra_Repo : {
      repo_name      = "module-aws-tf-cicd"
      description    = "The repo contains the core AWS infrastructure for this account"
      default_branch = "main"
      tags = {
        "ContentType"         = "Core AWS Infrastructure",
        "PrimaryOwner"        = "Kevon Mayers",
        "PrimaryOwnerTitle"   = "Solutions Architect",
        "SecondaryOwner"      = "Naruto Uzumaki",
        "SecondaryOwnerTitle" = "Hokage",
      }
    },

  }
}



# Create Terraform Module Validation Pipeline (TODO)





# Create Terraform Deployment Pipeline (TODO)
