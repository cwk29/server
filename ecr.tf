resource "aws_ecr_repository" "repo" {
  name                 = "express"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository_policy" "policy" {
  repository = aws_ecr_repository.repo.name
  policy = jsonencode({
    Statement = [{
      Sid = "AllowCrossAccountAccess"
      Action = [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:DescribeImages",
        "ecr:DescribeRepositories",
        "ecr:GetAuthorizationToken",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:ListImages",
      ]
      Effect = "Allow"
      Principal = {
        AWS = flatten([
          data.aws_caller_identity.current.account_id,
          var.trusted_accounts,
        ])
      }
    }]
    Version = "2012-10-17"
  })
}
