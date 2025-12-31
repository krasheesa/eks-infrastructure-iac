# Terraform Modules Overview

This document describes the Terraform modules created for EKS infrastructure provisioning.

## Created Modules

All modules are located in the `modules/` directory and are designed to be minimal, configurable, and production-ready.

### 1. VPC Module (`modules/vpc/`)

**Purpose**: Creates a VPC with public and private subnets across multiple availability zones, including NAT gateways for private subnet internet access.

**Key Features**:
- Configurable CIDR blocks for VPC and subnets
- Support for multiple availability zones
- Public and private subnets with appropriate route tables
- NAT Gateway support (single or per-AZ)
- Kubernetes cluster tags for EKS integration
- Auto-tagging for ELB and internal ELB

**Outputs**: VPC ID, subnet IDs, NAT gateway IDs, route table IDs

---

### 2. Security Groups Module (`modules/security-groups/`)

**Purpose**: Creates security groups for EKS cluster control plane and worker nodes.

**Key Features**:
- Cluster security group for control plane
- Node security group for worker nodes
- Proper ingress/egress rules for cluster-node communication
- Optional ALB ingress rules
- All rules follow AWS best practices

**Outputs**: Cluster security group ID, nodes security group ID

---

### 3. IAM Module (`modules/iam/`)

**Purpose**: Creates IAM roles and policies for EKS cluster and worker nodes.

**Key Features**:
- EKS cluster IAM role with required policies
- Node IAM role with required policies (CNI, ECR, Worker Node)
- Optional CloudWatch logs policy
- Optional SSM policy for session manager access
- Follows AWS managed policies best practices

**Outputs**: Cluster role ARN/name, nodes role ARN/name

---

### 4. EKS Cluster Module (`modules/eks-cluster/`)

**Purpose**: Creates an EKS cluster with OIDC provider for IRSA support.

**Key Features**:
- Configurable Kubernetes version
- Private and public API endpoint control
- Optional control plane logging
- Optional encryption configuration
- OIDC provider for IAM Roles for Service Accounts (IRSA)
- Configurable public access CIDR blocks

**Outputs**: Cluster ID, ARN, endpoint, OIDC provider ARN/URL, certificate data

---

### 5. EKS Node Group Module (`modules/eks-node-group/`)

**Purpose**: Creates managed node groups for EKS cluster.

**Key Features**:
- Configurable scaling (min, max, desired)
- Support for multiple instance types
- ON_DEMAND or SPOT capacity
- Configurable disk size
- Optional SSH access configuration
- Support for Kubernetes labels and taints
- Auto-update configuration
- Lifecycle management (create before destroy)

**Outputs**: Node group ID, ARN, status, resources

---

### 6. S3 Module (`modules/s3/`)

**Purpose**: Creates S3 buckets with security best practices.

**Key Features**:
- Optional versioning
- Server-side encryption (AES256 or KMS)
- Block public access by default
- Lifecycle rules support
- Custom bucket policies
- Force destroy option for testing

**Outputs**: Bucket ID, ARN, domain names

---

### 7. IRSA Module (`modules/irsa/`)

**Purpose**: Creates IAM roles for Kubernetes service accounts using OIDC federation.

**Key Features**:
- OIDC-based assume role policy
- Support for multiple service accounts
- Custom IAM policy creation
- Managed policy attachment support
- Namespace-level isolation

**Outputs**: Role ARN, role name, policy ARN

---

## Module Structure

Each module follows the standard Terraform structure:

```
modules/<module-name>/
├── main.tf          # Resource definitions
├── variables.tf     # Input variables
└── outputs.tf       # Output values
```

## Usage with Terragrunt

These modules are designed to be used with Terragrunt configurations in the `clusters/` directory. The terragrunt configurations reference these modules using relative paths:

```hcl
terraform {
  source = "../../../../modules/vpc"
}
```

## Key Design Principles

1. **Configurable**: All hardcoded values are replaced with variables
2. **Minimal**: Only essential features included, optional features are opt-in
3. **Secure**: Security best practices enabled by default (encryption, private access, etc.)
4. **Tagged**: All resources properly tagged for cost tracking and organization
5. **Kubernetes-Ready**: Proper tags and configurations for EKS integration
6. **Production-Ready**: Follows AWS best practices and recommendations

## Cost Optimization

The modules are designed with cost optimization in mind:
- Single NAT gateway option available
- Support for t3.small/t3.micro instances (free tier eligible)
- Optional features can be disabled (logging, encryption, etc.)
- Spot instance support for node groups
- Minimal resource defaults

## Testing

To test these modules with the minimal configuration:

```bash
cd clusters/demo/us-east-2/dev
make init    # Initialize Terragrunt
make plan    # Preview changes
make apply   # Apply changes
```

See the [README.md](../clusters/demo/us-east-2/dev/README.md) in the dev environment for detailed deployment instructions.

## Module Dependencies

The modules have the following dependencies:

```
vpc (independent)
  ↓
security-groups (requires vpc_id)
  ↓
iam (independent)
  ↓
eks-cluster (requires vpc, security-groups, iam)
  ↓
eks-node-group (requires eks-cluster, iam)
  ↓
s3 (independent)
  ↓
irsa (requires eks-cluster OIDC)
```

## Next Steps

1. Review and customize the environment configuration in `clusters/demo/us-east-2/dev/env.hcl`
2. Initialize and deploy the infrastructure following the README
3. Configure kubectl to access the cluster
4. Deploy applications using the IRSA role for S3 access

## Support

For issues or questions:
1. Check the terragrunt logs: `make plan` or `make apply`
2. Review AWS CloudFormation events for EKS-related issues
3. Check the Terraform state: `terragrunt state list`
4. Validate configurations: `terragrunt validate`
