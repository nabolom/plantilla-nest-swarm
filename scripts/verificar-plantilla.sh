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
  "scripts/preflight-extensions.sh"
  "scripts/verificar-runtime.sh"
  "scripts/correr-nest.sh"
  "scripts/correr-swarm.sh"
  "tests/test-runtime-launchers.sh"
  "integraciones.md"
  "memoria/estado.md"
  "harnesses/PLANTILLA-HARNESS-AGENTE.md"
  "MCP-MEMORIA-HARNESSES.md"
  ".mcp.json.example"
  "resultados/.gitkeep"
  "resultados/README.md"
)

for file in "${required[@]}"; do
  test -s "$file" || { echo "FALTA: $file" >&2; exit 1; }
done

for script in scripts/preflight-runtime.sh scripts/preflight-extensions.sh scripts/verificar-runtime.sh scripts/correr-nest.sh scripts/correr-swarm.sh tests/test-runtime-launchers.sh; do
  test -x "$script" || { echo "NO EJECUTABLE: $script" >&2; exit 1; }
done

grep -q 'DIAGNÓSTICO GUARDADO: arquitectura/decision.md, integraciones.md y memoria/estado.md' .claude/commands/diagnosticar-topologia.md
grep -q 'NEST CONFIGURADO Y LISTO' .claude/commands/configurar-nest.md
grep -q 'SWARM CONFIGURADO Y LISTO' .claude/commands/configurar-swarm.md
grep -q 'AUDITORÍA GUARDADA' .claude/commands/verificar-configuracion.md
grep -q 'claude --agent' scripts/correr-nest.sh
grep -q 'CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1' scripts/correr-swarm.sh
grep -q 'SALIDA GUARDADA:' scripts/correr-nest.sh
grep -q 'SALIDA GUARDADA:' scripts/correr-swarm.sh
grep -q 'mcp__crm__buscar_cliente' .claude/commands/configurar-nest.md
grep -q 'MCPs requeridos' .claude/commands/configurar-swarm.md
grep -q 'validate_extensions' scripts/preflight-runtime.sh

echo "OK — plantilla lista: diagnostica, configura, valida y puede lanzar un Nest o Swarm."
