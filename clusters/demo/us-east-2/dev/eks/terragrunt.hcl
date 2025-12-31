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
  source = "../../../../../modules/eks-cluster"
}

dependency "vpc" {
  config_path = "../vpc"
  
  mock_outputs = {
    private_subnet_ids = ["subnet-00000000", "subnet-11111111"]
    public_subnet_ids  = ["subnet-22222222", "subnet-33333333"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

dependency "iam" {
  config_path = "../iam"
  
  mock_outputs = {
    cluster_role_arn = "arn:aws:iam::000000000000:role/mock-cluster-role"
    ebs_csi_role_arn = "arn:aws:iam::000000000000:role/mock-ebs-csi-role"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

inputs = {
  cluster_name    = "${local.customer_vars.locals.customer_name}-${local.project_vars.locals.project_name}-${local.env_vars.locals.environment_name}"
  cluster_version = "1.28"
  
  cluster_role_arn   = dependency.iam.outputs.cluster_role_arn
  private_subnet_ids = dependency.vpc.outputs.private_subnet_ids
  public_subnet_ids  = dependency.vpc.outputs.public_subnet_ids
  
  cluster_security_group_ids = [dependency.security_groups.outputs.cluster_security_group_id]
  
  endpoint_private_access = true
  endpoint_public_access  = true
  public_access_cidrs     = ["0.0.0.0/0"]
  
  enabled_cluster_log_types = [] 
  cluster_encryption_config = []  
  
  tags = local.project_vars.locals.common_tags
  
  cluster_depends_on = [
    dependency.iam.outputs.cluster_role_arn
  ]
}
