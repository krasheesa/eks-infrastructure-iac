variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "enable_alb_ingress" {
  description = "Enable ALB ingress rule"
  type        = bool
  default     = false
}

variable "alb_ingress_from_port" {
  description = "Starting port for ALB ingress"
  type        = number
  default     = 80
}

variable "alb_ingress_to_port" {
  description = "Ending port for ALB ingress"
  type        = number
  default     = 65535
}

variable "alb_ingress_cidr_blocks" {
  description = "CIDR blocks allowed for ALB ingress"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
