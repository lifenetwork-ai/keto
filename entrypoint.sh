#!/bin/bash
set -euo pipefail

KETO_SERVICE_MODE=${KETO_SERVICE_MODE:-read}
RELATION_TUPLES_DIR=${RELATION_TUPLES_DIR:-/etc/config/relation-tuples}
KETO_CONFIG=${KETO_CONFIG:-/etc/config/keto.yml}

if [ "$KETO_SERVICE_MODE" = "write" ]; then
  echo "[INFO] Initializing relation-tuples from $RELATION_TUPLES_DIR..."
  if [ -d "$RELATION_TUPLES_DIR" ]; then
    /usr/bin/keto relation-tuple create "$RELATION_TUPLES_DIR" || echo "[WARN] Import failed"
  else
    echo "[WARN] No relation-tuples directory found at $RELATION_TUPLES_DIR"
  fi
fi

echo "[INFO] Starting ORY Keto with config $KETO_CONFIG"
exec /usr/bin/keto serve --config "$KETO_CONFIG"
