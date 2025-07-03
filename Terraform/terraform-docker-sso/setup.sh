#!/bin/bash

# Create project structure
mkdir -p terraform-docker-project
cd terraform-docker-project

# Create terraform-data directory for persistence
mkdir -p terraform-data

# Copy Dockerfile
cat > Dockerfile << 'EOF'
FROM alpine:3.18

# Set Terraform version
ENV TERRAFORM_VERSION="1.7.0"

# Install dependencies
RUN apk add --update --no-cache \
    curl \
    bash \
    openssh \
    git \
    jq \
    vim \
    nano \
    unzip \
    python3 \
    py3-pip \
    groff \
    less

# Install AWS CLI v2
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install --no-cache-dir awscli


# Download and install Terraform
RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Verify installation
RUN terraform version

WORKDIR /terraform

# Keep container running
ENTRYPOINT ["/bin/bash"]
EOF

# Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3'

services:
  terraform:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: terraform-env
    volumes:
      - ./terraform-data:/terraform
      - ~/.aws:/root/.aws:ro
    environment:
      - AWS_ACCESS_KEY_ID
      - AWS_SECRET_ACCESS_KEY
      - AWS_SESSION_TOKEN
    stdin_open: true
    tty: true
EOF

# Create example terraform file
cat > terraform-data/main.tf << 'EOF'
# Example Terraform configuration file

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  # Uncomment to use a remote backend for state storage
  # backend "s3" {
  #   bucket = "my-terraform-state"
  #   key    = "terraform.tfstate"
  #   region = "us-west-2"
  # }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  tags = {
    Name = "example-instance"
  }
}
EOF

# Create gitignore file
cat > .gitignore << 'EOF'
# Terraform files
**/.terraform/*
*.tfstate
*.tfstate.*
*.tfvars
*.tfvars.json
crash.log
crash.*.log
*.tfplan
.terraformrc
terraform.rc
.terraform.lock.hcl

# Local .env files
.env
.env.*

# Docker files
.DS_Store
EOF

echo "Setup complete! Run the following commands to get started:"
echo "cd terraform-docker-project"
echo "docker-compose up -d"
echo "./connect.sh"
echo ""
echo "Your Terraform files will be stored in the terraform-data/ directory"