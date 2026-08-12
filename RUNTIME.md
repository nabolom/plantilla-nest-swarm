# Contrato runtime — plantilla Nest y Swarm

Esta plantilla se vuelve ejecutable cuando Claude ha guardado una decisión confirmada y una configuración en `config/`. El runtime no sustituye el diagnóstico: **se niega a correr si faltan decisiones, roles, salida verificable o paradas**.

| Patrón elegido | Archivo de configuración | Launcher | Salida generada |
|---|---|---|---|
| Nest | `config/nest.md` | `bash scripts/correr-nest.sh` | `resultados/salida-nest.md` |
| Swarm | `config/swarm.md` | `bash scripts/correr-swarm.sh` | `resultados/salida-swarm.md` |

## Archivos que todo runtime necesita

El alumno escribe el primer caso real en `entrada.md`. Cada configuración declara una cabecera simple con `arquitectura`, `lider`, `roles`, `entrada` y `salida`; el runtime la lee para saber qué agente iniciar y dónde se debe guardar el resultado.

Los nombres de líder y roles deben usar solo minúsculas, números y guiones: por ejemplo, `coordinador`, `riesgo` o `revision-legal`. Eso hace que el nombre de un agente pueda usarse de manera segura en `.claude/agents/<nombre>.md`.

## Fallos seguros

Antes de abrir Claude Code, el runtime comprueba que exista la decisión, la configuración del patrón elegido, un input no vacío, el agente líder cuando corresponde, todos los roles configurados, una ruta de salida, las cuatro paradas y una persona o canal de escalamiento. Si cualquiera falta, imprime el hueco y no inicia una corrida.

Un Nest se inicia con `claude --agent <lider>`. El líder debe delegar a los tipos de agente declarados y escribir una salida verificable. Un Swarm activa `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` y pide explícitamente teammates, lista de tareas compartida, mensajes entre pares y una salida verificable. Como Agent Teams es experimental, una corrida que no muestra teammates no debe contarse como Swarm válido.

## Evidencia mínima de una primera prueba

Una primera prueba no prueba producción. Debe dejar un archivo en `resultados/`, la condición de salida observada, una captura o transcripción del runtime y un hueco documentado si una regla no pudo verificarse. El siguiente paso es usar esa evidencia para ajustar roles, entradas, paradas o decidir que la arquitectura fue excesiva.


---

## Extensiones operativas: MCP, memoria y harnesses

Antes de abrir un launcher, el runtime carga tres contratos adicionales. `integraciones.md` declara si existe un MCP, qué servidor y herramienta puede utilizar cada rol, y si una acción externa requiere confirmación humana. La plantilla nunca conecta un MCP ni guarda credenciales automáticamente: `.mcp.json` es local, está ignorado por Git y debe aprobarse dentro de Claude Code. Si una integración requerida no aparece como `Connected` o `cached` en `claude mcp list`, el preflight bloquea la corrida.

`memoria/estado.md` declara si el proceso necesita estado durable. Sin memoria durable, ningún harness puede escribir estado. Con memoria local o externa, existe exactamente un propietario de escritura; ese rol consolida los cambios después de verificar la salida. Los teammates pueden compartir tareas y mensajes durante una sesión, pero eso no es memoria persistente.

Cada archivo `harnesses/<rol>.md` es el contrato verificable de un agente: objetivo, entrada, herramientas permitidas, restricciones, salida, checker, límite y fallback. Un agente sin harness no se considera configurado. El preflight bloquea la ejecución si falta un harness, si falta una sección o si más de un rol intenta escribir memoria durable.
