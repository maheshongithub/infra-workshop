resource "aws_iam_instance_profile" "frontend_instance_profile" {
  name = "frontend_instance_profile"
  role = aws_iam_role.frontend_instance_role.name
}

//resource "aws_iam_role_policy" "frontend_instance_role_policy" {
//  name   = "frontend_policy"
//  role   = aws_iam_role.frontend_instance_role.id
//  policy = data.aws_iam_policy_document.frontend_instance_role_policy_document.json
//}

resource "aws_iam_role" "frontend_instance_role" {
  name               = "frontend_instance_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.frontend_assume_role_policy.json
}

//data "aws_iam_policy_document" "frontend_instance_role_policy_document" {}

data "aws_iam_policy_document" "frontend_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
