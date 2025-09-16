#command to create a keyvault

# Create a resource group first (if you don't have one)
az group create \
  --name "rg-keyvault-demo" \
  --location "eastus"

# Create Key Vault with recommended security settings
az keyvault create \
  --name "myapp-prod-kv-001" \
  --resource-group "rg-keyvault-demo" \
  --location "eastus" \
  --sku "standard" \
  --enable-rbac-authorization true \
  --enable-soft-delete true \
  --enable-purge-protection true \
  --retention-days 90 \
  --default-action "Deny" \
  --bypass "AzureServices"

#---------------------
#Create a service principal and assign it access to the key vault
#---------------------

# Create without any default role (recommended)
az ad sp create-for-rbac \
  --name "myapp-keyvault-sp" \
  --skip-assignment

# Output will look like:
# {
#   "appId": "12345678-1234-1234-1234-123456789012",
#   "displayName": "myapp-keyvault-sp",
#   "password": "generated-password-here",
#   "tenant": "87654321-4321-4321-4321-210987654321"
# }

#store the output values from above in variables
# Create and store the output
SP_OUTPUT=$(az ad sp create-for-rbac --name "myapp-keyvault-sp" --skip-assignment)

# Extract values
APP_ID=$(echo $SP_OUTPUT | jq -r '.appId')
SP_PASSWORD=$(echo $SP_OUTPUT | jq -r '.password')
TENANT_ID=$(echo $SP_OUTPUT | jq -r '.tenant')

echo "App ID: $APP_ID"
echo "Password: $SP_PASSWORD"  # Store this securely!
echo "Tenant ID: $TENANT_ID"


# Get the object ID of the service principal (needed for RBAC)
SP_OBJECT_ID=$(az ad sp show --id $APP_ID --query id -o tsv)
echo "Service Principal Object ID: $SP_OBJECT_ID"

# Assign the "Key Vault Secrets User" role to the service principal at the Key Vault scope
# Assign Key Vault Secrets User role (read-only)
az role assignment create \
  --assignee-object-id $SP_OBJECT_ID \
  --role "Key Vault Secrets User" \
  --scope "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/rg-keyvault-demo/providers/Microsoft.KeyVault/vaults/myapp-kv-001"