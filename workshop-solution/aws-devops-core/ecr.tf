# Instructions: Create private ECR repository to host images (ie. checkov) needed for the build process below

# Create Checkov ECR repository
resource "aws_ecr_repository" "checkov_image" {
  name                 = var.checkov_ecr_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Pull and push latest image using null_resource
resource "null_resource" "docker_push" {
  triggers = {
    # This will only trigger on repository creation or if the repository URL changes
    repository_url = aws_ecr_repository.checkov_image.repository_url
  }

  provisioner "local-exec" {
    command = <<EOF
      # Login to ECR
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.checkov_image.repository_url}
      
      # Pull latest image from DockerHub
      docker pull ${local.checkov_image}
      
      # Tag the image for ECR
      docker tag ${local.checkov_image}:${local.checkov_tag} ${aws_ecr_repository.checkov_image.repository_url}:${local.checkov_tag}
      
      # Push to ECR
      docker push ${aws_ecr_repository.checkov_image.repository_url}:${local.checkov_tag}
    EOF
  }

  depends_on = [aws_ecr_repository.checkov_image]
}