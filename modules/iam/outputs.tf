output "cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role"
  value       = aws_iam_role.cluster.arn
}

output "cluster_role_name" {
  description = "Name of the EKS cluster IAM role"
  value       = aws_iam_role.cluster.name
}

output "nodes_role_arn" {
  description = "ARN of the EKS node IAM role"
  value       = aws_iam_role.nodes.arn
}

output "nodes_role_name" {
  description = "Name of the EKS node IAM role"
  value       = aws_iam_role.nodes.name
}
