#!/bin/bash

#####################################################
# Helios Master ARM Instance Auto-Retry Script
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
echo "  HELIOS MASTER - ARM INSTANCE AUTO-CREATION"
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
if [ -n "${COMPARTMENT_OCID:-}" ]; then
  # CI/CD mode - use environment variables
  echo "Loading config from environment variables..."
else
  # Local/Docker mode - load from file
  if [ -f "$HOME/helios-oci-vars.sh" ]; then
    source "$HOME/helios-oci-vars.sh"
  elif [ -f "/workspace/helios-oci-vars.sh" ]; then
    source /workspace/helios-oci-vars.sh
  else
    echo -e "${RED}ERROR: Configuration not found!${NC}"
    echo "Set environment variables or create helios-oci-vars.sh"
    exit 1
  fi
fi

# Verify all variables are set
: "${COMPARTMENT_OCID:?ERROR: COMPARTMENT_OCID not set}"
: "${AD:?ERROR: AD not set}"
: "${IMAGE_OCID:?ERROR: IMAGE_OCID not set}"
: "${SUBNET_OCID:?ERROR: SUBNET_OCID not set}"

# Configuration
SHAPE="${SHAPE:-VM.Standard.A1.Flex}"
OCPUS="${OCPUS:-2}"
MEMORY_GB="${MEMORY_GB:-12}"
DISPLAY_NAME="${DISPLAY_NAME:-helios-master}"
SSH_KEY_FILE="${SSH_KEY_FILE:-$HOME/.ssh/id_rsa.pub}"
MAX_ATTEMPTS="${MAX_ATTEMPTS:-288}"  # 48 hours at 10min intervals
RETRY_INTERVAL="${RETRY_INTERVAL:-600}"  # 10 minutes

# Verify SSH key exists
if [ ! -f "$SSH_KEY_FILE" ]; then
  echo -e "${RED}ERROR: SSH public key not found: $SSH_KEY_FILE${NC}"
  exit 1
fi

echo -e "${BLUE}Configuration:${NC}"
echo "  Instance Name: $DISPLAY_NAME"
echo "  Shape: $SHAPE ($OCPUS OCPU, ${MEMORY_GB}GB RAM)"
echo "  Max Attempts: $MAX_ATTEMPTS"
echo "  Retry Interval: $((RETRY_INTERVAL / 60)) minutes"
echo ""
echo -e "${YELLOW}This script will retry until successful or max attempts reached.${NC}"
echo ""

ATTEMPT=1
START_TIME=$(date +%s)

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
  TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
  echo -e "${BLUE}[$TIMESTAMP] Attempt #$ATTEMPT / $MAX_ATTEMPTS${NC}"
  
  # Try to create instance
  RESULT=$(oci compute instance launch \
    --compartment-id "$COMPARTMENT_OCID" \
    --availability-domain "$AD" \
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
    echo -e "${GREEN}✅ SUCCESS! Instance created!${NC}"
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
    
    echo "Total time: ${MINUTES}m ${SECONDS}s across $ATTEMPT attempts"
    echo ""
    
    # Save info to file (if not in CI)
    if [ -z "${CI:-}" ]; then
      INFO_FILE="${INFO_FILE:-$HOME/helios-master-info.txt}"
      cat > "$INFO_FILE" <<INFOEOF
HELIOS MASTER NODE
==================

Created: $(date)
Environment: $ENV

Instance OCID: $INSTANCE_OCID
Public IP:     $PUBLIC_IP
Private IP:    $PRIVATE_IP
Username:      ubuntu

SSH Command:
ssh ubuntu@$PUBLIC_IP

Next Steps:
1. SSH into the instance
2. Run Phase 1 setup commands
3. Create worker nodes
INFOEOF
      
      echo -e "${GREEN}Instance details saved to: $INFO_FILE${NC}"
      echo ""
    fi
    
    exit 0
    
  else
    # Failed - check error type
    if echo "$RESULT" | grep -qi "out of capacity\|out of host capacity"; then
      echo -e "${RED}❌ Out of capacity${NC}"
    elif echo "$RESULT" | grep -qi "service error"; then
      echo -e "${RED}❌ Service error:${NC}"
      echo "$RESULT" | grep -i "service error" | head -3
    else
      echo -e "${RED}❌ Unknown error:${NC}"
      echo "$RESULT" | head -5
    fi
    
    echo ""
    
    if [ $ATTEMPT -lt $MAX_ATTEMPTS ]; then
      NEXT_ATTEMPT_TIME=$(date -d "+$((RETRY_INTERVAL / 60)) minutes" '+%H:%M' 2>/dev/null || \
                          date -v +$((RETRY_INTERVAL / 60))M '+%H:%M' 2>/dev/null || \
                          echo "$(date '+%H:%M')")
      echo "Next attempt at approximately: $NEXT_ATTEMPT_TIME"
      echo ""
      sleep $RETRY_INTERVAL
    fi
  fi
  
  ATTEMPT=$((ATTEMPT + 1))
done

echo ""
echo "=================================================="
echo -e "${RED}❌ FAILED: Max attempts ($MAX_ATTEMPTS) reached${NC}"
echo "=================================================="
echo ""
echo "Capacity has been unavailable for extended period."
echo "Suggestions:"
echo "  1. Try different availability domain"
echo "  2. Try different region (create new account)"
echo "  3. Try at different time (2-5 AM IST best)"
echo "  4. Use x86 instances as fallback"
echo ""

exit 1