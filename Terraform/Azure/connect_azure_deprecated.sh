#!/bin/bash

# Script to connect to Azure using Docker container with Azure CLI and Terraform
# Usage: ./connect_azure.sh <client_id> <client_secret> <tenant_id>
# Note: Azure credentials are NOT persisted - perfect for sandbox environments

set -e

# Check if required arguments are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <client_id> <client_secret> <tenant_id>"
    echo "Example: $0 your-client-id your-client-secret your-tenant-id"
    exit 1
fi

CLIENT_ID="$1"
CLIENT_SECRET="$2"
TENANT_ID="$3"

# Create persistent data directory if it doesn't exist (only for workspace)
DATA_DIR="./azure-data"
CACHE_DIR="./terraform-cache"
mkdir -p "$DATA_DIR" "$CACHE_DIR"

echo "Starting Azure CLI and Terraform container..."
echo "Client ID: $CLIENT_ID"
echo "Tenant ID: $TENANT_ID"
echo "Note: Azure credentials will NOT be persisted (sandbox-friendly)"

# Export environment variables for docker-compose
export AZURE_CLIENT_ID="$CLIENT_ID"
export AZURE_CLIENT_SECRET="$CLIENT_SECRET"
export AZURE_TENANT_ID="$TENANT_ID"

# Start the Docker container
docker-compose up -d

# Wait for container to be ready
echo "Waiting for container to start..."
sleep 3

# Test Azure authentication (this won't persist the login)
echo "Testing Azure authentication..."
docker-compose exec azure-terraform az login --service-principal \
    --username "$CLIENT_ID" \
    --password "$CLIENT_SECRET" \
    --tenant "$TENANT_ID"

# Verify authentication
echo "Verifying Azure connection..."
docker-compose exec azure-terraform az account show

echo ""
echo "✅ Azure connection successful!"
echo ""
echo "🔑 Authentication Details:"
echo "   - Credentials are set via environment variables"
echo "   - Azure profile is NOT persisted (perfect for sandbox)"
echo "   - Terraform cache IS persisted for performance"
echo ""
echo "📝 Usage:"
echo "   Interactive shell:     docker-compose exec azure-terraform bash"
echo "   Azure CLI:            docker-compose exec azure-terraform az <command>"
echo "   Terraform:            docker-compose exec azure-terraform terraform <command>"
echo ""
echo "📁 File Locations:"
echo "   Terraform files:      ./azure-data/"
echo "   Terraform cache:      ./terraform-cache/"
echo ""
echo "🛑 To stop:"
echo "   docker-compose down"
echo ""
echo "💡 Tip: Each time you run this script, you get a fresh Azure session!"