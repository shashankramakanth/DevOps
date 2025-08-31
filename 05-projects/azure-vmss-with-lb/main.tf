locals {
nsg_rules = {
      "allow_lb_health_probe" = {
            name                       = "Allow-LB-HealthProbe"
            priority                   = 100
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_range     = "80"
            # only allow traffic from the LB
            source_address_prefix      = "AzureLoadBalancer"
            destination_address_prefix = "*"
      },
      "deny_all_inbound" = {
            name                       = "Deny-All-Inbound"
            priority                   = 4096 # Lowest priority
            direction                  = "Inbound"
            access                     = "Deny"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
      }
}
    common_tags = {
        environment = var.environment
        created_by  = "Terraform"
        #Date in YYYY-MM-DD format
        modified_on = formatdate("YYYY-MM-DD", timestamp())
    }
    name_prefix = "$(var.resource_prefix)"

    vm_sizes = {
        Production     = "Standard_B1s"
        Development    = "Standard_B2s"
        Testing        = "Standard_B2ms"
    }
}

#1. Create a resource group
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

#2. Create a virtual network 
resource "azurerm_virtual_network" "vnet01"{
    name = "${local.name_prefix}vnet01"
    resource_group_name = data.azurerm_resource_group.rg.name
    location = data.azurerm_resource_group.rg.location
    address_space = ["10.0.0.0/16"]
    tags = {
        environment = local.common_tags.environment
        created_by  = local.common_tags.created_by
        modified_on = local.common_tags.modified_on
}
}
#3. Create an application subnet
resource "azurerm_subnet" "application_subnet" {
    name = "${local.name_prefix}-${azurerm_virtual_network.vnet01.name}-appsubnet"
    resource_group_name = data.azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet01.name
    address_prefixes = ["10.0.1.0/24"]
}

#4. Create a management subnet
resource "azurerm_subnet" "management_subnet" {
    name = "${local.name_prefix}-${azurerm_virtual_network.vnet01.name}-managementsubnet"
    resource_group_name = data.azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet01.name
    address_prefixes = ["10.0.6.0/24"]
}

#5. Create a network security group
resource "azurerm_network_security_group" "nsg" {
  name                = "example-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_ranges    = security_rule.value.destination_port_ranges
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }

  }

  tags = {
    environment = local.common_tags.environment
    created_by  = local.common_tags.created_by
    modified_on = local.common_tags.modified_on
  }
}

#6. Associate the NSG to the application subnet
resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.application_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

#7. Create a public ip address for load balancer
resource "azurerm_public_ip" "pip01" {
    name                = "${local.name_prefix}-pip01"
    location            = data.azurerm_resource_group.rg.location
    resource_group_name = data.azurerm_resource_group.rg.name
    allocation_method   = "Static"
    sku                 = "Standard"
    tags = {
        environment = local.common_tags.environment
        created_by  = local.common_tags.created_by
        modified_on = local.common_tags.modified_on
    }
}
#8. Create a load balancer
resource "azurerm_lb" "lb" {
    name                = "${local.name_prefix}-lb01"
    location            = data.azurerm_resource_group.rg.location
    resource_group_name = data.azurerm_resource_group.rg.name
    sku                 = "Standard"
    frontend_ip_configuration {
        name                 = "PublicIPAddress"
        public_ip_address_id = azurerm_public_ip.pip01.id
    }
    tags = {
        environment = local.common_tags.environment
        created_by  = local.common_tags.created_by
        modified_on = local.common_tags.modified_on
    }
}

#9. Create a backend address pool
resource "azurerm_lb_backend_address_pool" "bap" {
    loadbalancer_id     = azurerm_lb.lb.id
    name                = "${local.name_prefix}-bap01"
}  

#10. Create a health probe
resource "azurerm_lb_probe" "health_probe" {
    loadbalancer_id     = azurerm_lb.lb.id
    name                = "${local.name_prefix}-healthprobe01"
    protocol            = "Http"
    request_path        = "/"
    port                = 80
    interval_in_seconds = 5
    number_of_probes    = 2
}   


#11. Create a load balancer rule
resource "azurerm_lb_rule" "lbrule" {
    loadbalancer_id            = azurerm_lb.lb.id
    name                       = "${local.name_prefix}-lbrule01"
    protocol                   = "Tcp"
    frontend_port              = 80
    backend_port               = 80
    frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
    backend_address_pool_ids    = [azurerm_lb_backend_address_pool.bap.id]
    probe_id                   = azurerm_lb_probe.health_probe.id
    enable_floating_ip         = false
    idle_timeout_in_minutes    = 4
    load_distribution          = "Default"
}

#12. Create a virtual machine scale set
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
    name                = "${local.name_prefix}-vmss01"
    resource_group_name = data.azurerm_resource_group.rg.name
    location            = data.azurerm_resource_group.rg.location
    sku                 = lookup(local.vm_sizes, var.environment, "Standard_B1s")
    instances           = 2
    custom_data = base64encode(file("user-data.sh"))
    #Required: OS configuration
    source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  #Required: Storage configuration
    os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  #Required: Network configuration
    network_interface {
        name    = "${local.name_prefix}-vmss-nic"
        primary = true

        ip_configuration {
            name                                   = "${local.name_prefix}-vmss-ipconfig"
            subnet_id                              = azurerm_subnet.application_subnet.id
            primary                                = true
            load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bap.id]
        }
    }

    #Required: Admin configuration
    admin_username = "azureuser"
    admin_ssh_key {
        username   = "azureuser"
        public_key = file("~/.ssh/id_rsa.pub") #replace with your public
}
}

resource "azurerm_monitor_autoscale_setting" "autoscale" {
    name                = "${local.name_prefix}-autoscale"
    resource_group_name = data.azurerm_resource_group.rg.name
    location            = data.azurerm_resource_group.rg.location
    target_resource_id  = azurerm_linux_virtual_machine_scale_set.vmss.id

    profile {
        name = "AutoScaleProfile"
        capacity {
            minimum = "2"
            maximum = "5"
            default = "2"
        }

        rule {
            metric_trigger {
                metric_name        = "Percentage CPU"
                metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
                time_grain         = "PT1M"
                statistic         = "Average"
                time_window       = "PT5M"
                time_aggregation  = "Average"
                operator          = "GreaterThan"
                threshold         = 80
            }

            scale_action {
                direction = "Increase"
                type      = "ChangeCount"
                value     = "1"
                cooldown  = "PT5M"
            }
        }

        rule {
            metric_trigger {
                metric_name        = "Percentage CPU"
                metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
                time_grain         = "PT1M"
                statistic         = "Average"
                time_window       = "PT5M"
                time_aggregation  = "Average"
                operator          = "LessThan"
                threshold         = 10
            }

            scale_action {
                direction = "Decrease"
                type      = "ChangeCount"
                value     = "1"
                cooldown  = "PT5M"
            }
        }
    }

    tags = {
        environment = local.common_tags.environment
        created_by  = local.common_tags.created_by
        modified_on = local.common_tags.modified_on
    }
  
}