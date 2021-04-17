resource "aws_iam_instance_profile" "api_instance_profile" {
  name = "api_instance_profile"
  role = aws_iam_role.api_instance_role.name
}

resource "aws_iam_role_policy" "api_instance_role_policy" {
  name   = "api_policy"
  role   = aws_iam_role.api_instance_role.id
  policy = data.aws_iam_policy_document.api_instance_role_policy_document.json
}

resource "aws_iam_role" "api_instance_role" {
  name               = "api_instance_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.api_assume_role_policy.json
}

data "aws_iam_policy_document" "api_instance_role_policy_document" {
  statement {
    sid    = "AllowRDS"
    effect = "Allow"
    actions = [
      "rds:*"
    ]
    resources = ["arn:aws:rds:ap-south-1:${data.aws_caller_identity.current.account_id}:db:petclinic"]
  }
}

data "aws_iam_policy_document" "api_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_caller_identity" "current" {}
