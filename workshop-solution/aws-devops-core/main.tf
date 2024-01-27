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
module "codecommit-example-production-workload" {
  source = "../modules/module-aws-codecommit"

  repository_name = "example-production-workload"
  description     = "The repo contains the configuration for the example production resources."
  default_branch  = "main"
  tags = {
    "ContentType"         = "Example Production resources",
    "Impact"              = "Example Production"
    "PrimaryOwner"        = "Kevon Mayers",
    "PrimaryOwnerTitle"   = "Solutions Architect",
    "SecondaryOwner"      = "Naruto Uzumaki",
    "SecondaryOwnerTitle" = "Hokage",
  }

}


# - CodeBuild Projects -
# CodeCommit Module Repo
module "codebuild-tf-test-module-aws-codecommit" {
  source = "../modules/module-aws-codebuild"

  project_name              = "TerraformTest-module-aws-codecommit"
  project_description       = "CodeBuild Project that uses the Terraform Test Framework to test the functionality of the `module-aws-codecommit` Terraform Module."
  codebuild_source_type     = "CODECOMMIT"
  codebuild_source_location = module.codecommit-module-aws-codecommit.clone_url_http
  path_to_build_spec        = "./buildspec/tf-test-buildspec.yml"

}
module "codebuild-checkov-module-aws-codecommit" {
  source = "../modules/module-aws-codebuild"

  project_name              = "Checkov-module-aws-codecommit"
  project_description       = "CodeBuild Project that uses Checkov to test the security of the `module-aws-codecommit` Terraform Module."
  codebuild_source_type     = "CODECOMMIT"
  codebuild_source_location = module.codecommit-module-aws-codecommit.clone_url_http
  path_to_build_spec        = "./buildspec/checkov-buildspec.yml"


}

# CodeBuild Module Repo
module "codebuild-tf-test-module-aws-codebuild" {
  source = "../modules/module-aws-codebuild"

  project_name              = "TerraformTest-module-aws-codebuild"
  project_description       = "CodeBuild Project that uses the Terraform Test Framework to test the functionality of the `module-aws-codebuild` Terraform Module."
  codebuild_source_type     = "CODECOMMIT"
  codebuild_source_location = module.codecommit-module-aws-codebuild.clone_url_http
  path_to_build_spec        = "./buildspec/tf-test-buildspec.yml"

}
module "codebuild-checkov-module-aws-codebuild" {
  source = "../modules/module-aws-codebuild"

  project_name              = "Checkov-module-aws-codebuild"
  project_description       = "CodeBuild Project that uses Checkov to test the security of the `module-aws-codebuild` Terraform Module."
  codebuild_source_type     = "CODECOMMIT"
  codebuild_source_location = module.codecommit-module-aws-codebuild.clone_url_http
  path_to_build_spec        = "./buildspec/checkov-buildspec.yml"

}


# CodePipeline Module Repo
module "codebuild-tf-test-module-aws-codepipeline" {
  source = "../modules/module-aws-codebuild"

  project_name              = "TerraformTest-module-aws-codepipeline"
  project_description       = "CodeBuild Project that uses the Terraform Test Framework to test the functionality of the `module-aws-codepipeline` Terraform Module."
  codebuild_source_type     = "CODECOMMIT"
  codebuild_source_location = module.codecommit-module-aws-codepipeline.clone_url_http
  path_to_build_spec        = "./buildspec/tf-test-buildspec.yml"

}
module "codebuild-checkov-module-aws-codepipeline" {
  source = "../modules/module-aws-codebuild"

  project_name              = "Checkov-module-aws-codepipeline"
  project_description       = "CodeBuild Project that uses Checkov to test the security of the `module-aws-codepipeline` Terraform Module."
  codebuild_source_type     = "CODECOMMIT"
  codebuild_source_location = module.codecommit-module-aws-codepipeline.clone_url_http
  path_to_build_spec        = "./buildspec/checkov-buildspec.yml"

}


# AWS DevOps Core Repo
module "codebuild-tf-test-aws-devops-core" {
  source = "../modules/module-aws-codebuild"

  project_name              = "TerraformTest-aws-devops-core"
  project_description       = "CodeBuild Project that uses the Terraform Test Framework to test the functionality of the `aws-devops-core` Terraform configuration."
  codebuild_source_type     = "CODECOMMIT"
  codebuild_source_location = module.codecommit-aws-devops-core.clone_url_http
  path_to_build_spec        = "./buildspec/tf-test-buildspec.yml"

}
module "codebuild-checkov-aws-devops-core" {
  source = "../modules/module-aws-codebuild"

  project_name              = "Checkov-aws-devops-core"
  project_description       = "CodeBuild Project that uses Checkov to test the security of the `aws-devops-core` Terraform configuration."
  codebuild_source_type     = "CODECOMMIT"
  codebuild_source_location = module.codecommit-aws-devops-core.clone_url_http
  path_to_build_spec        = "./buildspec/checkov-buildspec.yml"

}


# Example Production Workload Repo
module "codebuild-tf-test-example-production-workload" {
  source = "../modules/module-aws-codebuild"

  project_name              = "TerraformTest-example-production-workload"
  project_description       = "CodeBuild Project that uses the Terraform Test Framework to test the functionality of the `example-production-workload` Terraform configuration."
  codebuild_source_type     = "CODECOMMIT"
  codebuild_source_location = module.codecommit-example-production-workload.clone_url_http
  path_to_build_spec        = "./buildspec/tf-test-buildspec.yml"

}
module "codebuild-checkov-example-production-workload" {
  source = "../modules/module-aws-codebuild"

  project_name              = "Checkov-example-production-workload"
  project_description       = "CodeBuild Project that uses Checkov to test the security of the `example-production-workload` Terraform configuration."
  codebuild_source_type     = "CODECOMMIT"
  codebuild_source_location = module.codecommit-example-production-workload.clone_url_http
  path_to_build_spec        = "./buildspec/checkov-buildspec.yml"

}







# module "project-checkov-security-tests" {

#   # image source will be "bridgecrew/checkov"


# }


# # - CodePipeline Pipelines -
# module "tf-module-validation-pipeline" {
#   source = "../modules/module-aws-codepipeline"


# }

# module "tf-deployment-pipeline" {
#   source = "../modules/module-aws-codepipeline"


# }
