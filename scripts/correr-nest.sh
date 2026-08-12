#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/preflight-runtime.sh"
prepare_runtime nest

input_content="$(cat "$RUNTIME_INPUT")"
prompt=$(cat <<EOF2
EJECUTA MI NEST CONFIGURADO

Eres ${RUNTIME_LEADER}, el líder declarado en ${RUNTIME_CONFIG}. Lee esa configuración y el input de ${RUNTIME_INPUT}. No inventes roles, reglas o fuentes fuera de esos archivos.

Debes delegar exactamente una vez a estos tipos de agente permitidos: ${RUNTIME_ROLES}. Espera sus reportes. Verifica la salida según ${RUNTIME_CONFIG}, respeta las cuatro paradas y escala cuando la configuración lo exija.

INPUT:
${input_content}

Al final, escribe la salida verificable en ${RUNTIME_OUTPUT}. El archivo debe contener: resumen de entrada, reportes usados, decisión o salida, verificaciones realizadas, parada que cerró la corrida y cualquier escalamiento o incertidumbre. Cierra la conversación con:
SALIDA GUARDADA: ${RUNTIME_OUTPUT}
NEST TERMINADO: todos los reportes configurados fueron recibidos o se documentó el bloqueo.
EOF2
)

echo "Abriendo Nest con líder ${RUNTIME_LEADER}. La salida se guardará en ${RUNTIME_OUTPUT}."
exec claude --agent "$RUNTIME_LEADER" "$prompt"
