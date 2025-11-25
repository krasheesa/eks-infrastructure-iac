output "role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.irsa.arn
}

output "role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.irsa.name
}

output "role_id" {
  description = "ID of the IAM role"
  value       = aws_iam_role.irsa.id
}

output "custom_policy_arn" {
  description = "ARN of the custom policy"
  value       = var.create_custom_policy ? aws_iam_policy.custom[0].arn : null
}

output "custom_policy_id" {
  description = "ID of the custom policy"
  value       = var.create_custom_policy ? aws_iam_policy.custom[0].id : null
}
