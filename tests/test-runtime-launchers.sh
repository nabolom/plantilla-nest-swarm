#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cp -R "$repo_dir" "$tmp/repo"
cd "$tmp/repo"
mkdir -p config arquitectura .claude/agents resultados "$tmp/bin"
cat > entrada.md <<'IN'
# Entrada de mi primera prueba

Caso de prueba sin placeholders.
IN
cat > arquitectura/decision.md <<'IN'
# Decisión

**Decisión:** `Nest`
IN
cat > config/nest.md <<'IN'
arquitectura: Nest
lider: coordinador
roles: analista, verificador
entrada: entrada.md
salida: resultados/salida-nest.md

## Verificación

- Validar datos.

## Cuatro paradas

- Éxito: salida escrita.
- Presupuesto: una iteración.
- No-progreso: sin reporte.
- Escalamiento: humano responsable.
IN
for agent in coordinador analista verificador; do
  cat > ".claude/agents/${agent}.md" <<IN
---
name: ${agent}
description: agente de prueba
tools:
  - Read
  - Write
model: inherit
---
Agente de prueba.
IN
done
cat > "$tmp/bin/claude" <<'IN'
#!/usr/bin/env bash
printf 'ENV=%s\nARGS=%s\n' "${CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS:-0}" "$*" > "$CLAUDE_LOG"
IN
chmod +x "$tmp/bin/claude"
export PATH="$tmp/bin:$PATH"
export CLAUDE_LOG="$tmp/nest.log"
bash scripts/correr-nest.sh > /dev/null
grep -q -- '--agent coordinador' "$CLAUDE_LOG"
grep -q 'analista, verificador' "$CLAUDE_LOG"
grep -q 'ENV=0' "$CLAUDE_LOG"

sed -i 's/`Nest`/`Swarm`/' arquitectura/decision.md
cat > config/swarm.md <<'IN'
arquitectura: Swarm
lider: facilitador
roles: analista, verificador
entrada: entrada.md
salida: resultados/salida-swarm.md

## Verificación

- Validar datos.

## Cuatro paradas

- Éxito: salida escrita.
- Presupuesto: una iteración.
- No-progreso: sin mensaje.
- Escalamiento: humano responsable.
IN
export CLAUDE_LOG="$tmp/swarm.log"
bash scripts/correr-swarm.sh > /dev/null
grep -q 'ENV=1' "$CLAUDE_LOG"
grep -q 'Agent Team real' "$CLAUDE_LOG"
grep -q 'analista, verificador' "$CLAUDE_LOG"

echo "OK — launchers Nest y Swarm validan configuración y llaman Claude con el runtime esperado."
