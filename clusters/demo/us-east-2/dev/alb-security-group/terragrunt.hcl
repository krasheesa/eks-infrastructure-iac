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
  source = "../../../../../modules/alb-security-group"
}

dependency "vpc" {
  config_path = "../vpc"
  
  mock_outputs = {
    vpc_id         = "vpc-00000000"
    vpc_cidr_block = "10.0.0.0/16"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

dependency "security_groups" {
  config_path = "../security-groups"
  
  mock_outputs = {
    nodes_security_group_id = "sg-00000000"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

inputs = {
  name = "${local.customer_vars.locals.customer_name}-${local.project_vars.locals.project_name}-${local.env_vars.locals.environment_name}"
  
  vpc_id              = dependency.vpc.outputs.vpc_id
  vpc_cidr_block      = dependency.vpc.outputs.vpc_cidr_block
  
  # allow HTTP and HTTPS from internet
  enable_http  = true
  enable_https = false # not using https
  
  http_ingress_cidr_blocks  = ["0.0.0.0/0"]
  https_ingress_cidr_blocks = ["0.0.0.0/0"]
  
  node_security_group_id = dependency.security_groups.outputs.nodes_security_group_id
  
  tags = local.project_vars.locals.common_tags
}
