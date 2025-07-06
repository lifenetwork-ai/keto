#!/bin/bash
set -euo pipefail

MODE=${KETO_SERVICE_MODE:-serve}
RELATION_TUPLES_DIR=${RELATION_TUPLES_DIR:-/etc/config/relation-tuples}
KETO_CONFIG=${KETO_CONFIG:-/etc/config/keto.yml}

if [ "$MODE" = "init" ]; then
  echo "[INIT] Importing relation-tuples from $RELATION_TUPLES_DIR..."
  export KETO_WRITE_REMOTE=${KETO_WRITE_REMOTE:-http://localhost:4467}
  if [ -d "$RELATION_TUPLES_DIR" ]; then
    /usr/bin/keto relation-tuple create "$RELATION_TUPLES_DIR"
  else
    echo "[WARN] $RELATION_TUPLES_DIR not found."
  fi
  exit 0
fi

echo "[SERVE] Starting ORY Keto with config $KETO_CONFIG"
exec /usr/bin/keto serve --config "$KETO_CONFIG"
