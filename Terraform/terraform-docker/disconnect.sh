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
