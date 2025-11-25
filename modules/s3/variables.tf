variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "force_destroy" {
  description = "Allow deletion of non-empty bucket"
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Enable server-side encryption"
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm (AES256 or aws:kms)"
  type        = string
  default     = "AES256"
}

variable "kms_master_key_id" {
  description = "KMS key ID for encryption (required if sse_algorithm is aws:kms)"
  type        = string
  default     = null
}

variable "bucket_key_enabled" {
  description = "Enable S3 Bucket Keys for SSE-KMS"
  type        = bool
  default     = true
}

variable "block_public_access" {
  description = "Block all public access to the bucket"
  type        = bool
  default     = true
}

variable "enable_logging" {
  description = "Enable access logging"
  type        = bool
  default     = false
}

variable "logging_target_bucket" {
  description = "Target bucket for access logs"
  type        = string
  default     = ""
}

variable "logging_target_prefix" {
  description = "Prefix for access log objects"
  type        = string
  default     = "logs/"
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules"
  type = list(object({
    id      = string
    enabled = bool
    filter = optional(object({
      prefix = optional(string)
      tags   = optional(map(string))
    }))
    transitions = optional(list(object({
      days          = optional(number)
      date          = optional(string)
      storage_class = string
    })))
    expiration = optional(object({
      days                         = optional(number)
      date                         = optional(string)
      expired_object_delete_marker = optional(bool)
    }))
    noncurrent_version_transitions = optional(list(object({
      days          = number
      storage_class = string
    })))
    noncurrent_version_expiration = optional(object({
      days = number
    }))
    abort_incomplete_multipart_upload_days = optional(number)
  }))
  default = []
}

variable "bucket_policy" {
  description = "JSON policy document for the bucket"
  type        = string
  default     = null
}

variable "cors_rules" {
  description = "List of CORS rules"
  type = list(object({
    allowed_headers = optional(list(string))
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  }))
  default = []
}

variable "object_ownership" {
  description = "Object ownership setting (BucketOwnerPreferred, ObjectWriter, or BucketOwnerEnforced)"
  type        = string
  default     = "BucketOwnerEnforced"
}

variable "intelligent_tiering_configurations" {
  description = "Map of intelligent tiering configurations"
  type = map(object({
    status = string
    filter = optional(object({
      prefix = optional(string)
      tags   = optional(map(string))
    }))
    tierings = list(object({
      access_tier = string
      days        = number
    }))
  }))
  default = {}
}

variable "replication_configuration" {
  description = "Replication configuration for the bucket"
  type = object({
    role = string
    rules = list(object({
      id       = string
      priority = optional(number)
      status   = string
      filter = optional(object({
        prefix = optional(string)
        tags   = optional(map(string))
      }))
      destination = object({
        bucket        = string
        storage_class = optional(string)
        account       = optional(string)
        access_control_translation = optional(object({
          owner = string
        }))
        encryption_configuration = optional(object({
          replica_kms_key_id = string
        }))
        metrics = optional(object({
          status = string
          event_threshold = optional(object({
            minutes = number
          }))
        }))
        replication_time = optional(object({
          status = string
          time = optional(object({
            minutes = number
          }))
        }))
      })
      delete_marker_replication = optional(object({
        status = string
      }))
      source_selection_criteria = optional(object({
        sse_kms_encrypted_objects = optional(object({
          status = string
        }))
      }))
    }))
  })
  default = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
