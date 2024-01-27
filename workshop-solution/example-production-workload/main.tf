# Instructions: Place your core Terraform configuration below

# - Trust Relationships -
data "aws_iam_policy_document" "ec2_trust_relationship" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# - IAM Role -
resource "aws_iam_role" "example" {
  name                = "tf-workshop-example-production-resource"
  assume_role_policy  = data.aws_iam_policy_document.ec2e_trust_relationship.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]

  force_detach_policies = true
}

# - S3 Bucket -
resource "aws_s3_bucket" "example" {
  bucket_prefix = "tf-workshop-example-production-resource"
}


