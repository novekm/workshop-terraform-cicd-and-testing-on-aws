# Instructions: Create resources for EventBridge

# Create TF Workshop Custom Event Bus
resource "random_string" "tf_workshop_event_bus" {
  length  = 4
  special = false
  upper   = false
}

resource "aws_cloudwatch_event_bus" "tf_workshop_event_bus" {
  name = "${var.project_prefix}-event_bus-${random_string.tf_workshop_event_bus.result}"
  tags = merge(
    {
      "Name" = "${var.project_prefix}-event_bus-${random_string.tf_workshop_event_bus.result}"
    },
    var.tags,
  )
}

# Create Rule to forward S3 events from Default Event Bus to TF Workshop Event Bus
resource "aws_cloudwatch_event_rule" "default_event_bus_to_tf_workshop_event_bus" {
  for_each    = var.codepipeline_pipelines == null ? {} : var.codepipeline_pipelines
  name        = "${each.value.name}-default_event_bus_to_${var.project_prefix}-event_bus"
  description = "Send S3 git-remote events from default event bus to TF Workshop event bus."
  role_arn    = aws_iam_role.eventbridge_forward_events.arn

  event_pattern = jsonencode({
    source      = ["aws.s3"]
    detail-type = ["Object Created"]
    detail = {
      bucket = {
        name = [aws_s3_bucket.git_remote_s3_buckets[each.value.git_source].id]
      }
      object = {
        key = [{ suffix = { equals-ignore-case = ".zip" }}]
      }
    }
  })

  tags = merge(
    var.tags,
    {
      "Name" = "${var.project_prefix}-default_event_bus_to_${var.project_prefix}-event_bus"
    },
  )
}

# Create Event Bus Target to send S3 events from Default Event Bus to TF Workshop Event Bus
resource "aws_cloudwatch_event_target" "default_event_bus_to_tf_workshop_event_bus" {
  for_each  = var.codepipeline_pipelines == null ? {} : var.codepipeline_pipelines
  rule      = aws_cloudwatch_event_rule.default_event_bus_to_tf_workshop_event_bus[each.key].name
  target_id = aws_cloudwatch_event_bus.tf_workshop_event_bus.name
  arn       = aws_cloudwatch_event_bus.tf_workshop_event_bus.arn
  role_arn  = aws_iam_role.eventbridge_forward_events.arn
}

# Create rule to invoke CodePipelines when S3 git-remote events are received on TF Workshop Event Bus
resource "aws_cloudwatch_event_rule" "invoke_codepipeline" {
  for_each       = var.codepipeline_pipelines == null ? {} : var.codepipeline_pipelines
  name           = "invoke-${each.value.name}-codepipeline"
  event_bus_name = aws_cloudwatch_event_bus.tf_workshop_event_bus.name
  description    = "Invoke CodePipeline when S3 git-remote object is uploaded."
  role_arn       = aws_iam_role.eventbridge_trigger_codepipeline.arn

  event_pattern = jsonencode({
    source      = ["aws.s3"]
    detail-type = ["Object Created"]
    detail = {
      bucket = {
        name = [aws_s3_bucket.git_remote_s3_buckets[each.value.git_source].id]
      }
      object = {
        key = [{ suffix = { equals-ignore-case = ".zip" }}]
      }
    }
  })

  tags = merge(
    var.tags,
    {
      "Name" = each.value.name
    },
  )
}

# Create Event Bus Target to invoke CodePipeline when S3 events are received on TF Workshop Event Bus
resource "aws_cloudwatch_event_target" "invoke_codepipeline" {
  for_each       = var.codepipeline_pipelines == null ? {} : var.codepipeline_pipelines
  rule           = aws_cloudwatch_event_rule.invoke_codepipeline[each.key].name
  target_id      = aws_codepipeline.codepipeline[each.key].name
  arn            = aws_codepipeline.codepipeline[each.key].arn
  role_arn       = aws_iam_role.eventbridge_trigger_codepipeline.arn
  event_bus_name = aws_cloudwatch_event_bus.tf_workshop_event_bus.name
}
