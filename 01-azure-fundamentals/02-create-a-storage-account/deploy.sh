#Validate storage account ARM template
az deployment group validate --resource-group <> --name storageaccountcreate --template-file storage-account-arm.json

#Deploy storage account
az deployment group create --resource-group <> --name storageaccountcreate --template-file storage-account-arm.json

#Modify storage account ARM deployment
az deployment group create \
  --resource-group <> \
  --name updatetogrs \
  --template-file storage-account-arm.json \
  --mode Incremental

# See what changes will be made before deploying
az deployment group what-if \
  --resource-group <> \
  --template-file storage-account-arm.json \
  --mode Incremental

#Deploy storage account with parameters
az deployment group create \
  --resource-group <> \
  --name storageaccountcreate \
  --template-file storage-account-arm.json \
  --parameters storageAccountTier=Premium  \
  --mode Incremental
