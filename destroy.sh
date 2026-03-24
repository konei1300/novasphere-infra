#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TF_DIR="${SCRIPT_DIR}/terraform/aws"

echo "=== Destruction de l'infrastructure NovaSphere ==="
cd "${TF_DIR}"
terraform destroy -auto-approve

echo ""
echo "Infrastructure détruite avec succès."
