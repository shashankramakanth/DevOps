**Overview**
Create a scalable web application infrastructure in Azure using terraform. The infrastructure will include a Virtual Machine Scale Set(VMSS) behind a load balancer with proper security and scaling configurations.


**Requirements**

**Resource Group**
- Create a resource group
  In case of a sandbox, use the provided resource group and declare it as a data block

**Networking**
1. Create a VNET with two subnets
    - Application Subnet (for VMSS)
    - Management Subnet (for future use)

2. Configure an NSG that:
    - Only allows traffic from the load balancer to VMSS
    - Uses dynamic blocks for rule configuration
    - Denies all other inbound traffic

**Compute**
1. Create a VMSS
    - Ubuntu 20.04 LTS
    - VM Sizes with conditions based on environment(use lookup function)
        - Dev: Standard_B1s
        - Test: Standard_B2s
        - Prod: Standard_B2ms

2. Configure auto-scaling
    - Scale in when CPU usage is below 10%
    - Scale out when CPU usage is above 80%
    - Default instances: 3
    - Minimum instances: 2
    - Maximum instances: 5

**Load Balancer**
1. Create a load balancer
    - Public IP
    - Backend Pool connected to VMSS
    - Health probe on port 80

---
**Technical Requirements**

**Variables**
1. Create a terraform.tfvars file with:
    - Environment name
    - Region
    - Resource name prefix
    - Instance counts
    - Network address spaces

**Locals**
1. Implement locals block for:
    - Common tags
    - Resource naming convention
    - Network configuration

**Dynamic Blocks**
1. Use dynamic blocks for:
    - NSG rules
    - Load Balancer rules



**Note**
- Ensure that every resource has a "modified_on" tag which should have the value of the current timestamp based on YYYY-MM-DD format in terraform

- Autoscaling rules: cpu < 10 = scale in, cpu > 80 = scale out

- NSG should only allow incoming traffic from loadbalancer to the backend pool(VMSS)

- set env var for everything

- use locals wherever possible to make the code managable

- use dynamic block for NSG

- use map for VM size based on the environment name


---
Credits: https://github.com/piyushsachdeva/Terraform-Full-Course-Azure/
