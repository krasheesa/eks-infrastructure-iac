output "alb_security_group_id" {
  description = "Security group ID for the ALB"
  value       = aws_security_group.alb.id
}

output "alb_security_group_name" {
  description = "Security group name for the ALB"
  value       = aws_security_group.alb.name
}
