variable "name" {
  description = "Name prefix for the ALB security group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "enable_http" {
  description = "Enable HTTP ingress"
  type        = bool
  default     = true
}

variable "enable_https" {
  description = "Enable HTTPS ingress"
  type        = bool
  default     = true
}

variable "http_ingress_cidr_blocks" {
  description = "CIDR blocks allowed for HTTP ingress"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "https_ingress_cidr_blocks" {
  description = "CIDR blocks allowed for HTTPS ingress"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "node_security_group_id" {
  description = "Security group ID of EKS nodes (to allow ALB to node communication)"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
