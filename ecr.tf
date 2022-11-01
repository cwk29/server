data "aws_ecr_repository" "service" {
  name = "express"
}

resource "aws_ecr_repository_policy" "policy" {
  repository = data.aws_ecr_repository.service.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid = "AllowPushPull"
      Effect = "Allow"
      Action = [
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:CompleteLayerUpload",
        "ecr:GetDownloadUrlForLayer",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ]
      Principal = {
        AWS = flatten([
          data.aws_caller_identity.current.account_id,
          var.trusted_accounts,
        ])
      }
    }]
  })
}
