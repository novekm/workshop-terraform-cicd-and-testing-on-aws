# Instructions: Create CodeBuild Project Resource

resource "aws_codebuild_project" "codebuild" {

  name          = var.project_name
  description   = var.project_description
  build_timeout = var.codebuild_build_timeout
  service_role  = aws_iam_role.codebuild_service_role.arn

  environment {
    compute_type = var.codebuild_env_compute_type
    image        = var.codebuild_env_image
    type         = var.codebuild_env_type
    # image_pull_credentials_type = "CODEBUILD"

  }

  source {
    type            = var.codebuild_source_type
    location        = var.codebuild_source_location
    git_clone_depth = var.codebuild_source_clone_depth
    buildspec       = var.path_to_build_spec != null ? var.path_to_build_spec : var.build_spec


    # git_submodules_config {
    #   fetch_submodules = true
    # }

  }

  source_version = var.source_version


  artifacts {
    type = "NO_ARTIFACTS"
  }

  # cache {
  #   type     = "S3"
  #   location = aws_s3_bucket.example.bucket
  # }



  # logs_config {
  #   cloudwatch_logs {
  #     group_name  = "log-group"
  #     stream_name = "log-stream"
  #   }

  #   s3_logs {
  #     status   = "ENABLED"
  #     location = "${aws_s3_bucket.example.id}/build-log"
  #   }
  # }



  tags = var.tags
}


