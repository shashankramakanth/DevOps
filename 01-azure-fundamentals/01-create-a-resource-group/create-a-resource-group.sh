#!/bin/bash

#Azure Resource Group Creation Script
# This script creates a new Azure Resource Group
# Usage: ./create-a-resource-group.sh <resource-group-name> <location>

resource_group_name=$1
location=$2

#---------basic script to create a resource group in Azure---------
az group create --name $resource_group_name --location $location

if [ $? -eq 0 ]; then
    echo "Resource Group '$resource_group_name' created successfully in '$location'."
else
    echo "Failed to create Resource Group '$resource_group_name'. Please check the parameters and try again."
fi
# End of script
#---------------------------------------------------------------