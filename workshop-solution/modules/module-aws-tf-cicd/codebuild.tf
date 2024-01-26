resource "aws_codebuild_project" "codebuild_tf_test" {
  count = var.create_codebuild_resources ? 1 : 0

  name          = "${var.project_prefix}-codebuild-tf-test"
  description   = "CodeBuild build that uses Terraform Test Framework to validate functionality."
  build_timeout = var.codebuild_build_timeout
  service_role  = aws_iam_role.codebuild_service_role[0].arn

  environment {
    compute_type                = var.codebuild_env_compute_type
    image                       = var.codebuild_env_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

  }

  dynamic "source" {
    for_each = var.codebuild_projects
    content {
      # type = source.value["namespace"]
      # name = setting.value["name"]
      # value = setting.value["value"]

      # type = source.value["namespace"]
      # location = source.value["name"]
      # git_clone_depth = source.value["value"]

      type            = lookup(source.value, "namespace", "123")
      location        = lookup(source.value, "name", "123")
      git_clone_depth = lookup(source.value, "value", "123")
    }
  }

  source {
    type            = var.codebuild_source_type
    location        = ""
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "master"


  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.example.bucket
  }



  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.example.id}/build-log"
    }
  }



  vpc_config {
    vpc_id = aws_vpc.example.id

    subnets = [
      aws_subnet.example1.id,
      aws_subnet.example2.id,
    ]

    security_group_ids = [
      aws_security_group.example1.id,
      aws_security_group.example2.id,
    ]
  }

  tags = {
    Environment = "Test"
  }
}


