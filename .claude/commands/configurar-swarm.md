---
description: Configura un Swarm confirmado: teammates, tareas compartidas, mensajes entre pares, síntesis y paradas.
---

# Configurar Swarm

Lee `proyecto.md` y `arquitectura/decision.md`. Si no existe una decisión confirmada que diga Swarm, detente y pide correr `/diagnosticar-topologia` primero.

Recuerda: en Claude Code, un Swarm usa Agent Teams, una capacidad experimental. Nunca la presentes como disponible sin comprobarla.

## Entrevista

Pregunta una cosa a la vez:

1. “¿Qué roles necesitan comunicarse directamente y qué información deben intercambiar?”
2. “¿Qué tarea compartida o dependencia necesitan ver todos?”
3. “¿Qué mensaje entre pares es obligatorio antes de la síntesis?”
4. “¿Quién integra la decisión final y qué debe verificar?”
5. “¿Cuáles son las condiciones de éxito, presupuesto, no-progreso y escalamiento humano?”

Propón el diseño. Pide confirmación antes de escribir archivos.

## Archivos a crear tras confirmación

1. `config/swarm.md` con roles, lista de tareas compartida, mensajes obligatorios, síntesis, verificaciones y cuatro paradas.
2. `.claude/agents/<rol>.md` para cada teammate, con ámbito y mensaje esperado.
3. `scripts/correr-swarm.sh` que active `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` y abra Claude Code con una instrucción explícita de crear Agent Team.

Si Agent Teams no aparece en una prueba, registra el riesgo y ofrece Nest como alternativa; no simules una corrida válida.

Al terminar responde:

```text
SWARM CONFIGURADO: revisa config/swarm.md, los agentes y el launcher.
```
