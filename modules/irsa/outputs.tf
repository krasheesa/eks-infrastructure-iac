output "role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.this.name
}

output "policy_arn" {
  description = "ARN of the IAM policy (if created)"
  value       = var.policy_json != null ? aws_iam_policy.this[0].arn : null
}
