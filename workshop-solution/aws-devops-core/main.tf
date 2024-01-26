# Instructions: Place your core Terraform configuration below

# - CodeCommit Repositories -
# CodeCommit Repo - CodeCommit Terraform Module
module "codecommit-module-aws-codecommit" {
  source = "../modules/module-aws-codecommit"

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

}
# CodeCommit Repo - CodeBuild Terraform Module
module "codecommit-module-aws-codebuild" {
  source = "../modules/module-aws-codecommit"

  repository_name = "module-aws-codebuild"
  description     = "The repo contains the configuration for the CodeBuild Terraform Module."
  default_branch  = "main"
  tags = {
    "ContentType"         = "Terraform Module",
    "PrimaryOwner"        = "Kevon Mayers",
    "PrimaryOwnerTitle"   = "Solutions Architect",
    "SecondaryOwner"      = "Naruto Uzumaki",
    "SecondaryOwnerTitle" = "Hokage",
  }


}
# CodeCommit Repo - CodePipeline Terraform Module
module "codecommit-module-aws-codepipeline" {
  source = "../modules/module-aws-codecommit"

  repository_name = "module-aws-codepipeline"
  description     = "The repo contains the configuration for the CodePipeline Terraform Module."
  default_branch  = "main"
  tags = {
    "ContentType"         = "Terraform Module",
    "PrimaryOwner"        = "Kevon Mayers",
    "PrimaryOwnerTitle"   = "Solutions Architect",
    "SecondaryOwner"      = "Naruto Uzumaki",
    "SecondaryOwnerTitle" = "Hokage",
  }

}
# CodeCommit Repo - AWS DevOps Core
module "codecommit-aws-devops-core" {
  source = "../modules/module-aws-codecommit"

  repository_name = "aws-devops-core"
  description     = "The repo contains the configuration for the core DevOps Infrastructure."
  default_branch  = "main"
  tags = {
    "ContentType"         = "AWS Infrastructure",
    "Impact"              = "DevOps"
    "PrimaryOwner"        = "Kevon Mayers",
    "PrimaryOwnerTitle"   = "Solutions Architect",
    "SecondaryOwner"      = "Naruto Uzumaki",
    "SecondaryOwnerTitle" = "Hokage",
  }

}
# CodeCommit Repo - AWS Infrastructure Core
module "codecommit-aws-infra-core" {
  source = "../modules/module-aws-codecommit"

  repository_name = "aws-infra-core"
  description     = "The repo contains the configuration for the core AWS Infrastructure"
  default_branch  = "main"
  tags = {
    "ContentType"         = "AWS Infrastructure",
    "Impact"              = "Core Workload Deployments"
    "PrimaryOwner"        = "Kevon Mayers",
    "PrimaryOwnerTitle"   = "Solutions Architect",
    "SecondaryOwner"      = "Naruto Uzumaki",
    "SecondaryOwnerTitle" = "Hokage",
  }

}


# - CodeBuild Projects -
module "project-tf-test-framework" {
  source = "../modules/module-aws-codebuild"

  # image source will be "hashicorp/terraform"

}

module "project-checkov-security-tests" {
  source = "../modules/module-aws-codebuild"

  # image source will be "bridgecrew/checkov"


}


# - CodePipeline Pipelines -
module "tf-module-validation-pipeline" {
  source = "../modules/module-aws-codepipeline"


}

module "tf-deployment-pipeline" {
  source = "../modules/module-aws-codepipeline"


}





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
module "tf-module-validation-pipeline" {
  source = "../modules/module-aws-codepipeline"
}





# Create Terraform Deployment Pipeline (TODO)
module "tf-deployment-pipeline" {
  source = "../modules/module-aws-codepipeline"
}
