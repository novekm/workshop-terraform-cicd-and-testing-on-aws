locals {
  # -- CodeCommit --
  # CodeCommit Repository Names
  module_aws_tf_cicd_repository_name              = "module-aws-tf-cicd"
  aws_devops_core_repository_name                 = "aws-devops-core"
  aws_example_production_workload_repository_name = "example-production-workload"


  # -- CodeBuild --
  # - CodeBuild Project Names -
  # Terraform Test Framework Builds (Test Functionality)
  tf_test_module_aws_tf_cicd_codebuild_project_name = "TerraformTest-module-aws-tf-cicd"
  chevkov_module_aws_tf_cicd_codebuild_project_name = "Checkov-module-aws-tf-cicd"

  # Checkov Builds (Test Security)
  tf_test_aws_devops_core_codebuild_project_name = "TerraformTest-aws-devops-core"
  chevkov_aws_devops_core_codebuild_project_name = "Checkov-aws-devops-core"

  tf_test_example_production_workload_codebuild_project_name = "TerraformTest-example-production-workload"
  chevkov_example_production_workload_codebuild_project_name = "Checkov-example-production-workload"

  # TF Apply Builds (Provision Resources)
  tf_apply_example_production_workload_codebuild_project_name = "TFApply-example-production-workload"

  # - CodeBuild buildspec paths -
  tf_test_path_to_buildspec  = "./buildspec/tf-test-buildspec.yml"  # Terraform Test Framework (Test Functionality)
  checkov_path_to_buildspec  = "./buildspec/checkov-buildspec.yml"  # Checkov (Test Security)
  tf_apply_path_to_buildspec = "./buildspec/tf-apply-buildspec.yml" # TF Apply (Provision Resources)


  # -- CodePipeline --
  # - CodePipeline Pipeline Names -
  tf_module_validation_module_aws_tf_cicd_codepipeline_pipeline_name   = "tf-module-validation-module-aws-tf-cicd"
  tf_deployment_example_production_workload_codepipeline_pipeline_name = "tf-deploy-example-production-workload"


}
