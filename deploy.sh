#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TF_DIR="${SCRIPT_DIR}/terraform/aws"
ANSIBLE_DIR="${SCRIPT_DIR}/ansible"
INVENTORY="${ANSIBLE_DIR}/inventory/hosts_generated.yml"

echo "=== 1/4 — Provisioning (Terraform) ==="
cd "${TF_DIR}"
terraform init -input=false
terraform apply -auto-approve

echo ""
echo "=== 2/4 — Attente du démarrage EC2 (30s) ==="
sleep 30

echo ""
echo "=== 3/4 — Configuration (Ansible) ==="
cd "${ANSIBLE_DIR}"
ansible-playbook -i "${INVENTORY}" playbook.yml \
  --vault-password-file ~/.vault_pass

echo ""
echo "=== 4/4 — Vérification ==="
PUBLIC_IP=$(cd "${TF_DIR}" && terraform output -raw public_ip)
echo "Page NovaSphere : http://${PUBLIC_IP}"
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" "http://${PUBLIC_IP}"

echo ""
echo "Pipeline terminé avec succès."
