resource "aws_ecr_repository" "app" {
  name                 = "8byte-devops-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "8byte-devops-app"
  }
}