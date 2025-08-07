# Instructions: Create private ECR repository to host images (ie. checkov) needed for the build process below

# Create Checkov ECR repository
resource "aws_ecr_repository" "checkov_image" {
  name                 = var.checkov_ecr_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true # This will allow us to delete all images before deleting the repository
}

# Pull and push latest image using null_resource
resource "null_resource" "docker_push" {
  triggers = {
    # This will only trigger on repository creation or if the repository URL or tracked tag changes
    repository_url = local.checkov_image
    image_tag      = local.checkov_tag
  }

  provisioner "local-exec" {
    command = <<EOF
      # Login to ECR
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${local.checkov_image}

      # Pull latest image from DockerHub
      docker pull ${local.dockerhub_checkov_image}

      # Tag the image for ECR
      docker tag ${local.dockerhub_checkov_image}:${local.checkov_tag} ${local.checkov_image}:${local.checkov_tag}

      # Push to ECR
      docker push ${local.checkov_image}:${local.checkov_tag}
    EOF
  }

  depends_on = [aws_ecr_repository.checkov_image]
}
