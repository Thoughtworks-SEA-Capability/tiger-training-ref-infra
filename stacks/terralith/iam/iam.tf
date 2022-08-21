variable "name" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume-eks-admin" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [format("arn:aws:iam::%s:root",data.aws_caller_identity.current.account_id)]
    }
  }
}

resource "aws_iam_role" "eks-admin" {
  name = "${var.name}-eks-admin"
  description = "Role to assume to administer the cluster"
  assume_role_policy = data.aws_iam_policy_document.assume-eks-admin.json
}

output "eks_admin_arn" {
  value = aws_iam_role.eks-admin.id
}