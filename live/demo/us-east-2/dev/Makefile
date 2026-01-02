.PHONY: help init plan apply destroy clean

TERRAGRUNT := terragrunt

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

init:
	$(TERRAGRUNT) run-all init

plan:
	$(TERRAGRUNT) run-all plan

apply:
	@echo "Applying VPC..."
	cd vpc && $(TERRAGRUNT) apply && cd ..
	@echo "Applying Security Groups..."
	cd security-groups && $(TERRAGRUNT) apply && cd ..
	@echo "Applying ALB Security Group..."
	cd alb-security-group && $(TERRAGRUNT) apply && cd ..
	@echo "Applying IAM..."
	cd iam && $(TERRAGRUNT) apply && cd ..
	@echo "Applying EKS Cluster..."
	cd eks && $(TERRAGRUNT) apply && cd ..
	@echo "Updating IAM with OIDC..."
	cd iam && $(TERRAGRUNT) apply && cd ..
	@echo "Applying Node Group..."
	cd eks-node-group && $(TERRAGRUNT) apply && cd ..
	@echo "Applying S3..."
	cd s3 && $(TERRAGRUNT) apply && cd ..
	@echo "Applying S3 IRSA..."
	cd eks-irsa && $(TERRAGRUNT) apply && cd ..
	@echo "Applying AWS LB Controller IRSA..."
	cd aws-lb-controller-irsa && $(TERRAGRUNT) apply && cd ..
	@echo "Infrastructure deployed!"
	@echo ""
	@echo "Next step: Install AWS Load Balancer Controller via Helm"
	@echaws-lb-controller-irsa && $(TERRAGRUNT) destroy -auto-approve && cd ..; \
		cd eks-irsa && $(TERRAGRUNT) destroy -auto-approve && cd ..; \
		cd s3 && $(TERRAGRUNT) destroy -auto-approve && cd ..; \
		cd eks-node-group && $(TERRAGRUNT) destroy -auto-approve && cd ..; \
		cd eks && $(TERRAGRUNT) destroy -auto-approve && cd ..; \
		cd iam && $(TERRAGRUNT) destroy -auto-approve && cd ..; \
		cd alb-security-groupp "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		cd eks-irsa && $(TERRAGRUNT) destroy -auto-approve && cd ..; \
		cd s3 && $(TERRAGRUNT) destroy -auto-approve && cd ..; \
		cd eks-node-group && $(TERRAGRUNT) destroy -auto-approve && cd ..; \
		cd eks && $(TERRAGRUNT) destroy -auto-approve && cd ..; \
		cd iam && $(TERRAGRUNT) destroy -auto-approve && cd ..; \
		cd security-groups && $(TERRAGRUNT) destroy -auto-approve && cd ..; \
		cd vpc && $(TERRAGRUNT) destroy -auto-approve && cd ..; \
		echo "All resources destroyed!"; \
	fi

clean:
	find . -type d -name ".terragrunt-cache" -exec rm -rf {} +
	find . -type d -name ".terraform" -exec rm -rf {} +
	find . -type f -name "*.tfstate*" -delete
	find . -type f -name ".terraform.lock.hcl" -delete

validate:
	$(TERRAGRUNT) run-all validate

output:
	@echo "=== VPALB Security Group Outputs ==="
	cd alb-security-group && $(TERRAGRUNT) output
	@echo "\n=== EKS Outputs ==="
	cd eks && $(TERRAGRUNT) output
	@echo "\n=== S3 Outputs ==="
	cd s3 && $(TERRAGRUNT) output
	@echo "\n=== S3 IRSA Outputs ==="
	cd eks-irsa && $(TERRAGRUNT) output
	@echo "\n=== AWS LB Controller IRSA Outputs ==="
	cd aws-lb-controller&& $(TERRAGRUNT) output
	@echo "\n=== IRSA Outputs ==="demo-demo-dev --region us-east-2
	kubectl get nodes

install-alb-controller:
	@echo "Installing AWS Load Balancer Controller..."
	@IRSA_ROLE_ARN=$$(cd aws-lb-controller-irsa && $(TERRAGRUNT) output -raw role_arn); \
	VPC_ID=$$(cd vpc && $(TERRAGRUNT) output -raw vpc_id); \
	helm repo add eks https://aws.github.io/eks-charts 2>/dev/null || true; \
	helm repo update; \
	helm upgrade --install aws-load-demo-demo-dev --region us-east-2 --query 'cluster.status' --output text
	@echo "\n=== Nodes ==="
	kubectl get nodes
	@echo "\n=== Pods ==="
	kubectl get pods -A
	@echo "\n=== AWS Load Balancer Controller ==="
	kubectl get deployment -n kube-system aws-load-balancer-controller 2>/dev/null || echo "Not installed"
	@echo "\n=== Ingress Resources ==="
	kubectl get ingresccount.name=aws-load-balancer-controller \
		--set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"="$$IRSA_ROLE_ARN" \
		--set region=us-east-2 \
		--set vpcId=$$VPC_ID
	@echo "✅ AWS Load Balancer Controller installed!"
	@echo "Verify with: kubectl get deployment -n kube-system aws-load-balancer-controller"

uninstall-alb-controller:
	helm uninstall aws-load-balancer-controller -n kube-systemTERRAGRUNT) output

kubeconfig:
	aws eks update-kubeconfig --name eks-demo-dev --region us-east-2
	kubectl get nodes

status:
	@echo "=== EKS Cluster ==="
	aws eks describe-cluster --name eks-demo-dev --region us-east-2 --query 'cluster.status' --output text
	@echo "\n=== Nodes ==="
	kubectl get nodes
	@echo "\n=== Pods ==="
	kubectl get pods -A

test-s3:
	kubectl run s3-test --rm -it --image=amazon/aws-cli:latest --serviceaccount=s3-access-sa -- /bin/bash
