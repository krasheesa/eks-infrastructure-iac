variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "enable_cloudwatch_logs" {
  description = "Enable CloudWatch logs policy for nodes"
  type        = bool
  default     = false
}

variable "enable_ssm" {
  description = "Enable SSM policy for nodes (for session manager access)"
  type        = bool
  default     = false
}
