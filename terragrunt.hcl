# Common variables for all environments
locals {
  # AWS Account Configuration
  aws_account_id = "377886347059"
  aws_region     = "us-east-1"  # Change to your preferred region
  
  # Common tags applied to all resources
  common_tags = {
    ManagedBy   = "Terragrunt"
    Project     = "EKS Infrastructure"
    CostCenter  = "Engineering"
  }
}

# Remote state configuration
remote_state {
  backend = "s3"
  
  config = {
    encrypt        = true
    bucket         = "eks-infra-terraform-state-${local.aws_account_id}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "eks-infra-terraform-locks"
    
    s3_bucket_tags = merge(
      local.common_tags,
      {
        Name = "Terraform State Bucket"
      }
    )
    
    dynamodb_table_tags = merge(
      local.common_tags,
      {
        Name = "Terraform Lock Table"
      }
    )
  }
  
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# Generate provider configuration
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  
  default_tags {
    tags = {
      ManagedBy   = "Terragrunt"
      Project     = "EKS Infrastructure"
      Environment = "$${var.environment}"
    }
  }
}

terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
EOF
}

# Generate common variables file
generate "common_vars" {
  path      = "common_vars.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
variable "environment" {
  description = "Environment name"
  type        = string
}

variable "env_class" {
  description = "Environment class (dev, staging, prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "${local.aws_region}"
}
EOF
}

# Inputs that will be merged with child terragrunt.hcl
inputs = {
  aws_region = local.aws_region
  tags       = local.common_tags
}
