include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

terraform {
  source = "../../../modules/eks-node-group"
}

dependency "vpc" {
  config_path = "../vpc"
  
  mock_outputs = {
    private_subnet_ids = ["subnet-00000000", "subnet-11111111"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "eks_cluster" {
  config_path = "../eks-cluster"
  
  mock_outputs = {
    cluster_id      = "mock-cluster"
    cluster_version = "1.28"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "iam" {
  config_path = "../iam"
  
  mock_outputs = {
    node_role_arn = "arn:aws:iam::377886347059:role/mock-node-role"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "security_groups" {
  config_path = "../security-groups"
  
  mock_outputs = {
    node_security_group_id = "sg-00000000"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

locals {
  env = include.env.locals
}

inputs = {
  cluster_name    = local.env.cluster_name
  node_group_name = "${local.env.cluster_name}-nodes"
  
  node_role_arn      = dependency.iam.outputs.node_role_arn
  subnet_ids         = dependency.vpc.outputs.private_subnet_ids
  kubernetes_version = dependency.eks_cluster.outputs.cluster_version
  
  # Cost-optimized node configuration
  desired_size = local.env.node_desired_size
  min_size     = local.env.node_min_size
  max_size     = local.env.node_max_size
  
  instance_types = local.env.node_instance_types
  capacity_type  = "ON_DEMAND"  # Use SPOT for even more savings, but less reliable
  
  disk_size = local.env.node_disk_size
  disk_type = "gp3"  # More cost-effective than gp2
  
  # Launch template for better control
  create_launch_template = true
  enable_imdsv2          = true
  enable_monitoring      = false  # Disable detailed monitoring to save costs
  
  security_group_ids = [dependency.security_groups.outputs.node_security_group_id]
  
  # No SSH access for dev (use SSM instead)
  enable_remote_access = false
  
  labels = {
    Environment = local.env.env_class
    NodeGroup   = "primary"
  }
  
  tags = merge(
    local.env.env_tags,
    {
      Name = "${local.env.cluster_name}-nodes"
    }
  )
}
