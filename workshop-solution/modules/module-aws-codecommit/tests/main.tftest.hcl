# Instructions: Create basic tests for CodeCommit Module

# Configure the AWS
provider "aws" {
  region = "us-east-1"
}


# Define variables to be used in tests. You can overwrite these varibles by definig an additional variables block within the run block for your tests
variables {
  project_prefix = "this_is_a_project_prefix_and_it_is_way_too_long_and_will_cause_a_failure"
  codecommit_repos = {
    # CodeCommit Repo for 'module-aws-tf-cicd' Terraform Module
    TestRepo1 : {
      repo_name      = "test-repo-1"
      description    = "First test repo"
      default_branch = "main"
      tags = {
        "ContentType"         = "Terraform Module",
        "PrimaryOwner"        = "Sasuke Uchiha",
        "PrimaryOwnerTitle"   = "Village Protector",
        "SecondaryOwner"      = "Naruto Uzumaki",
        "SecondaryOwnerTitle" = "Hokage",

      }
    },
    TestRepo2 : {
      repo_name      = "test-repo-2"
      description    = "Second test repo"
      default_branch = "main"
      tags = {
        "ContentType"         = "Core AWS Infrastructure",
        "PrimaryOwner"        = "Sasuke Uchiha",
        "PrimaryOwnerTitle"   = "Village Protector",
        "SecondaryOwner"      = "Naruto Uzumaki",
        "SecondaryOwnerTitle" = "Hokage",

      }
    },

  }
}

# - Unit Tests -
run "input_validation" {
  command = plan

  # Invalid values
  variables {
    # project_prefix that is longer than 40 characters
    project_prefix = "this_is_a_project_prefix_and_it_is_way_too_long_and_will_cause_a_failure_and_variable_changed"

  }
  # Check for intentional failure of defined variables
  expect_failures = [
    var.project_prefix,

  ]
}

# - End-to-end Tests -
run "e2e_test" {
  command = apply

  # Using global variables defined above since additional variables block is not defined here

  # Assertions
  assert {
    condition     = aws_codecommit_repository.codecommit_repo[0].name == "test-repo-1"
    error_message = "Test CodeCommit Repo 1 name didn't match the expected value."
  }
  assert {
    condition     = aws_codecommit_repository.codecommit_repo[1].name == "test-repo-2"
    error_message = "Test CodeCommit Repo 2 name didn't match the expected value."
  }

}
