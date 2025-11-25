resource "aws_kms_key" "eks" {
  count                   = var.enable_secrets_encryption ? 1 : 0
  description             = "EKS Secret Encryption Key for ${var.cluster_name}"
  deletion_window_in_days = var.kms_deletion_window
  enable_key_rotation     = var.kms_enable_key_rotation

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-eks-secrets"
    }
  )
}

resource "aws_kms_alias" "eks" {
  count         = var.enable_secrets_encryption ? 1 : 0
  name          = "alias/${var.cluster_name}-eks-secrets"
  target_key_id = aws_kms_key.eks[0].key_id
}

resource "aws_cloudwatch_log_group" "eks" {
  count             = var.enable_cluster_logging ? 1 : 0
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.log_retention_days

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-logs"
    }
  )
}

resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids              = concat(var.private_subnet_ids, var.public_subnet_ids)
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
    security_group_ids      = var.additional_security_group_ids
  }

  dynamic "encryption_config" {
    for_each = var.enable_secrets_encryption ? [1] : []
    content {
      provider {
        key_arn = aws_kms_key.eks[0].arn
      }
      resources = var.encryption_resources
    }
  }

  enabled_cluster_log_types = var.enable_cluster_logging ? var.cluster_log_types : []

  depends_on = [
    aws_cloudwatch_log_group.eks
  ]

  tags = merge(
    var.tags,
    {
      Name = var.cluster_name
    }
  )
}

data "tls_certificate" "cluster" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = var.oidc_client_id_list
  thumbprint_list = var.oidc_thumbprint_list != null ? var.oidc_thumbprint_list : [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-oidc"
    }
  )
}

resource "aws_eks_addon" "vpc_cni" {
  count                    = var.enable_vpc_cni_addon ? 1 : 0
  cluster_name             = aws_eks_cluster.main.name
  addon_name               = "vpc-cni"
  addon_version            = var.vpc_cni_version
  resolve_conflicts        = var.vpc_cni_resolve_conflicts
  service_account_role_arn = var.vpc_cni_role_arn

  tags = var.tags
}

resource "aws_eks_addon" "coredns" {
  count                    = var.enable_coredns_addon ? 1 : 0
  cluster_name             = aws_eks_cluster.main.name
  addon_name               = "coredns"
  addon_version            = var.coredns_version
  resolve_conflicts        = var.coredns_resolve_conflicts

  tags = var.tags

  depends_on = [aws_eks_cluster.main]
}

resource "aws_eks_addon" "kube_proxy" {
  count                    = var.enable_kube_proxy_addon ? 1 : 0
  cluster_name             = aws_eks_cluster.main.name
  addon_name               = "kube-proxy"
  addon_version            = var.kube_proxy_version
  resolve_conflicts        = var.kube_proxy_resolve_conflicts

  tags = var.tags
}

resource "aws_eks_addon" "ebs_csi_driver" {
  count                    = var.enable_ebs_csi_addon ? 1 : 0
  cluster_name             = aws_eks_cluster.main.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = var.ebs_csi_version
  resolve_conflicts        = var.ebs_csi_resolve_conflicts
  service_account_role_arn = var.ebs_csi_role_arn

  tags = var.tags
}
