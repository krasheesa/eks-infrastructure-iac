variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the cluster API"
  type        = list(string)
  default     = []
}

variable "cluster_egress_cidr_blocks" {
  description = "CIDR blocks for cluster egress"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "node_egress_cidr_blocks" {
  description = "CIDR blocks for node egress"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_https_port" {
  description = "Port for cluster API HTTPS"
  type        = number
  default     = 443
}

variable "node_to_cluster_port_range" {
  description = "Port range for node to cluster communication"
  type = object({
    from_port = number
    to_port   = number
  })
  default = {
    from_port = 1025
    to_port   = 65535
  }
}

variable "node_self_port_range" {
  description = "Port range for node to node communication"
  type = object({
    from_port = number
    to_port   = number
  })
  default = {
    from_port = 0
    to_port   = 65535
  }
}

variable "kubernetes_cluster_tag_value" {
  description = "Value for kubernetes.io/cluster tag (shared or owned)"
  type        = string
  default     = "owned"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
