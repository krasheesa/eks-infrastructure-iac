include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

terraform {
  source = "../../../modules/iam"
}

locals {
  env = include.env.locals
}

inputs = {
  cluster_name = local.env.cluster_name
  
  # Enable SSM for debugging if needed
  enable_ssm = true
  
  # Enable EBS CSI driver for persistent volumes
  enable_ebs_csi = true
  
  # Disable Load Balancer Controller to save costs (can enable later if needed)
  enable_lb_controller = false
  
  # These will be populated after cluster creation
  oidc_provider_arn = ""
  oidc_provider_url = ""
  
  tags = merge(
    local.env.env_tags,
    {
      Name = "${local.env.cluster_name}-iam"
    }
  )
}
