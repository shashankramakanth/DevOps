#!/bin/bash

# Check for required arguments
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <aws_access_key_id> <aws_secret_access_key> <aws_region>"
  exit 1
fi

export AWS_ACCESS_KEY_ID="$1"
export AWS_SECRET_ACCESS_KEY="$2"
export AWS_REGION="$3"

echo "Exported AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and AWS_REGION."

echo "Starting docker-compose with these environment variables..."
docker-compose up -d

# Connect to the terraform container
echo "Connecting to Terraform container..."
docker-compose exec terraform bash