output "node_group_id" {
  description = "EKS node group ID"
  value       = aws_eks_node_group.main.id
}

output "node_group_arn" {
  description = "ARN of the EKS node group"
  value       = aws_eks_node_group.main.arn
}

output "node_group_status" {
  description = "Status of the EKS node group"
  value       = aws_eks_node_group.main.status
}

output "node_group_resources" {
  description = "Resources associated with the node group"
  value       = aws_eks_node_group.main.resources
}

output "launch_template_id" {
  description = "ID of the launch template"
  value       = var.create_launch_template ? aws_launch_template.main[0].id : null
}

output "launch_template_latest_version" {
  description = "Latest version of the launch template"
  value       = var.create_launch_template ? aws_launch_template.main[0].latest_version : null
}
