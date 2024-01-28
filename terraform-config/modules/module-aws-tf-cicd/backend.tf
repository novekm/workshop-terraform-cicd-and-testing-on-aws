# Instructions: Create resources for S3 Remote Backend (Amazon S3 and DynamoDB)

#  Terraform State S3 Bucket
#  ADD S3 BUCKET FOR REMOTE STATE - USE CONDITIONAL VARIABLE
# count = create_s3_remote_backend ? 1 : 0

# Terraform State Locking
#  ADD DYNAMODB TABLE FOR REMOTE STATE LOCK - USE VARIABLE
# count = create_s3_remote_backend ? 1 : 0


# TODO - ADD S3 DYNAMODB LOCK
