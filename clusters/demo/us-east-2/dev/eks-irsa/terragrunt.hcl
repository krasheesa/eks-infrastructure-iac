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
  source = "../../../../../modules/irsa"
}

dependency "eks" {
  config_path = "../eks"
  
  mock_outputs = {
    oidc_provider_arn = "arn:aws:iam::000000000000:oidc-provider/oidc.eks.region.amazonaws.com/id/MOCK"
    oidc_provider_url = "https://oidc.eks.region.amazonaws.com/id/MOCK"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

dependency "s3" {
  config_path = "../s3"
  
  mock_outputs = {
    bucket_arn = "arn:aws:s3:::mock-bucket"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

inputs = {
  role_name = "${local.customer_vars.locals.customer_name}-${local.project_vars.locals.project_name}-${local.env_vars.locals.environment_name}-s3-access"
  
  oidc_provider_arn = dependency.eks.outputs.oidc_provider_arn
  oidc_provider_url = dependency.eks.outputs.oidc_provider_url
  
  service_account_subjects = [
    "system:serviceaccount:default:s3-access-sa"
  ]
  
  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          dependency.s3.outputs.bucket_arn,
          "${dependency.s3.outputs.bucket_arn}/*"
        ]
      }
    ]
  })
  
  policy_description = "IAM policy for S3 access via IRSA"
  
  tags = local.project_vars.locals.common_tags
}
