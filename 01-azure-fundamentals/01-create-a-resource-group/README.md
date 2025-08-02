# Create an Azure Resource Group

This script, `create-a-resource-group.sh`, automates the creation of a resource group in Microsoft Azure.

## Prerequisites

Before running the script, ensure you have the following:

1.  **Azure CLI**: You must have the Azure Command-Line Interface installed on your machine. You can find installation instructions here.
2.  **Authenticated Azure Account**: You need to be logged into an Azure account with permissions to create resource groups. You can log in by running:
    ```bash
    az login
    ```

## Usage

To use the script, make it executable and run it with the required parameters.

```bash
chmod +x create-a-resource-group.sh
./create-a-resource-group.sh <resource-group-name> <location>
```

### Parameters

-   `<resource-group-name>`: (Required) The name of the resource group you want to create.
-   `<location>`: (Required) The Azure region where the resource group should be created (e.g., `eastus`, `westus2`).

## Example

To create a resource group named `MyTestResourceGroup` in the `East US` region:

```bash
./create-a-resource-group.sh MyTestResourceGroup eastus
```

### Successful Output

If the resource group is created successfully, the `az group create` command will output the JSON representation of the new resource group, followed by a success message from the script:

```
Resource Group 'MyTestResourceGroup' created successfully in 'eastus'.
```

### Failure Output

If the creation fails, you will see a message like this:

```
Failed to create Resource Group 'MyTestResourceGroup'. Please check the parameters and try again.
```