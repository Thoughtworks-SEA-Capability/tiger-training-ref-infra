locals {
  tags = {
    stack = "bootstrap",
    team = "tiger",
    environment = "global"
  }
}
# Ideally we should set this up with role + federated web identity using github tokens.
resource "aws_iam_user" "github-push-to-ecr" {
  name               = "github-actions-push-ecr"
  tags = local.tags
}

# Needs to be created manually
#resource "aws_iam_access_key" "github-push-to-ecr" {
#  user = aws_iam_user.github-push-to-ecr.name
#}

data "aws_iam_policy_document" "push-to-ecr"{
  version = "2012-10-17"
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
    effect = "Allow"
  }
}

resource "aws_iam_user_policy" "push-to-ecr" {
  name = "github-push-to-ecr"
  policy = data.aws_iam_policy_document.push-to-ecr.json
  user = aws_iam_user.github-push-to-ecr.name
}

resource "aws_ecr_repository" "sample-ap-a" {
  name = "infra-training-sample-app-a"
}

resource "aws_ecr_repository" "test-pod" {
  name = "infra-training-test-pod"
}

# IAM User for Circle CI
# Ideally we should set this up with role + federated web identity using github tokens.
resource "aws_iam_user" "circle_ci_admin" {
  name               = "circle-ci-admin"
  tags = local.tags
}

# Needs to be created manually
#resource "aws_iam_access_key" "github-push-to-ecr" {
#  user = aws_iam_user.github-push-to-ecr.name
#}

data "aws_iam_policy_document" "circle_ci_admin"{
  version = "2012-10-17"
  statement {
    actions = [
      "*",
    ]
    resources = ["*"]
    effect = "Allow"
  }
}

resource "aws_iam_user_policy" "circle_ci_admin" {
  name = "circle-ci-agent"
  policy = data.aws_iam_policy_document.circle_ci_admin.json
  user = aws_iam_user.circle_ci_admin.name
}

