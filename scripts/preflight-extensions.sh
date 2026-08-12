#!/usr/bin/env bash
# Checks adicionales para integraciones, memoria y harnesses.
# Debe ser cargado desde preflight-runtime.sh después de preparar el contrato base.
set -euo pipefail

require_file() {
  local path="$1" message="$2"
  test -f "$path" || { echo "BLOQUEADO: $message" >&2; return 1; }
}

contract_value() {
  local key="$1" file="$2"
  sed -n -E "s/^${key}:[[:space:]]*//p" "$file" | head -n 1 | tr -d '\r'
}

harness_has() {
  local role="$1" phrase="$2"
  grep -Fq "$phrase" "harnesses/${role}.md"
}

validate_harnesses() {
  local roles=("$RUNTIME_LEADER")
  local raw role
  IFS=',' read -r -a parsed_roles <<< "$RUNTIME_ROLES"
  for raw in "${parsed_roles[@]}"; do
    role="$(echo "$raw" | xargs)"
    roles+=("$role")
  done

  local writers=0 writer_role=""
  for role in "${roles[@]}"; do
    require_file "harnesses/${role}.md" "falta harnesses/${role}.md. Reconfigura el runtime antes de correr."
    for phrase in '## Objetivo' '## Entrada mínima' '## Herramientas permitidas' '## Salida verificable' '## Checker' '## Límite' '## Fallback y escalamiento'; do
      harness_has "$role" "$phrase" || { echo "BLOQUEADO: el harness de ${role} no contiene ${phrase}." >&2; return 1; }
    done
    if grep -Fq 'puede_escribir_estado: si' "harnesses/${role}.md"; then
      writers=$((writers + 1))
      writer_role="$role"
    fi
  done

  local memory_type owner
  memory_type="$(contract_value tipo_memoria memoria/estado.md)"
  owner="$(contract_value propietario_escritura memoria/estado.md)"
  case "$memory_type" in
    sin_memoria_durable)
      [[ "$writers" -eq 0 ]] || { echo "BLOQUEADO: hay un rol que escribe memoria, pero memoria/estado.md declara sin_memoria_durable." >&2; return 1; }
      ;;
    archivos_locales|servicio_externo)
      [[ "$writers" -eq 1 ]] || { echo "BLOQUEADO: memoria duradera exige exactamente un propietario de escritura; se encontraron ${writers}." >&2; return 1; }
      [[ "$owner" == "$writer_role" ]] || { echo "BLOQUEADO: propietario_escritura (${owner}) no coincide con el harness que escribe estado (${writer_role})." >&2; return 1; }
      grep -Fq '## Regla de escritura' memoria/estado.md || { echo "BLOQUEADO: falta regla de escritura de memoria." >&2; return 1; }
      grep -Fq '## Retención y limpieza' memoria/estado.md || { echo "BLOQUEADO: falta retención de memoria." >&2; return 1; }
      ;;
    *) echo "BLOQUEADO: tipo_memoria inválido: ${memory_type}." >&2; return 1 ;;
  esac
}

validate_mcp() {
  require_file integraciones.md "falta integraciones.md. Corre /diagnosticar-topologia."
  local requires servers server status
  requires="$(contract_value requiere_mcp integraciones.md)"
  servers="$(contract_value mcp_servers integraciones.md)"
  case "$requires" in
    no|"") return 0 ;;
    si) ;;
    *) echo "BLOQUEADO: requiere_mcp debe ser si o no." >&2; return 1 ;;
  esac

  [[ -n "$servers" ]] || { echo "BLOQUEADO: requiere_mcp: si pero no hay mcp_servers declarados." >&2; return 1; }
  grep -Fq 'Confirmación humana' integraciones.md || { echo "BLOQUEADO: falta la política de confirmación humana para integraciones." >&2; return 1; }
  test -f .mcp.json || { echo "BLOQUEADO: este runtime requiere MCP. Configura .mcp.json local desde .mcp.json.example y apruébalo al abrir Claude Code." >&2; return 1; }
  if git ls-files --error-unmatch .mcp.json >/dev/null 2>&1; then
    echo "BLOQUEADO: .mcp.json está versionado. Elimina secretos/configuración local del control de versiones antes de correr." >&2
    return 1
  fi
  command -v claude >/dev/null 2>&1 || { echo "BLOQUEADO: no se encontró Claude Code para verificar MCPs." >&2; return 1; }
  status="$(claude mcp list 2>&1 || true)"
  local raw
  IFS=',' read -r -a mcp_list <<< "$servers"
  for raw in "${mcp_list[@]}"; do
    server="$(echo "$raw" | xargs)"
    [[ -n "$server" ]] || continue
    echo "$status" | grep -E "${server}.*Connected|${server}.*cached" >/dev/null || {
      echo "BLOQUEADO: MCP ${server} no está Connected/cached. Abre Claude Code, aprueba el workspace y revisa claude mcp list." >&2
      return 1
    }
  done
}

validate_extensions() {
  require_file memoria/estado.md "falta memoria/estado.md. Corre /diagnosticar-topologia."
  validate_harnesses
  validate_mcp
}
