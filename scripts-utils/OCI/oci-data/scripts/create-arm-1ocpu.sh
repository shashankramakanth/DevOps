#!/bin/bash

#####################################################
# ARM Instance Auto-Retry Script (1 OCPU, 6GB RAM)
# Works in: Local, Docker, CI/CD
#####################################################

set -euo pipefail  # Exit on error, undefined vars

# Colors (disabled in CI)
if [ -t 1 ]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  BLUE='\033[0;34m'
  NC='\033[0m'
else
  RED=''
  GREEN=''
  YELLOW=''
  BLUE=''
  NC=''
fi

echo "=================================================="
echo "  ARM INSTANCE AUTO-CREATION (1 OCPU, 6GB RAM)"
echo "=================================================="
echo ""

# Detect environment
if [ -f /.dockerenv ]; then
  ENV="Docker"
  CONFIG_DIR="/root/.oci"
elif [ -n "${CI:-}" ]; then
  ENV="CI/CD"
  CONFIG_DIR="/root/.oci"
else
  ENV="Local"
  CONFIG_DIR="$HOME/.oci"
fi

echo -e "${BLUE}Environment: $ENV${NC}"
echo ""

# Load configuration from environment or file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -n "${COMPARTMENT_OCID:-}" ]; then
  # CI/CD mode - use environment variables
  echo "Loading config from environment variables..."
elif [ -f "$SCRIPT_DIR/helios-oci-vars.sh" ]; then
  # Same directory as script
  source "$SCRIPT_DIR/helios-oci-vars.sh"
  echo "Loading config from $SCRIPT_DIR/helios-oci-vars.sh"
elif [ -f "$HOME/helios-oci-vars.sh" ]; then
  # Home directory
  source "$HOME/helios-oci-vars.sh"
  echo "Loading config from $HOME/helios-oci-vars.sh"
elif [ -f "/workspace/helios-oci-vars.sh" ]; then
  # Docker workspace
  source /workspace/helios-oci-vars.sh
  echo "Loading config from /workspace/helios-oci-vars.sh"
else
  echo -e "${RED}ERROR: Configuration not found!${NC}"
  echo "Create helios-oci-vars.sh in one of these locations:"
  echo "  - $SCRIPT_DIR/helios-oci-vars.sh"
  echo "  - $HOME/helios-oci-vars.sh"
  exit 1
fi

# Verify all variables are set
: "${COMPARTMENT_OCID:?ERROR: COMPARTMENT_OCID not set}"
: "${IMAGE_OCID:?ERROR: IMAGE_OCID not set}"
: "${SUBNET_OCID:?ERROR: SUBNET_OCID not set}"

# Setup availability domains - support both single AD and multi-AD
if [ -n "${AD:-}" ]; then
  # Legacy single AD mode
  ADS=("$AD")
  echo -e "${YELLOW}Using single AD mode: $AD${NC}"
elif [ -n "${AD_1:-}" ]; then
  # Multi-AD mode
  ADS=("${AD_1}" "${AD_2:-}" "${AD_3:-}")
  # Remove empty entries
  ADS=("${ADS[@]}")
  echo -e "${YELLOW}Using multi-AD mode: ${#ADS[@]} availability domains${NC}"
  for i in "${!ADS[@]}"; do
    echo "  AD $((i+1)): ${ADS[$i]}"
  done
else
  echo -e "${RED}ERROR: No availability domain configured!${NC}"
  echo "Set AD or AD_1/AD_2/AD_3 in helios-oci-vars.sh"
  exit 1
fi

NUM_ADS=${#ADS[@]}

# Configuration - 1 OCPU and 6GB RAM for ARM instance
SHAPE="${SHAPE:-VM.Standard.A1.Flex}"
OCPUS="${OCPUS:-1}"
MEMORY_GB="${MEMORY_GB:-6}"
DISPLAY_NAME="${DISPLAY_NAME:-arm-1ocpu-6gb}"
# SSH key - different paths for Docker vs Local
if [ "$ENV" == "Docker" ] || [ "$ENV" == "CI/CD" ]; then
  SSH_KEY_FILE="${SSH_KEY_FILE:-/root/.oci/ssh-key-2026-01-03.key.pub}"
else
  SSH_KEY_FILE="${SSH_KEY_FILE:-$SCRIPT_DIR/../oci-config/ssh-key-2026-01-03.key.pub}"
fi
MAX_ATTEMPTS="${MAX_ATTEMPTS:-288}"  # 48 hours at 10min intervals
RETRY_INTERVAL="${RETRY_INTERVAL:-600}"  # 10 minutes

# Verify SSH key exists
if [ ! -f "$SSH_KEY_FILE" ]; then
  echo -e "${RED}ERROR: SSH public key not found: $SSH_KEY_FILE${NC}"
  exit 1
fi

echo ""
echo -e "${BLUE}Configuration:${NC}"
echo "  Instance Name: $DISPLAY_NAME"
echo "  Shape: $SHAPE ($OCPUS OCPU, ${MEMORY_GB}GB RAM)"
echo "  Availability Domains: $NUM_ADS"
echo "  Max Attempts: $MAX_ATTEMPTS (across all ADs)"
echo "  Retry Interval: $((RETRY_INTERVAL / 60)) minutes"
echo ""
echo -e "${YELLOW}This script will cycle through all ADs until successful.${NC}"
echo ""

ROUND=1
MAX_ROUNDS="${MAX_ATTEMPTS:-288}"
START_TIME=$(date +%s)

while [ $ROUND -le $MAX_ROUNDS ]; do
  TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
  echo -e "${BLUE}[$TIMESTAMP] Round #$ROUND / $MAX_ROUNDS - Trying all $NUM_ADS availability domains${NC}"
  echo ""
  
  # Try each availability domain in this round
  for AD_INDEX in "${!ADS[@]}"; do
    CURRENT_AD="${ADS[$AD_INDEX]}"
    echo -e "${BLUE}  Trying AD $((AD_INDEX + 1))/$NUM_ADS: $CURRENT_AD${NC}"
    
    # Try to create instance
    RESULT=$(oci compute instance launch \
      --compartment-id "$COMPARTMENT_OCID" \
      --availability-domain "$CURRENT_AD" \
      --shape "$SHAPE" \
      --shape-config "{\"ocpus\":$OCPUS,\"memoryInGBs\":$MEMORY_GB}" \
      --image-id "$IMAGE_OCID" \
      --subnet-id "$SUBNET_OCID" \
      --display-name "$DISPLAY_NAME" \
      --assign-public-ip true \
      --ssh-authorized-keys-file "$SSH_KEY_FILE" \
      2>&1) || true
    
    if echo "$RESULT" | grep -q '"id"'; then
      # Success!
      echo ""
      echo "=================================================="
      echo -e "${GREEN}✅ SUCCESS! Instance created in $CURRENT_AD!${NC}"
      echo "=================================================="
      echo ""
      
      # Extract instance OCID
      INSTANCE_OCID=$(echo "$RESULT" | grep -o '"id": *"[^"]*"' | head -1 | cut -d'"' -f4)
      echo -e "${GREEN}Instance OCID:${NC} $INSTANCE_OCID"
      echo ""
      
      # Export for CI/CD
      if [ -n "${GITHUB_OUTPUT:-}" ]; then
        echo "instance_ocid=$INSTANCE_OCID" >> "$GITHUB_OUTPUT"
      fi
      
      # Wait for RUNNING state
      echo "Waiting for instance to reach RUNNING state..."
      for i in {1..60}; do
        STATE=$(oci compute instance get --instance-id "$INSTANCE_OCID" \
          --query 'data."lifecycle-state"' --raw-output 2>/dev/null || echo "UNKNOWN")
        
        if [ "$STATE" == "RUNNING" ]; then
          echo -e "${GREEN}Instance is RUNNING!${NC}"
          break
        else
          echo "  Current state: $STATE (waiting... $i/60)"
          sleep 10
        fi
      done
      
      # Get IPs
      echo ""
      echo "Fetching IP addresses..."
      sleep 5
      
      PUBLIC_IP=$(oci compute instance list-vnics --instance-id "$INSTANCE_OCID" \
        --query 'data[0]."public-ip"' --raw-output 2>/dev/null || echo "N/A")
      PRIVATE_IP=$(oci compute instance list-vnics --instance-id "$INSTANCE_OCID" \
        --query 'data[0]."private-ip"' --raw-output 2>/dev/null || echo "N/A")
      
      echo ""
      echo "=================================================="
      echo -e "${GREEN}INSTANCE DETAILS:${NC}"
      echo "=================================================="
      echo "Name:       $DISPLAY_NAME"
      echo "AD:         $CURRENT_AD"
      echo "Shape:      $SHAPE ($OCPUS OCPU, ${MEMORY_GB}GB RAM)"
      echo "Public IP:  $PUBLIC_IP"
      echo "Private IP: $PRIVATE_IP"
      echo "Username:   ubuntu"
      echo ""
      echo "SSH Command:"
      echo -e "${YELLOW}ssh ubuntu@$PUBLIC_IP${NC}"
      echo ""
      echo "=================================================="
      echo ""
      
      # Export for CI/CD
      if [ -n "${GITHUB_OUTPUT:-}" ]; then
        echo "public_ip=$PUBLIC_IP" >> "$GITHUB_OUTPUT"
        echo "private_ip=$PRIVATE_IP" >> "$GITHUB_OUTPUT"
      fi
      
      # Calculate elapsed time
      END_TIME=$(date +%s)
      ELAPSED=$((END_TIME - START_TIME))
      MINUTES=$((ELAPSED / 60))
      SECONDS=$((ELAPSED % 60))
      
      echo "Total time: ${MINUTES}m ${SECONDS}s across $ROUND rounds"
      echo ""
      
      # Save info to file (if not in CI)
      if [ -z "${CI:-}" ]; then
        INFO_FILE="${INFO_FILE:-$HOME/arm-instance-info.txt}"
        cat > "$INFO_FILE" <<INFOEOF
ARM INSTANCE (1 OCPU, 6GB RAM)
==============================

Created: $(date)
Environment: $ENV

Instance OCID: $INSTANCE_OCID
Availability Domain: $CURRENT_AD
Shape:         $SHAPE ($OCPUS OCPU, ${MEMORY_GB}GB RAM)
Public IP:     $PUBLIC_IP
Private IP:    $PRIVATE_IP
Username:      ubuntu

SSH Command:
ssh ubuntu@$PUBLIC_IP
INFOEOF
        
        echo -e "${GREEN}Instance details saved to: $INFO_FILE${NC}"
        echo ""
      fi
      
      exit 0
      
    else
      # Failed - check error type and show details
      if echo "$RESULT" | grep -qi "out of capacity\|out of host capacity"; then
        echo -e "    ${RED}❌ Out of capacity${NC}"
      elif echo "$RESULT" | grep -qi "service error"; then
        echo -e "    ${RED}❌ Service error:${NC}"
        echo "$RESULT" | grep -i "message\|code" | head -5 | sed 's/^/      /'
      else
        echo -e "    ${RED}❌ Failed:${NC}"
        echo "$RESULT" | head -10 | sed 's/^/      /'
      fi
    fi
    
    # Small delay between AD attempts (2 seconds)
    sleep 2
  done
  
  echo ""
  
  # Sleep before next round (only if not last round)
  if [ $ROUND -lt $MAX_ROUNDS ]; then
    NEXT_ATTEMPT_TIME=$(date -d "+$((RETRY_INTERVAL / 60)) minutes" '+%H:%M' 2>/dev/null || \
                        date -v +$((RETRY_INTERVAL / 60))M '+%H:%M' 2>/dev/null || \
                        echo "$(date '+%H:%M')")
    echo -e "${YELLOW}All ADs tried. Next round at approximately: $NEXT_ATTEMPT_TIME${NC}"
    echo ""
    sleep $RETRY_INTERVAL
  fi
  
  ROUND=$((ROUND + 1))
done

echo ""
echo "=================================================="
echo -e "${RED}❌ FAILED: Max attempts ($MAX_ATTEMPTS) reached${NC}"
echo "=================================================="
echo ""
echo "Capacity has been unavailable for extended period."
echo "Suggestions:"
echo "  1. Try different availability domain"
echo "  2. Try different region"
echo "  3. Try at different time (2-5 AM local time tends to have better availability)"
echo "  4. Consider using x86 instances as fallback"
echo ""

exit 1
