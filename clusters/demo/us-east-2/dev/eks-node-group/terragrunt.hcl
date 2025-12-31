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
  source = "../../../../../modules/eks-node-group"
}

dependency "vpc" {
  config_path = "../vpc"
  
  mock_outputs = {
    private_subnet_ids = ["subnet-00000000", "subnet-11111111"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

dependency "eks" {
  config_path = "../eks"
  
  mock_outputs = {
    cluster_id      = "mock-cluster"
    cluster_version = "1.28"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

dependency "iam" {
  config_path = "../iam"
  
  mock_outputs = {
    node_role_arn = "arn:aws:iam::000000000000:role/mock-node-role"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

dependency "security_groups" {
  config_path = "../security-groups"
  
  mock_outputs = {
    node_security_group_id = "sg-00000000"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

inputs = {
  cluster_name    = "${local.customer_vars.locals.customer_name}-${local.project_vars.locals.project_name}-${local.env_vars.locals.environment_name}"
  node_group_name = "${local.customer_vars.locals.customer_name}-${local.project_vars.locals.project_name}-${local.env_vars.locals.environment_name}-nodes"
  
  node_role_arn      = dependency.iam.outputs.nodes_role_arn
  subnet_ids         = dependency.vpc.outputs.private_subnet_ids
  kubernetes_version = dependency.eks.outputs.cluster_version
  
  desired_size = 2
  min_size     = 1
  max_size     = 3
  
  instance_types = ["t3.micro"]
  capacity_type  = "SPOT"
  
  disk_size = 20
  
  labels = {
    Environment = local.env_vars.locals.environment_name
    NodeGroup   = "primary"
  }
  
  tags = local.project_vars.locals.common_tags
  
  node_group_depends_on = [
    dependency.iam.outputs.nodes_role_arn
  ]
}
