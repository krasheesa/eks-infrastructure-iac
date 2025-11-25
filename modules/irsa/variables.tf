variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider for the EKS cluster"
  type        = string
}

variable "oidc_provider_url" {
  description = "URL of the OIDC provider for the EKS cluster"
  type        = string
}

variable "kubernetes_namespace" {
  description = "Kubernetes namespace for the service account"
  type        = string
}

variable "kubernetes_service_account" {
  description = "Kubernetes service account name"
  type        = string
}

variable "role_name_prefix" {
  description = "Prefix for the IAM role name"
  type        = string
  default     = ""
}

variable "role_description" {
  description = "Description of the IAM role"
  type        = string
  default     = "IRSA role for EKS service account"
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds"
  type        = number
  default     = 3600
}

variable "oidc_audience" {
  description = "Audience for OIDC provider"
  type        = string
  default     = "sts.amazonaws.com"
}

variable "managed_policy_arns" {
  description = "List of managed policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

variable "create_custom_policy" {
  description = "Whether to create a custom policy"
  type        = bool
  default     = false
}

variable "custom_policy_json" {
  description = "JSON policy document for custom policy"
  type        = string
  default     = ""
}

variable "inline_policies" {
  description = "Map of inline policies to attach to the role"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
