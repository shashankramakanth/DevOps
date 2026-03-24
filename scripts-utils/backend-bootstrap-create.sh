#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BACKEND_DIR="$REPO_ROOT/02-infrastructure-as-code/terraform-aws/global/backend-bootstrap"
CLEANUP_SCRIPT="$BACKEND_DIR/cleanup-backend.sh"
PLAN_FILE="backend-bootstrap.tfplan"

log_step() {
  printf '\n[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1"
}

if ! command -v terraform >/dev/null 2>&1; then
  echo "Error: terraform is not installed or not in PATH." >&2
  exit 127
fi

if [[ ! -d "$BACKEND_DIR" ]]; then
  echo "Error: backend-bootstrap directory not found: $BACKEND_DIR" >&2
  exit 1
fi

if [[ ! -f "$CLEANUP_SCRIPT" ]]; then
  echo "Error: cleanup script not found: $CLEANUP_SCRIPT" >&2
  exit 1
fi

log_step "Switching to backend-bootstrap directory"
cd "$BACKEND_DIR"

log_step "Running cleanup script"
bash "./cleanup-backend.sh"

log_step "Running terraform init"
terraform init

log_step "Running terraform plan"
terraform plan -out="$PLAN_FILE"

log_step "Applying planned changes"
terraform apply -auto-approve "$PLAN_FILE"

log_step "Backend bootstrap completed"
