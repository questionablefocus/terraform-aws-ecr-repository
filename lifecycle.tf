data "aws_ecr_lifecycle_policy_document" "main" {
  rule {
    priority    = 1
    description = "Keep last 10 images"
    selection {
      tag_status   = "any"
      count_type   = "imageCountMoreThan"
      count_number = 10
    }
    action {
      type = "expire"
    }
  }
}

resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.name
  policy     = data.aws_ecr_lifecycle_policy_document.main.json
}
