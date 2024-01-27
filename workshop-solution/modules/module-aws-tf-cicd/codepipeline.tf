# Instructions: Dynamically create an AWS CodePipeline pipeline below

# Instructions: Create CodePipeline Resource

# TODO - FIX THIS FILE, MIMIC WHAT IS IN THE CODEBUILD.TF FILE. ALSO ADD VARIABLE
resource "aws_codepipeline" "codepipeline" {
  for_each = var.codepipeline_pipelines == null ? {} : var.codepipeline_pipelines

  name          = each.value.name
  pipeline_type = each.value.pipeline_type
  role_arn      = var.codepipeline_service_role_arn != null ? var.codepipeline_service_role_arn : aws_iam_role.codepipeline_service_role[0].arn

  artifact_store {
    # location = aws_s3_bucket.codepipeline_artifacts_bucket[0].id
    location = each.value.existing_s3_bucket_name != null ? each.value.existing_s3_bucket_name : aws_s3_bucket.codepipeline_artifacts_buckets[each.key].id
    type     = "S3"

  }


  dynamic "stage" {
    for_each = [for s in each.value.stages : {
      # for_each = [for s in var.stages : {
      name   = s.name
      action = s.action
    } if(lookup(s, "enabled", true))]

    # for_each = local.pipeline_stages

    content {
      name = stage.value.name
      dynamic "action" {
        for_each = stage.value.action
        content {
          name             = action.value["name"]
          owner            = action.value["owner"]
          version          = action.value["version"]
          category         = action.value["category"]
          provider         = action.value["provider"]
          input_artifacts  = lookup(action.value, "input_artifacts", [])
          output_artifacts = lookup(action.value, "output_artifacts", [])
          configuration    = lookup(action.value, "configuration", {})
          role_arn         = lookup(action.value, "role_arn", null)
          run_order        = lookup(action.value, "run_order", null)
          region           = lookup(action.value, "region", data.aws_region.current.name)
        }
      }
    }
  }

  tags = each.value.tags

  # dynamic "stage" {
  #   # for_each = var.codepipeline_pipelines == null ? {} : var.codepipeline_pipelines
  #   for_each = local.pipelines_and_their_stages

  #   for_each = var.codepipeline_pipelines.stages == null ? {} : var.codepipeline_pipelines.stages
  #   each.value.stages = tf_module_validation_module_aws_tf_cicd.stages

  #   for_each = [for s in var.stages : {
  #     name   = s.name
  #     action = s.action
  #   } if(lookup(s, "enabled", true))]

  #   content {
  #     name = "Source"
  #     action {
  #       name             = "PullFromCodeCommit"
  #       category         = "Source"
  #       owner            = "AWS"
  #       provider         = "CodeCommit"
  #       version          = "1"

  #       output_artifacts = ["source_output"]
  #       output_artifacts = ["build_output"]

  #       configuration = {
  #         RepositoryName = var.repository_name
  #         BranchName     = var.branch_name
  #       }
  #     }
  #   }





  #   # action {
  #   #   name             = "PullFromCodeCommit"
  #   #   category         = "Source"
  #   #   owner            = "AWS"
  #   #   provider         = "CodeCommit"
  #   #   version          = "1"
  #   #   output_artifacts = ["source_output"]

  #   #   configuration = {
  #   #     RepositoryName = var.repository_name
  #   #     BranchName     = var.branch_name
  #   #   }
  #   # }
  # }

}

