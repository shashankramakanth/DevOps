#!/bin/bash
#####################################################
# OCI Configuration for ARM Instance Creation
# Fill in your values below
#####################################################

# Required: Your OCI Compartment OCID
# Find at: OCI Console → Identity → Compartments → Copy OCID
export COMPARTMENT_OCID="ocid1.compartment.oc1..aaaaaaaa5b2fdmhqppqz3xunjlct3zzowlxtuylcgrsrrxfq6x43kfsgizua"

# Required: Availability Domains (script will cycle through all 3)
# Find at: OCI Console → Compute → Availability Domains
# The script tries each AD in sequence before retrying
export AD_1="eJSr:US-ASHBURN-AD-1"
export AD_2="eJSr:US-ASHBURN-AD-2"
export AD_3="eJSr:US-ASHBURN-AD-3"

# Legacy single AD (optional, overrides multi-AD if set)
# export AD="AP-MUMBAI-1-AD-1"

# Required: Image OCID (Ubuntu ARM recommended for free tier)
# Find at: OCI Console → Compute → Images → Platform Images → Filter by ARM
# Select "Canonical Ubuntu" with aarch64 architecture
export IMAGE_OCID="ocid1.image.oc1.iad.aaaaaaaa5lh4ly5pkbwb6rnvgrc6v7zspxp4hrffzrawxrzowlemfrsbdv6a"

# Required: Subnet OCID
# Find at: OCI Console → Networking → Virtual Cloud Networks → Your VCN → Subnets → Copy OCID
export SUBNET_OCID="ocid1.subnet.oc1.iad.aaaaaaaaktmhgc4sypjsn3v4fhoiee3kskrm564slg6y7clpkxfxuhhmwraq"

#####################################################
# Optional: Override defaults (uncomment to use)
#####################################################

# Instance display name
export DISPLAY_NAME="helios-master-01"

# SSH key file path (default: ~/.ssh/id_rsa.pub)
# export SSH_KEY_FILE="$HOME/.ssh/id_rsa.pub"

# ARM shape configuration
# export SHAPE="VM.Standard.A1.Flex"
# export OCPUS=2
# export MEMORY_GB=12

# Retry settings
# export MAX_ATTEMPTS=288       # Total attempts (288 = 48 hours at 10min intervals)
# export RETRY_INTERVAL=600     # Seconds between retries (600 = 10 minutes)
