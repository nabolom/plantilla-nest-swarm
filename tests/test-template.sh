#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_dir"

bash scripts/verificar-plantilla.sh

grep -q 'Use this template' README.md
grep -q '/diagnosticar-topologia' README.md
grep -q 'un solo agente' README.md
grep -q 'Agent Teams' .claude/commands/configurar-swarm.md
! grep -R -q 'ghp_' . --exclude-dir=.git

echo "OK — guía y comandos de configuración verificados."
