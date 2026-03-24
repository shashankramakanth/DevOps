# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a DevOps learning and project repository organized into four main areas: Azure fundamentals, Infrastructure as Code (Terraform + Ansible), Kubernetes, and real-world projects.

## Common Commands

### Terraform

```bash
# Initialize a module or environment
terraform init

# Preview changes
terraform plan

# Apply changes
terraform apply

# Destroy resources
terraform destroy

# Format all .tf files
terraform fmt -recursive

# Validate configuration
terraform validate
```

### Terraform AWS Backend Bootstrap (run once per environment)
```bash
cd 02-infrastructure-as-code/terraform-aws/global/backend-bootstrap
terraform init && terraform apply

# To tear down the backend
bash cleanup-backend.sh
```

### Terraform Dev Environment
```bash
cd 02-infrastructure-as-code/terraform-aws/envs/dev
terraform init
terraform plan
terraform apply

# Reset state (destructive — removes local state and .terraform dir)
bash reset.sh
```

### Kubernetes (Kind local cluster)
```bash
# Create cluster from config
kind create cluster --config scripts-utils/kind-cluster/config.yaml --name my-cluster

# Delete cluster
kind delete cluster --name my-cluster

# Apply a manifest
kubectl apply -f 03-kubernetes/<subdir>/<file>.yaml

# Delete a manifest
kubectl delete -f 03-kubernetes/<subdir>/<file>.yaml
```

### LocalStack (AWS emulation)
```bash
cd scripts-utils/localstack
docker compose up -d

# Test with AWS CLI against LocalStack
aws --endpoint-url=http://localhost:4566 s3 ls
```

### Ansible
```bash
cd 02-infrastructure-as-code/ansible/<playbook-dir>
ansible-playbook -i inventory playbook.yml
```

### Flask App (Projects/containerize-an-app)
```bash
pip install -r Projects/containerize-an-app/requirements.txt
python Projects/containerize-an-app/app.py

# Build and run container
docker build -t flask-app Projects/containerize-an-app/
docker run -p 5000:5000 flask-app
```

## Architecture

### Terraform AWS Modular Structure

`02-infrastructure-as-code/terraform-aws/` follows a layered module pattern:

```
global/backend-bootstrap/   # S3 bucket + DynamoDB table for remote state — provision first
modules/
  vpc/                      # VPC, subnets (public/private), IGW, NAT GW, route tables
  compute/                  # EC2/ASG (skeleton)
  alb/                      # Application Load Balancer (skeleton)
  security/                 # Security groups (skeleton)
envs/dev/                   # Dev environment — calls modules, uses remote backend
shared/                     # Shared variables/data
```

The backend state is stored in S3 (`terraform-state-...`) with DynamoDB locking. The `envs/dev/main.tf` calls the VPC module and provisions an S3 bucket directly. Backend config is in `envs/dev/backend.tf`.

### Terraform Azure Modules (Projects/terraform_modules/Azure)

Flat reusable modules: `resource_group/`, `VNet/`, `Subnet/` — each with `main.tf`, `variables.tf`, `outputs.tf`. Used by the Azure VMSS project.

### Kubernetes Structure

`03-kubernetes/` contains standalone YAML manifests organized by concept (not a Helm chart). No inter-manifest dependencies — each subdirectory is independent. The `scripts-utils/kind-cluster/config.yaml` defines a 3-node Kind cluster (1 control-plane, 2 workers) for local testing.

### Local Development Containers

- `scripts-utils/azure/` — Docker Compose for running Terraform in an Azure-preconfigured container; mounts `~/.azure` and `~/.terraform.d`
- `scripts-utils/localstack/` — LocalStack with services: S3, Lambda, SQS, DynamoDB, IAM; data persisted to `./volume`
- `scripts-utils/OCI/` — OCI CLI container with credentials mounted from `./oci-config/`

## Key Conventions

- Terraform modules use `variables.tf` + `outputs.tf` consistently; calling environments pass values via `terraform.tfvars` or inline `module {}` arguments.
- AWS provider version pinned to `~> 5.91.0`; Azure to `~> 4.38.1`.
- Kubernetes manifests use `apiVersion: apps/v1` for Deployments/DaemonSets/StatefulSets and `apiVersion: v1` for Pods/Services/ConfigMaps.
- The `Projects/azure-vmss-with-lb/` project demonstrates dynamic blocks for NSG rules and CPU-based autoscale (scale-out >80%, scale-in <10%).
