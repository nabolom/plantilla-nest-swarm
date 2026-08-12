#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/preflight-runtime.sh"
prepare_runtime swarm

input_content="$(cat "$RUNTIME_INPUT")"
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
prompt=$(cat <<EOF2
EJECUTA MI SWARM CONFIGURADO

Lee ${RUNTIME_CONFIG} y ${RUNTIME_INPUT}. Forma un Agent Team real, no subagentes. Crea teammates usando exactamente estos tipos de agente de proyecto: ${RUNTIME_ROLES}. Deben usar una lista de tareas compartida, intercambiar al menos un mensaje directo entre pares sobre una dependencia o tensión real del caso y dejar que ${RUNTIME_LEADER} sintetice.

No inventes roles, reglas o fuentes fuera de la configuración. Respeta las verificaciones, cuatro paradas y escalamiento definidos en ${RUNTIME_CONFIG}.

INPUT:
${input_content}

Al finalizar, escribe la salida verificable en ${RUNTIME_OUTPUT}. El archivo debe contener: resumen de entrada, teammates participantes, tareas compartidas, mensajes entre pares relevantes, decisión o salida, verificaciones realizadas, parada que cerró la corrida y cualquier escalamiento o incertidumbre.

Cierra con:
SALIDA GUARDADA: ${RUNTIME_OUTPUT}
SWARM TERMINADO: teammates, tareas compartidas y mensajes entre pares observados.
EOF2
)

echo "Abriendo Swarm con Agent Teams. La salida se guardará en ${RUNTIME_OUTPUT}."
echo "Si no aparecen teammates y tarea compartida, escribe /exit: no cuentes la corrida como Swarm válido."
exec claude "$prompt"
