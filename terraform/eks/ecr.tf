resource "aws_ecr_repository" "this" {
  name                 = "store-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}