# Instructions: Place your core Terraform configuration below

# Create CodeCommit Repository
module "codecommit-repos" {
  source = "../modules/module-aws-tf-cicd"

  project_prefix = "prod_workload_1"

  codecommit_repos = {
    # CodeCommit Repo for 'module-aws-tf-cicd' Terraform Module
    ProdWorkload1Repo : {
      repo_name      = "prod-workload-1"
      description    = "The repo contains the config files for a Terraform module that can dynamically create AWS CodeCommit Repositories, AWS CodePipelines (and related necessary services) on AWS."
      default_branch = "main"
      tags = {
        "ContentType"         = "Terraform Core Infrastructure",
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
