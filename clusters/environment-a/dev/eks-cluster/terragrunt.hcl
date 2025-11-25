include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

terraform {
  source = "../../../modules/eks-cluster"
}

dependency "vpc" {
  config_path = "../vpc"
  
  mock_outputs = {
    private_subnet_ids = ["subnet-00000000", "subnet-11111111"]
    public_subnet_ids  = ["subnet-22222222", "subnet-33333333"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "iam" {
  config_path = "../iam"
  
  mock_outputs = {
    cluster_role_arn  = "arn:aws:iam::377886347059:role/mock-cluster-role"
    ebs_csi_role_arn  = "arn:aws:iam::377886347059:role/mock-ebs-csi-role"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

locals {
  env = include.env.locals
}

inputs = {
  cluster_name    = local.env.cluster_name
  cluster_version = "1.28"  # Use stable version
  
  cluster_role_arn   = dependency.iam.outputs.cluster_role_arn
  private_subnet_ids = dependency.vpc.outputs.private_subnet_ids
  public_subnet_ids  = dependency.vpc.outputs.public_subnet_ids
  
  # Endpoint access - public for dev (easier access)
  endpoint_private_access = true
  endpoint_public_access  = true
  public_access_cidrs     = ["0.0.0.0/0"]  # Restrict this to your IP for better security
  
  # Enable encryption for security (minimal cost)
  enable_secrets_encryption = true
  kms_enable_key_rotation   = true
  
  # Minimal logging to save on CloudWatch costs
  enable_cluster_logging = true
  cluster_log_types      = ["api", "audit"]  # Only essential logs
  log_retention_days     = 7                  # Short retention for dev
  
  # Enable essential addons
  enable_vpc_cni_addon     = true
  enable_coredns_addon     = true
  enable_kube_proxy_addon  = true
  enable_ebs_csi_addon     = true
  ebs_csi_role_arn         = dependency.iam.outputs.ebs_csi_role_arn
  
  tags = merge(
    local.env.env_tags,
    {
      Name = local.env.cluster_name
    }
  )
}
