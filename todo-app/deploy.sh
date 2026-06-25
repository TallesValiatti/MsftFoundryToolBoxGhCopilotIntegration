#!/usr/bin/env bash
set -euo pipefail

# ─── Configuration ────────────────────────────────────────────────────────────
RESOURCE_GROUP_NAME="rg-todo-app"
STORAGE_ACCOUNT_NAME="statictodostorage$RANDOM"   # must be globally unique
LOCATION="eastus"
APP_DIST_DIR="dist"
# ──────────────────────────────────────────────────────────────────────────────

echo "==> Authenticating with Azure..."
az login

echo "==> Creating resource group: $RESOURCE_GROUP_NAME"
az group create \
  --name "$RESOURCE_GROUP_NAME" \
  --location "$LOCATION"

echo "==> Creating storage account: $STORAGE_ACCOUNT_NAME"
az storage account create \
  --name "$STORAGE_ACCOUNT_NAME" \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --kind StorageV2

echo "==> Retrieving storage account key..."
STORAGE_KEY=$(az storage account keys list \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --account-name "$STORAGE_ACCOUNT_NAME" \
  --query "[0].value" \
  --output tsv)

echo "==> Enabling Static Website Hosting..."
az storage blob service-properties update \
  --account-name "$STORAGE_ACCOUNT_NAME" \
  --account-key "$STORAGE_KEY" \
  --static-website true \
  --index-document index.html \
  --404-document index.html

echo "==> Building the Vue.js app..."
npm run build

echo "==> Uploading files to \$web container..."
az storage blob upload-batch \
  --account-name "$STORAGE_ACCOUNT_NAME" \
  --account-key "$STORAGE_KEY" \
  --destination '$web' \
  --source "$APP_DIST_DIR" \
  --overwrite true

echo "==> Deploy complete! Your site is available at:"
az storage account show \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --name "$STORAGE_ACCOUNT_NAME" \
  --query "primaryEndpoints.web" \
  --output tsv
