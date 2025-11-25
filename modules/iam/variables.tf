variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "enable_ssm" {
  description = "Enable SSM access for nodes"
  type        = bool
  default     = true
}

variable "enable_ebs_csi" {
  description = "Enable EBS CSI driver IAM role"
  type        = bool
  default     = true
}

variable "enable_lb_controller" {
  description = "Enable AWS Load Balancer Controller IAM role"
  type        = bool
  default     = true
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider for the EKS cluster"
  type        = string
  default     = ""
}

variable "oidc_provider_url" {
  description = "URL of the OIDC provider for the EKS cluster"
  type        = string
  default     = ""
}

variable "ebs_csi_service_account_namespace" {
  description = "Kubernetes namespace for EBS CSI driver service account"
  type        = string
  default     = "kube-system"
}

variable "ebs_csi_service_account_name" {
  description = "Kubernetes service account name for EBS CSI driver"
  type        = string
  default     = "ebs-csi-controller-sa"
}

variable "lb_controller_service_account_namespace" {
  description = "Kubernetes namespace for AWS Load Balancer Controller service account"
  type        = string
  default     = "kube-system"
}

variable "lb_controller_service_account_name" {
  description = "Kubernetes service account name for AWS Load Balancer Controller"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "oidc_audience" {
  description = "Audience for OIDC provider"
  type        = string
  default     = "sts.amazonaws.com"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
