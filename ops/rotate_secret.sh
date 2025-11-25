#!/bin/bash
set -euo pipefail

# Check required env vars
if [[ -z "${SECRET_NAME:-}" ]]; then
  echo "❌ ERROR: SECRET_NAME environment variable is not set."
  exit 1
fi

if [[ -z "${SECRET_VALUE:-}" ]]; then
  echo "❌ ERROR: SECRET_VALUE environment variable is not set."
  exit 1
fi

# Get the current secret for backup
echo "Getting current secret: $SECRET_NAME"
CURRENT_SECRET=$(aws secretsmanager get-secret-value \
    --secret-id "$SECRET_NAME" \
    --query SecretString \
    --output text)

if [[ -z "$CURRENT_SECRET" ]]; then
  echo "❌ ERROR: Could not retrieve current secret."
  exit 1
fi

# Backup the current secret before updating
BACKUP_SECRET_NAME="${SECRET_NAME}-backup-$(date +%Y%m%d-%H%M%S)"
echo "Creating backup: $BACKUP_SECRET_NAME"
aws secretsmanager create-secret \
    --name "$BACKUP_SECRET_NAME" \
    --secret-string "$CURRENT_SECRET" \
    --description "Backup of $SECRET_NAME created before update on $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "✅ Backup created: $BACKUP_SECRET_NAME"

# Update secret in AWS Secrets Manager
aws secretsmanager put-secret-value \
    --secret-id "$SECRET_NAME" \
    --secret-string "$SECRET_VALUE"

echo "✅ Secret '$SECRET_NAME' rotated successfully."
