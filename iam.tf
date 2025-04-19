data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  user_policy     = var.repository_policy != null ? jsondecode(var.repository_policy) : { Version = "2012-10-17", Statement = [] }
  user_statements = try(local.user_policy.Statement, [])
  required_statement = [
    {
      Sid    = "LambdaECRImageRetrievalPolicy"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = [
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer",
        "ecr:SetRepositoryPolicy",
        "ecr:DeleteRepositoryPolicy",
        "ecr:GetRepositoryPolicy"
      ]
      Condition = {
        StringLike = {
          "aws:sourceArn" = "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:*"
        }
      }
    }
  ]
  merged_policy = {
    Version   = "2012-10-17"
    Statement = concat(local.user_statements, local.required_statement)
  }
}

resource "aws_ecr_repository_policy" "main" {
  repository = aws_ecr_repository.main.name
  policy     = jsonencode(local.merged_policy)
}
