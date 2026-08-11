#!/usr/bin/env bash
set -euo pipefail

required=(
  "README.md"
  "CLAUDE.md"
  "proyecto.md"
  ".claude/commands/diagnosticar-topologia.md"
  ".claude/commands/configurar-nest.md"
  ".claude/commands/configurar-swarm.md"
  ".claude/commands/verificar-configuracion.md"
  "plantillas/NEST.md"
  "plantillas/SWARM.md"
  "resultados/.gitkeep"
  "resultados/README.md"
)

for file in "${required[@]}"; do
  test -s "$file" || { echo "FALTA: $file" >&2; exit 1; }
done

grep -q 'DECISIÓN GUARDADA: arquitectura/decision.md' .claude/commands/diagnosticar-topologia.md
grep -q 'NEST CONFIGURADO' .claude/commands/configurar-nest.md
grep -q 'SWARM CONFIGURADO' .claude/commands/configurar-swarm.md
grep -q 'AUDITORÍA GUARDADA' .claude/commands/verificar-configuracion.md

echo "OK — plantilla lista: diagnostica, configura un patrón y verifica."
