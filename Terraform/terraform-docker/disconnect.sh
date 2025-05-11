#!/bin/bash

# Check if the terraform container is running
CONTAINER_RUNNING=$(docker-compose ps -q terraform)

if [ -z "$CONTAINER_RUNNING" ]; then
  echo "Terraform container is not running."
else
  echo "Stopping Terraform container..."
  docker-compose down
  if [ $? -ne 0 ]; then
    echo "Failed to stop Terraform container. Please check your Docker setup."
    exit 1
  fi
  echo "Terraform container stopped successfully."
fi

# Unset AWS environment variables
echo "Unsetting AWS environment variables..."
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
echo "AWS environment variables unset."
