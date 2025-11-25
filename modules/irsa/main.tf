data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.kubernetes_namespace}:${var.kubernetes_service_account}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:aud"
      values   = [var.oidc_audience]
    }
  }
}

resource "aws_iam_role" "irsa" {
  name_prefix        = var.role_name_prefix != "" ? var.role_name_prefix : "${var.kubernetes_service_account}-"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  description        = var.role_description

  max_session_duration = var.max_session_duration

  tags = merge(
    var.tags,
    {
      Name                                            = var.role_name_prefix != "" ? "${var.role_name_prefix}${var.kubernetes_service_account}" : var.kubernetes_service_account
      "eks.amazonaws.com/role-name"                   = var.kubernetes_service_account
      "kubernetes.io/service-account/name"            = var.kubernetes_service_account
      "kubernetes.io/service-account/namespace"       = var.kubernetes_namespace
    }
  )
}

resource "aws_iam_role_policy_attachment" "managed_policies" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.irsa.name
  policy_arn = each.value
}

resource "aws_iam_policy" "custom" {
  count = var.create_custom_policy ? 1 : 0

  name_prefix = "${var.kubernetes_service_account}-policy-"
  description = "Custom policy for ${var.kubernetes_service_account}"
  policy      = var.custom_policy_json

  tags = merge(
    var.tags,
    {
      Name = "${var.kubernetes_service_account}-policy"
    }
  )
}

resource "aws_iam_role_policy_attachment" "custom" {
  count = var.create_custom_policy ? 1 : 0

  role       = aws_iam_role.irsa.name
  policy_arn = aws_iam_policy.custom[0].arn
}

# Optional: Create inline policies
resource "aws_iam_role_policy" "inline" {
  for_each = var.inline_policies

  name   = each.key
  role   = aws_iam_role.irsa.name
  policy = each.value
}
