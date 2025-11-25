variable "certificate_name" {
  description = "Name tag for the certificate"
  type        = string
}

variable "domain_name" {
  description = "Primary domain name for the certificate"
  type        = string
}

variable "subject_alternative_names" {
  description = "Subject alternative names for the certificate"
  type        = list(string)
  default     = []
}

variable "validation_method" {
  description = "Validation method: DNS or EMAIL"
  type        = string
  default     = "DNS"
}

variable "validation_options" {
  description = "Validation options for the certificate"
  type = list(object({
    domain_name       = string
    validation_domain = string
  }))
  default = []
}

variable "create_route53_validation_records" {
  description = "Create Route53 records for certificate validation"
  type        = bool
  default     = true
}

variable "route53_zone_id" {
  description = "Route53 zone ID for DNS validation"
  type        = string
  default     = ""
}

variable "wait_for_validation" {
  description = "Wait for certificate validation to complete"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
