variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "node_group_name" {
  description = "Name of the EKS node group"
  type        = string
}

variable "node_role_arn" {
  description = "ARN of the IAM role for the node group"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the node group"
  type        = list(string)
}

variable "kubernetes_version" {
  description = "Kubernetes version for the node group"
  type        = string
  default     = null
}

variable "desired_size" {
  description = "Desired number of nodes"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 4
}

variable "max_unavailable_percentage" {
  description = "Maximum percentage of nodes unavailable during update"
  type        = number
  default     = 33
}

variable "instance_types" {
  description = "List of instance types for the node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "capacity_type" {
  description = "Type of capacity: ON_DEMAND or SPOT"
  type        = string
  default     = "ON_DEMAND"
}

variable "disk_size" {
  description = "Disk size in GiB for nodes"
  type        = number
  default     = 20
}

variable "disk_type" {
  description = "EBS volume type (gp2, gp3, io1, io2)"
  type        = string
  default     = "gp3"
}

variable "disk_iops" {
  description = "IOPS for io1 or io2 volumes"
  type        = number
  default     = null
}

variable "disk_throughput" {
  description = "Throughput for gp3 volumes in MiB/s"
  type        = number
  default     = 125
}

variable "disk_encrypted" {
  description = "Enable EBS encryption"
  type        = bool
  default     = true
}

variable "disk_kms_key_id" {
  description = "KMS key ID for EBS encryption"
  type        = string
  default     = null
}

variable "create_launch_template" {
  description = "Create a launch template for the node group"
  type        = bool
  default     = true
}

variable "enable_imdsv2" {
  description = "Enable IMDSv2 (Instance Metadata Service Version 2)"
  type        = bool
  default     = true
}

variable "enable_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = true
}

variable "security_group_ids" {
  description = "List of security group IDs for nodes"
  type        = list(string)
  default     = []
}

variable "user_data_base64" {
  description = "Base64 encoded user data for nodes"
  type        = string
  default     = null
}

variable "enable_remote_access" {
  description = "Enable SSH remote access to nodes"
  type        = bool
  default     = false
}

variable "ssh_key_name" {
  description = "EC2 SSH key name for remote access"
  type        = string
  default     = null
}

variable "remote_access_security_group_ids" {
  description = "Security group IDs allowed for remote access"
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "Key-value map of Kubernetes labels"
  type        = map(string)
  default     = {}
}

variable "taints" {
  description = "List of Kubernetes taints to apply to nodes"
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
