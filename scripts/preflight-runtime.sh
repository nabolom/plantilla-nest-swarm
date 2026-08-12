#!/usr/bin/env bash
# Biblioteca de checks compartidos por los launchers de Nest y Swarm.
set -euo pipefail

runtime_value() {
  local key="$1" file="$2"
  sed -n -E "s/^${key}:[[:space:]]*//p" "$file" | head -n 1 | tr -d '\r'
}

valid_name() {
  [[ "$1" =~ ^[a-z0-9]+([a-z0-9-]*[a-z0-9]+)?$ ]]
}

prepare_runtime() {
  local pattern="$1"
  case "$pattern" in
    nest)
      RUNTIME_CONFIG="config/nest.md"
      RUNTIME_OUTPUT_DEFAULT="resultados/salida-nest.md"
      RUNTIME_DECISION="Nest"
      ;;
    swarm)
      RUNTIME_CONFIG="config/swarm.md"
      RUNTIME_OUTPUT_DEFAULT="resultados/salida-swarm.md"
      RUNTIME_DECISION="Swarm"
      ;;
    *) echo "Uso: prepare_runtime nest|swarm" >&2; return 2 ;;
  esac

  test -f "arquitectura/decision.md" || { echo "BLOQUEADO: falta arquitectura/decision.md. Corre /diagnosticar-topologia." >&2; return 1; }
  grep -Fqi "**Decisión:** \`${RUNTIME_DECISION}\`" "arquitectura/decision.md" || { echo "BLOQUEADO: la decisión no confirma ${RUNTIME_DECISION}. Revisa /diagnosticar-topologia." >&2; return 1; }
  test -f "$RUNTIME_CONFIG" || { echo "BLOQUEADO: falta $RUNTIME_CONFIG. Corre el comando de configuración correspondiente." >&2; return 1; }
  test -f "entrada.md" || { echo "BLOQUEADO: falta entrada.md." >&2; return 1; }
  grep -Fq '[Describe aquí' entrada.md || grep -Fq '[Dato o fuente' entrada.md || grep -Fq '[Describe el archivo' entrada.md && { echo "BLOQUEADO: entrada.md conserva placeholders. Escribe un primer caso real antes de correr." >&2; return 1; }

  RUNTIME_ARCHITECTURE="$(runtime_value arquitectura "$RUNTIME_CONFIG")"
  RUNTIME_LEADER="$(runtime_value lider "$RUNTIME_CONFIG")"
  RUNTIME_ROLES="$(runtime_value roles "$RUNTIME_CONFIG")"
  RUNTIME_INPUT="$(runtime_value entrada "$RUNTIME_CONFIG")"
  RUNTIME_OUTPUT="$(runtime_value salida "$RUNTIME_CONFIG")"

  [[ "$RUNTIME_ARCHITECTURE" == "$RUNTIME_DECISION" ]] || { echo "BLOQUEADO: arquitectura declarada no coincide con ${RUNTIME_DECISION}." >&2; return 1; }
  valid_name "$RUNTIME_LEADER" || { echo "BLOQUEADO: lider inválido en $RUNTIME_CONFIG." >&2; return 1; }
  test -n "$RUNTIME_ROLES" || { echo "BLOQUEADO: no hay roles configurados." >&2; return 1; }
  test -f "$RUNTIME_INPUT" || { echo "BLOQUEADO: no existe la entrada declarada: $RUNTIME_INPUT" >&2; return 1; }
  test -n "$RUNTIME_OUTPUT" || { echo "BLOQUEADO: falta ruta de salida." >&2; return 1; }
  grep -q '^## Verificación' "$RUNTIME_CONFIG" || { echo "BLOQUEADO: falta sección de verificación." >&2; return 1; }
  grep -q '^## Cuatro paradas' "$RUNTIME_CONFIG" || { echo "BLOQUEADO: faltan las cuatro paradas." >&2; return 1; }
  grep -qi 'escalamiento' "$RUNTIME_CONFIG" || { echo "BLOQUEADO: falta escalamiento humano." >&2; return 1; }

  if [[ "$pattern" == "nest" ]]; then
    test -f ".claude/agents/${RUNTIME_LEADER}.md" || { echo "BLOQUEADO: falta el agente líder .claude/agents/${RUNTIME_LEADER}.md" >&2; return 1; }
  fi

  IFS=',' read -r -a role_list <<< "$RUNTIME_ROLES"
  for raw_role in "${role_list[@]}"; do
    role="$(echo "$raw_role" | xargs)"
    valid_name "$role" || { echo "BLOQUEADO: rol inválido: $role" >&2; return 1; }
    test -f ".claude/agents/${role}.md" || { echo "BLOQUEADO: falta .claude/agents/${role}.md" >&2; return 1; }
  done

  # Los contratos operativos adicionales se validan antes de abrir Claude Code.
  source "scripts/preflight-extensions.sh"
  validate_extensions

  mkdir -p "$(dirname "$RUNTIME_OUTPUT")" resultados
  export RUNTIME_CONFIG RUNTIME_ARCHITECTURE RUNTIME_LEADER RUNTIME_ROLES RUNTIME_INPUT RUNTIME_OUTPUT
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  prepare_runtime "${1:-}"
  echo "PRECHECK OK: ${RUNTIME_ARCHITECTURE} listo con líder ${RUNTIME_LEADER}; salida ${RUNTIME_OUTPUT}."
fi
