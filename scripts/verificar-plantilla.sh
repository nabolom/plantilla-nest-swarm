#!/usr/bin/env bash
set -euo pipefail

required=(
  "README.md"
  "CLAUDE.md"
  "RUNTIME.md"
  "proyecto.md"
  "entrada.md"
  "config/README.md"
  ".claude/commands/diagnosticar-topologia.md"
  ".claude/commands/configurar-nest.md"
  ".claude/commands/configurar-swarm.md"
  ".claude/commands/verificar-configuracion.md"
  "plantillas/NEST.md"
  "plantillas/SWARM.md"
  "scripts/preflight-runtime.sh"
  "scripts/verificar-runtime.sh"
  "scripts/correr-nest.sh"
  "scripts/correr-swarm.sh"
  "tests/test-runtime-launchers.sh"
  "resultados/.gitkeep"
  "resultados/README.md"
)

for file in "${required[@]}"; do
  test -s "$file" || { echo "FALTA: $file" >&2; exit 1; }
done

for script in scripts/preflight-runtime.sh scripts/verificar-runtime.sh scripts/correr-nest.sh scripts/correr-swarm.sh tests/test-runtime-launchers.sh; do
  test -x "$script" || { echo "NO EJECUTABLE: $script" >&2; exit 1; }
done

grep -q 'DECISIÓN GUARDADA: arquitectura/decision.md' .claude/commands/diagnosticar-topologia.md
grep -q 'NEST CONFIGURADO Y LISTO' .claude/commands/configurar-nest.md
grep -q 'SWARM CONFIGURADO Y LISTO' .claude/commands/configurar-swarm.md
grep -q 'AUDITORÍA GUARDADA' .claude/commands/verificar-configuracion.md
grep -q 'claude --agent' scripts/correr-nest.sh
grep -q 'CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1' scripts/correr-swarm.sh
grep -q 'SALIDA GUARDADA:' scripts/correr-nest.sh
grep -q 'SALIDA GUARDADA:' scripts/correr-swarm.sh

echo "OK — plantilla lista: diagnostica, configura, valida y puede lanzar un Nest o Swarm."
