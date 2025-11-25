variable "domain_name" {
  description = "Domain name for the Route53 zone"
  type        = string
}

variable "create_zone" {
  description = "Whether to create a new Route53 zone or use existing"
  type        = bool
  default     = true
}

variable "zone_comment" {
  description = "Comment for the Route53 zone"
  type        = string
  default     = "Managed by Terraform"
}

variable "is_private_zone" {
  description = "Whether this is a private hosted zone"
  type        = bool
  default     = false
}

variable "vpc_associations" {
  description = "VPC associations for private hosted zone"
  type = list(object({
    vpc_id     = string
    vpc_region = string
  }))
  default = []
}

variable "force_destroy" {
  description = "Force destroy the zone even if it contains records"
  type        = bool
  default     = false
}

variable "records" {
  description = "List of DNS records to create"
  type = list(object({
    name    = string
    type    = string
    ttl     = optional(number)
    records = optional(list(string))
    alias = optional(object({
      name                   = string
      zone_id                = string
      evaluate_target_health = optional(bool)
    }))
    weighted_routing_policy = optional(object({
      weight = number
    }))
    latency_routing_policy = optional(object({
      region = string
    }))
    geolocation_routing_policy = optional(object({
      continent   = optional(string)
      country     = optional(string)
      subdivision = optional(string)
    }))
    failover_routing_policy = optional(object({
      type = string
    }))
    set_identifier  = optional(string)
    health_check_id = optional(string)
    allow_overwrite = optional(bool)
  }))
  default = []
}

variable "health_checks" {
  description = "List of Route53 health checks"
  type = list(object({
    name                            = string
    type                            = string
    resource_path                   = optional(string)
    fqdn                            = optional(string)
    ip_address                      = optional(string)
    port                            = optional(number)
    protocol                        = optional(string)
    request_interval                = optional(number)
    failure_threshold               = optional(number)
    measure_latency                 = optional(bool)
    enable_sni                      = optional(bool)
    search_string                   = optional(string)
    cloudwatch_alarm_name           = optional(string)
    cloudwatch_alarm_region         = optional(string)
    insufficient_data_health_status = optional(string)
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
