#!/bin/bash
set -e

ENVIRONMENTS=("dev")
DRIFT_FOUND=false
BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)/02-infrastructure-as-code/terraform-aws"

for ENV in "${ENVIRONMENTS[@]}"; do
  echo "Checking $ENV..."
  cd "$BASE_DIR/envs/$ENV"

  terraform init -input=false -no-color > /dev/null

  set +e
PLAN_OUTPUT=$(terraform plan -detailed-exitcode -refresh-only -no-color -input=false 2>&1)
EXIT_CODE=$?
echo "$PLAN_OUTPUT"
set -e

if echo "$PLAN_OUTPUT" | grep -q "No changes"; then
  echo "No drift in $ENV"
elif [ $EXIT_CODE -eq 2 ]; then
  echo "DRIFT DETECTED in $ENV"
  DRIFT_FOUND=true
else
  echo "ERROR checking $ENV"
  exit 1
fi
done

if $DRIFT_FOUND; then
  echo "Drift detected in one or more environments"
  exit 1
fi

echo "All environments clean"
exit 0