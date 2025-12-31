data "aws_iam_policy_document" "assume_role_with_oidc" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:sub"
      values   = var.service_account_subjects
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_with_oidc.json

  tags = merge(
    {
      Name = var.role_name
    },
    var.tags
  )
}

resource "aws_iam_policy" "this" {
  count = var.policy_json != null ? 1 : 0

  name        = "${var.role_name}-policy"
  description = var.policy_description
  policy      = var.policy_json

  tags = merge(
    {
      Name = "${var.role_name}-policy"
    },
    var.tags
  )
}

resource "aws_iam_role_policy_attachment" "custom" {
  count = var.policy_json != null ? 1 : 0

  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this[0].arn
}

resource "aws_iam_role_policy_attachment" "managed" {
  count = length(var.managed_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = var.managed_policy_arns[count.index]
}
