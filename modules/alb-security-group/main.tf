resource "aws_security_group" "alb" {
  name_prefix = "${var.name}-alb-"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name = "${var.name}-alb-sg"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "alb_http_ingress" {
  count = var.enable_http ? 1 : 0

  description       = "Allow HTTP traffic from internet"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = var.http_ingress_cidr_blocks
}

resource "aws_security_group_rule" "alb_https_ingress" {
  count = var.enable_https ? 1 : 0

  description       = "Allow HTTPS traffic from internet"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = var.https_ingress_cidr_blocks
}

resource "aws_security_group_rule" "alb_egress_vpc" {
  description       = "Allow outbound traffic to VPC"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = [var.vpc_cidr_block]
}

resource "aws_security_group_rule" "alb_to_nodes" {
  count = var.node_security_group_id != null ? 1 : 0

  description              = "Allow ALB to communicate with EKS nodes"
  type                     = "egress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = var.node_security_group_id
}

resource "aws_security_group_rule" "nodes_from_alb" {
  count = var.node_security_group_id != null ? 1 : 0

  description              = "Allow nodes to receive traffic from ALB"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = var.node_security_group_id
  source_security_group_id = aws_security_group.alb.id
}
