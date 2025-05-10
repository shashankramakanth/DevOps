#!/bin/bash

# Check if AWS profile is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <aws_profile>"
  exit 1
fi

AWS_PROFILE="$1"

# Perform AWS SSO login
echo "Logging in to AWS SSO for profile $AWS_PROFILE..."
aws sso login --profile $AWS_PROFILE
if [ $? -ne 0 ]; then
  echo "AWS SSO login failed. Please check your AWS configuration."
  exit 1
fi

# Export AWS credentials to the environment
echo "Exporting AWS credentials for profile $AWS_PROFILE..."
eval "$(aws configure export-credentials --profile $AWS_PROFILE --format env)"
if [ $? -ne 0 ]; then
  echo "Failed to export AWS credentials. Please check your AWS configuration."
  exit 1
fi

# Check if the terraform container is running
CONTAINER_RUNNING=$(docker-compose ps -q terraform)

if [ -z "$CONTAINER_RUNNING" ]; then
  echo "Terraform container is not running. Starting it now..."
  docker-compose up -d
  if [ $? -ne 0 ]; then
    echo "Failed to start Terraform container. Please check your Docker setup."
    exit 1
  fi
else
  echo "Terraform container is already running."
fi

# Connect to the terraform container
echo "Connecting to Terraform container..."
docker-compose exec terraform bash

# Print helpful message if command fails
if [ $? -ne 0 ]; then
  echo "Failed to connect to Terraform container."
  echo "Please make sure:"
  echo "1. Docker is running"
  echo "2. You're in the correct directory with docker-compose.yml"
  echo "3. Try running 'docker-compose up -d' first"
fi