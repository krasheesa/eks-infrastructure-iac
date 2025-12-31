include "root" {
  path = find_in_parent_folders()
}

locals {
  customer_vars = read_terragrunt_config(find_in_parent_folders("customer.hcl"))
  project_vars  = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  region_vars   = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env_vars      = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../../../modules/s3"
}

inputs = {
  bucket_name   = "${local.customer_vars.locals.customer_name}-${local.project_vars.locals.project_name}-${local.env_vars.locals.environment_name}"
  force_destroy = true
  
  enable_versioning = false
  enable_encryption = true
  sse_algorithm     = "AES256"
  
  block_public_access = true
  
  lifecycle_rules = []
  
  tags = local.project_vars.locals.common_tags
}
