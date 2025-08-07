# Instructions: Place your locals below

locals {
  # -- Git Remote S3 --
  # S3 Bucket Names for git-remote-s3
  module_aws_tf_cicd_bucket_name          = "module-aws-tf-cicd"
  aws_devops_core_bucket_name             = "aws-devops-core"
  example_production_workload_bucket_name = "example-prod-workload"


  # -- CodeBuild --
  # - CodeBuild Project Names -
  # 'module-aws-tf-cicd' Build Projects
  tf_test_module_aws_tf_cicd_codebuild_project_name = "TerraformTest-module-aws-tf-cicd"
  chevkov_module_aws_tf_cicd_codebuild_project_name = "Checkov-module-aws-tf-cicd"
  # 'aws-devops-core' Build Projects
  tf_test_aws_devops_core_codebuild_project_name = "TerraformTest-aws-devops-core"
  chevkov_aws_devops_core_codebuild_project_name = "Checkov-aws-devops-core"
  # 'example-production-workload' Build Projects
  tf_test_example_production_workload_codebuild_project_name  = "TerraformTest-example-prod-workload"
  chevkov_example_production_workload_codebuild_project_name  = "Checkov-example-prod-workload"
  tf_apply_example_production_workload_codebuild_project_name = "TFApply-example-prod-workload"


  # - CodeBuild buildspec paths -
  tf_test_path_to_buildspec  = "./buildspec/tf-test-buildspec.yml"  # Terraform Test Framework (Test Functionality)
  checkov_path_to_buildspec  = "./buildspec/checkov-buildspec.yml"  # Checkov (Test Security)
  tf_apply_path_to_buildspec = "./buildspec/tf-apply-buildspec.yml" # TF Apply (Provision Resources)


  # -- CodePipeline --
  # - CodePipeline Pipeline Names -
  tf_module_validation_module_aws_tf_cicd_codepipeline_pipeline_name   = "module-aws-tf-cicd"
  tf_deployment_example_production_workload_codepipeline_pipeline_name = "example-prod-workload"

  # Images
  checkov_image           = aws_ecr_repository.checkov_image.repository_url
  dockerhub_checkov_image = "bridgecrew/checkov"
  checkov_tag             = "latest"
}

