# Instructions: Create basic tests

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Global Testing Variables - Define variables to be used in all tests here. You can overwrite these varibles by definig an additional variables block within the 'run' block for your tests
variables {
  # - Test Git Remote S3 Buckets -
  git_remote_s3_buckets = {
    # Test Module 1
    test_module_1 : {
      bucket_name = "test-module-1"
      description = "Test Module 1."
      versioning  = true
      tags = {
        "ContentType" = "Test Module",
      }
    },
  }

  # - Test CodeBuild Projects -
  codebuild_projects = {
    # Test Module 1
    tf_test_test_module_1 : {
      name        = "TerraformTest-test-module-1"
      description = "Test Module 1 - Terraform Test"
      build_spec  = <<-EOF
        # Terraform Test
        version: 0.1
        phases:
          pre_build:
            commands:
              - terraform init
              - terraform validate

          build:
            commands:
              - terraform test
      EOF
    },
    chevkov_test_module_1 : {
      name        = "Checkov-test-module-1"
      description = "Test Module 1 - Checkov"
      build_spec  = <<-EOF
        # Checkov
        version: 0.1
        phases:
          pre_build:
            commands:
              - echo pre_build starting

          build:
            commands:
              - build starting
              - checkov -s -d ./ > checkov.result.txt

      EOF
    },
  }

  # - Test CodePipeline pipelines -
  codepipeline_pipelines = {
    #  Module Validation Pipelines
    # Terraform Module Validation Pipeline for 'test-module-1' Terraform Module
    tf_module_validation_test_module_1 : {
      name = "tf-test-1"
      git_source = "test_module_1"
      tags = {
        "Description" = "Test Module 1.",
      }

      stages = [
        # Clone from S3, store contents in  artifacts S3 Bucket
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
                S3Bucket = "git-module-aws-tf-cicd-<YOUR-AWS-ACCOUNT-ID>"
                S3ObjectKey = "archive.zip"
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
                ProjectName = "TerraformTest-test-module-1"
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
                ProjectName = "Checkov-test-module-1"
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

  # Test Remote State Resources
  tf_remote_state_resource_configs = {
    # Custom Terraform Module Repo
    test_tf_remote_state_config_1 : {
      prefix = "test-tf-remote-state-config-1"
    },
  }
}

# - Unit Tests -
run "input_validation" {
  command = plan

  # Intentional invalid values to test functionality. These variables overwrite the above variables (helpful for testing).
  variables {
    # Intentional project_prefix that is longer than max of 40 characters (overwrite of above global variable)
    project_prefix = "this_is_a_project_prefix_and_it_is_over_40_characters_and_will_cause_a_failure"

    # Git Remote S3 Buckets - Intentional bucket name that is longer than max of 63 characters
    git_remote_s3_buckets = {
      # Test Module 1
      test_module_1 : {
        bucket_name = "valid-bucket-name"
        description = "Test Module 1."
        versioning  = true
        tags = {
          "ContentType" = "Test Module",
        },
      },
    }

    # CodeBuild - Intentional project name that is longer than max of 40 characters
    codebuild_projects = {
      # Test Module 1
      tf_test_test_module_1 : {
        name        = "this_is_a_project_name_and_it_is_longer_than_40_characters"
        description = "Test Module 1 - Terraform Test"
        build_spec  = <<-EOF
          # Terraform Test
          version: 0.1
          phases:
            pre_build:
              commands:
                - terraform init
                - terraform validate

            build:
              commands:
                - terraform test
        EOF
      },
    }

    # CodePipeline - Intentional pipeline name that is longer than max of 40 characters
    codepipeline_pipelines = {

      # Terraform Module Validation Pipeline for 'test-module-1' Terraform Module
      tf_module_validation_test_module_1 : {
        name = "this_is_a_pipeline_name_and_it_is_longer_than_40_characters_and_will_fail"
        git_source = "nonexistent_bucket"
        tags = {
          "Description" = "Test Module 1.",

        }

        stages = [
          # Clone from S3, store contents in  artifacts S3 Bucket
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
                  S3Bucket = "git-module-aws-tf-cicd-<YOUR-AWS-ACCOUNT-ID>"
                  S3ObjectKey = "archive.zip"
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
                  ProjectName = "TerraformTest-test-module-1"
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
                  ProjectName = "Checkov-test-module-1"
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

    # Terraform Remote State Resources - Intentional prefix that is longer than max of 40 characters
    tf_remote_state_resource_configs = {
      # Custom Terraform Module Repo
      test_tf_remote_state_config_1 : {
        prefix = "this_is_a_prefix_name_and_it_is_longer_than_40_characters_and_will_fail"
      },
    }
  }

  # Check for intentional failure of variables defined above. We expect these to fail since we intentionally provided values that do not conform to the validation rules defined in the module's variable.tf file.
  expect_failures = [
    var.project_prefix,
    var.codebuild_projects,
    var.codepipeline_pipelines,
    var.tf_remote_state_resource_configs,
  ]
}

# - End-to-end Tests -
run "integration_test" {
  command = apply

  # Using global variables defined above since additional variables block is not defined here

  # Assertions
  # Git Remote S3 Buckets - Ensure buckets have correct names after creation
  assert {
    condition     = startswith(aws_s3_bucket.git_remote_s3_buckets["test_module_1"].id, "test-module-1")
    error_message = "The Git Remote S3 Bucket name (${aws_s3_bucket.git_remote_s3_buckets["test_module_1"].id}) did not start with the expected value (test-module-1)."
  }

  # CodeBuild - Ensure projects have correct names after creation
  assert {
    condition     = aws_codebuild_project.codebuild["tf_test_test_module_1"].name == "TerraformTest-test-module-1"
    error_message = "The CodeBuild Project name (${aws_codebuild_project.codebuild["tf_test_test_module_1"].name}) didn't match the expected value (TerraformTest-test-module-1)."
  }

  # CodePipeline - Ensure pipelines have correct names after creation
  assert {
    condition     = aws_codepipeline.codepipeline["tf_module_validation_test_module_1"].name == "tf-test-1"
    error_message = "The CodePipeline pipeline name (${aws_codepipeline.codepipeline["tf_module_validation_test_module_1"].name}) didn't match the expected value (tf-test-1)."
  }

  # S3 Remote State - Ensure S3 Remote State buckets have correct names after creation
  assert {
    condition     = startswith(aws_s3_bucket.tf_remote_state_s3_buckets["test_tf_remote_state_config_1"].id, "test-tf-remote-state-config-1")
    error_message = "The S3 Remote State Bucket name (${aws_s3_bucket.tf_remote_state_s3_buckets["test_tf_remote_state_config_1"].id}) did not start with the expected value (test-tf-remote-state-config-1)."
  }
}
