# Include root configuration
include "root" {
  path = find_in_parent_folders()
}

# Environment-specific locals
locals {
  env_name    = "environment-a"
  env_class   = "dev"
  cluster_name = "${local.env_name}-${local.env_class}"
  
  # Cost-optimized settings for dev environment
  vpc_cidr = "10.0.0.0/16"
  azs      = ["us-east-1a", "us-east-1b"]  # Only 2 AZs to save on NAT Gateway costs
  
  # Subnets - minimal setup
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  
  # Node configuration - minimal for dev
  node_instance_types = ["t3.medium"]  # Cost-effective
  node_desired_size   = 1              # Minimum for testing
  node_min_size       = 1
  node_max_size       = 2
  node_disk_size      = 20             # Minimum viable disk size
  
  # Environment tags
  env_tags = {
    Environment = local.env_name
    EnvClass    = local.env_class
    Cluster     = local.cluster_name
  }
}

# Common inputs for all modules in this environment
inputs = merge(
  {
    environment  = local.env_name
    env_class    = local.env_class
    cluster_name = local.cluster_name
    vpc_cidr     = local.vpc_cidr
    azs          = local.azs
  },
  local.env_tags
)
