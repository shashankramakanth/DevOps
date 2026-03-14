#!/bin/bash
# cleanup-backend.sh
# Cleans up lingering local Terraform files across all environments
# Run this after a sandbox shutdown to start fresh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${YELLOW}🧹 Terraform Local Cleanup${NC}"
echo "   Project root: $PROJECT_ROOT"
echo ""

# Files and directories to clean
PATTERNS=(
    ".terraform"
    ".terraform.lock.hcl"
    "terraform.tfstate"
    "terraform.tfstate.backup"
    "*.tfplan"
    "crash.log"
)

CLEANED=0

# Find and clean across the entire project
for pattern in "${PATTERNS[@]}"; do
    while IFS= read -r -d '' item; do
        rel_path="${item#$PROJECT_ROOT/}"
        if [ -d "$item" ]; then
            echo -e "  ${CYAN}removing dir:${NC}  $rel_path"
            rm -rf "$item"
        else
            echo -e "  ${CYAN}removing file:${NC} $rel_path"
            rm -f "$item"
        fi
        ((CLEANED++))
    done < <(find "$PROJECT_ROOT" -name "$pattern" -print0 2>/dev/null)
done

echo ""
if [ "$CLEANED" -gt 0 ]; then
    echo -e "${GREEN}✅ Cleaned up $CLEANED item(s)${NC}"
else
    echo -e "${GREEN}✅ Nothing to clean — already tidy!${NC}"
fi
