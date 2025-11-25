variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.28"
}

variable "cluster_role_arn" {
  description = "ARN of the IAM role for the EKS cluster"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
  default     = []
}

variable "endpoint_private_access" {
  description = "Enable private API server endpoint"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Enable public API server endpoint"
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "List of CIDR blocks that can access the public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "additional_security_group_ids" {
  description = "Additional security group IDs to attach to the cluster"
  type        = list(string)
  default     = []
}

variable "enable_secrets_encryption" {
  description = "Enable secrets encryption using KMS"
  type        = bool
  default     = true
}

variable "kms_deletion_window" {
  description = "KMS key deletion window in days"
  type        = number
  default     = 30
}

variable "kms_enable_key_rotation" {
  description = "Enable automatic key rotation for KMS key"
  type        = bool
  default     = true
}

variable "encryption_resources" {
  description = "List of resources to encrypt (e.g., ['secrets'])"
  type        = list(string)
  default     = ["secrets"]
}

variable "enable_cluster_logging" {
  description = "Enable CloudWatch logging for the cluster"
  type        = bool
  default     = true
}

variable "cluster_log_types" {
  description = "List of control plane logging types to enable"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 7
}

variable "enable_vpc_cni_addon" {
  description = "Enable VPC CNI addon"
  type        = bool
  default     = true
}

variable "vpc_cni_version" {
  description = "VPC CNI addon version"
  type        = string
  default     = null
}

variable "vpc_cni_role_arn" {
  description = "IAM role ARN for VPC CNI"
  type        = string
  default     = null
}

variable "vpc_cni_resolve_conflicts" {
  description = "Resolve conflicts method for VPC CNI addon (OVERWRITE, PRESERVE, or NONE)"
  type        = string
  default     = "OVERWRITE"
}

variable "enable_coredns_addon" {
  description = "Enable CoreDNS addon"
  type        = bool
  default     = true
}

variable "coredns_version" {
  description = "CoreDNS addon version"
  type        = string
  default     = null
}

variable "coredns_resolve_conflicts" {
  description = "Resolve conflicts method for CoreDNS addon (OVERWRITE, PRESERVE, or NONE)"
  type        = string
  default     = "OVERWRITE"
}

variable "enable_kube_proxy_addon" {
  description = "Enable kube-proxy addon"
  type        = bool
  default     = true
}

variable "kube_proxy_version" {
  description = "kube-proxy addon version"
  type        = string
  default     = null
}

variable "kube_proxy_resolve_conflicts" {
  description = "Resolve conflicts method for kube-proxy addon (OVERWRITE, PRESERVE, or NONE)"
  type        = string
  default     = "OVERWRITE"
}

variable "enable_ebs_csi_addon" {
  description = "Enable EBS CSI driver addon"
  type        = bool
  default     = true
}

variable "ebs_csi_version" {
  description = "EBS CSI driver addon version"
  type        = string
  default     = null
}

variable "ebs_csi_role_arn" {
  description = "IAM role ARN for EBS CSI driver"
  type        = string
  default     = null
}

variable "ebs_csi_resolve_conflicts" {
  description = "Resolve conflicts method for EBS CSI driver addon (OVERWRITE, PRESERVE, or NONE)"
  type        = string
  default     = "OVERWRITE"
}

variable "oidc_client_id_list" {
  description = "List of client IDs for OIDC provider"
  type        = list(string)
  default     = ["sts.amazonaws.com"]
}

variable "oidc_thumbprint_list" {
  description = "List of thumbprints for OIDC provider (if null, will be auto-detected)"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
