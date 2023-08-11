resource "aws_ecr_repository" "ecr" {
  for_each             = toset(var.ecr_name)
  name                 = each.key
  image_tag_mutability = var.image_mutability
  encryption_configuration {
    encryption_type = var.encrypt_type
  }
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.tags
}

# I let it loop for the name to create an ECR for each name
# mutability if set to IMMUTABLE means that ImageTagAlreadyExistsException error is returned if you attempt to push an image with a tag that is already in the repository
# Scanning configuration lets it scan for vulnurabilities

# Refrences:
# https://medium.com/@praveenvallepu/amazon-ecr-repository-with-terraform-3e430369900d