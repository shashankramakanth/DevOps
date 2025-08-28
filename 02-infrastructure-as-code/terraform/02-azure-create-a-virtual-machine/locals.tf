locals {
    nsg_rules = {
       "allow_http" = {
            name                       = "Allow-http"
            priority                   = 1000
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_ranges    = "80"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
    },
    "allow_https" = {
            name                       = "Allow-https"
            priority                   = 1001
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_ranges    = "443"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
    }
}
}