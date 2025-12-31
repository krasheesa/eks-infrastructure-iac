variable "role_name" {
  description = "Name of the IAM role for service account"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider for EKS"
  type        = string
}

variable "oidc_provider_url" {
  description = "URL of the OIDC provider for EKS (without https://)"
  type        = string
}

variable "service_account_subjects" {
  description = "List of service account subjects (system:serviceaccount:namespace:serviceaccount-name)"
  type        = list(string)
}

variable "policy_json" {
  description = "JSON policy document for the IAM role"
  type        = string
  default     = null
}

variable "policy_description" {
  description = "Description of the IAM policy"
  type        = string
  default     = "IAM policy for Kubernetes service account"
}

variable "managed_policy_arns" {
  description = "List of managed policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
