locals {
  project_name = "eks-demo"
  
  common_tags = {
    Project   = "eks-demo"
    ManagedBy = "Terragrunt"
  }
}
