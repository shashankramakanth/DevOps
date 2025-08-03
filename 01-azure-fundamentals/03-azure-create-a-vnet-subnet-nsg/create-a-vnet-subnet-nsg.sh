#!/bin/bash

#Use this script as a reference to create/modify a Virtual Network, Subnet, and Network Security Group in Azure

#-----------Command to create a Virtual Network in Azure-----------
az network vnet create \
--resource-group <resource_group_name> \
--name azCliVnet01 \
--address-prefixes 10.0.0.0/16 \
--subnet-name <subnet_name> \
--subnet-prefixes 10.0.1.0/24
#-------------------------------------------------------------------

#-----------Command to add a subnet to a vnet in Azure----------
az network vnet subnet create \
--resource-group <resource_group_name> \
--name <subnet_name> \
--address-prefixes 10.0.2.0/24 \
--vnet-name <vnet_name>
#-------------------------------------------------------------------

#-----------Command to modify  a Network Security Group in Azure-----------
az network nsg rule create \
--resource-group <resource_group_name> \
--nsg-name <nsg_name> \
--name <rule_name> \
--protocol <tcp/udp/icmp/any> \
--priority 100 \
--destination-port-ranges <80-http, 443-https> \
--access allow \
--direction Inbound \
--source-address-prefixes "*" \
--source-port-ranges "*" \
--destination-port-ranges "*"
#-------------------------------------------------------------------

