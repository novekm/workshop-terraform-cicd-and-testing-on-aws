locals {
  # CodeCommit Repository Names
  module_aws_tf_cicd_repository_name              = "module-aws-tf-cicd"
  aws_devops_core_repository_name                 = "aws-devops-core"
  aws_example_production_workload_repository_name = "example-production-workload"

  # # CodeCommit Repo HTTP Clone URLs
  # module_aws_tf_cicd_clone_url_http = "https://git-codecommit.${data.aws_region.current.name}.amazonaws.com/v1/repos/${local.module_aws_tf_cicd_repository_name}"

  # aws_devops_core_repository_clone_url_http = "https://git-codecommit.${data.aws_region.current.name}.amazonaws.com/v1/repos/${local.aws_devops_core_repository_name}"

  # aws_example_production_workload_repository_clone_url_http = "https://git-codecommit.${data.aws_region.current.name}.amazonaws.com/v1/repos/${local.aws_example_production_workload_repository_name}"


}
