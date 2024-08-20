# Instructions: Place your outputs below
# AWS DevOps Core
output "aws_devops_core_s3_bucket_name" {
  value = module.module-aws-tf-cicd.tf_state_s3_buckets_names["aws_devops_core"]
}
output "aws_devops_core_ddb_table_name" {
  value = module.module-aws-tf-cicd.tf_state_ddb_table_names["aws_devops_core"]
}

# Example Production Workload
output "example_production_workload_s3_bucket_name" {
  value = module.module-aws-tf-cicd.tf_state_s3_buckets_names["example_production_workload"]
}
output "example_production_workload_ddb_table_name" {
  value = module.module-aws-tf-cicd.tf_state_ddb_table_names["example_production_workload"]
}
