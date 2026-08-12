#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/preflight-runtime.sh"

if [[ -f config/nest.md ]]; then
  prepare_runtime nest
  echo "RUNTIME NEST OK: usa bash scripts/correr-nest.sh"
fi
if [[ -f config/swarm.md ]]; then
  prepare_runtime swarm
  echo "RUNTIME SWARM OK: usa bash scripts/correr-swarm.sh"
fi
if [[ ! -f config/nest.md && ! -f config/swarm.md ]]; then
  echo "BLOQUEADO: todavía no existe config/nest.md ni config/swarm.md." >&2
  exit 1
fi
