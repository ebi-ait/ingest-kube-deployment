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

# Update secret in AWS Secrets Manager
aws secretsmanager put-secret-value \
    --secret-id "$SECRET_NAME" \
    --secret-string "$SECRET_VALUE"

echo "✅ Secret '$SECRET_NAME' rotated successfully."
