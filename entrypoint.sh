#!/bin/bash
set -euo pipefail

KETO_SERVICE_MODE=${KETO_SERVICE_MODE:-serve}
RELATION_TUPLES_DIR=${RELATION_TUPLES_DIR:-/etc/config/relation-tuples}
KETO_CONFIG=${KETO_CONFIG:-/etc/config/keto.yml}
KETO_WRITE_API_URL=${KETO_WRITE_API_URL:-http://localhost:4467}

if [ "$KETO_SERVICE_MODE" = "init" ]; then
  echo "[INIT] Importing relation-tuples from $RELATION_TUPLES_DIR to $KETO_WRITE_API_URL..."

  if [ -d "$RELATION_TUPLES_DIR" ]; then
    for file in "$RELATION_TUPLES_DIR"/*.json; do
      echo "[PUT] Sending $file"
      curl -s -o /dev/null -w "%{http_code}" -X PUT "$KETO_WRITE_API_URL/admin/relation-tuples" \
        -H "Content-Type: application/json" \
        -d @"$file"
      echo " ← Done"
    done
    echo "[INIT] Import completed."
  else
    echo "[WARN] $RELATION_TUPLES_DIR not found."
  fi

  exit 0
fi

echo "[SERVE] Starting ORY Keto with config $KETO_CONFIG"
exec /usr/bin/keto serve --config "$KETO_CONFIG"
