# MCP, memoria y harnesses: tres capas que no debes confundir

Un **MCP** conecta Claude Code con un sistema externo; no es memoria. La **memoria** es el estado que el sistema conserva entre corridas; no es una conversación ni una lista temporal de Agent Teams. Un **harness** es el contrato operativo de cada rol; no es solo una descripción del agente.

| Capa | Pregunta que responde | Regla por defecto |
|---|---|---|
| MCP | ¿Qué sistema externo necesita este rol? | Sin secreto versionado; mínimo privilegio; escritura con confirmación humana. |
| Memoria | ¿Qué debe persistir después de la sesión? | Archivos locales, un único propietario de escritura y retención explícita. |
| Harness | ¿Qué puede hacer y demostrar cada rol? | Entrada, herramientas, salida, checker, límite y fallback por rol. |

La plantilla no conecta servidores automáticamente. Si `integraciones.md` requiere MCP, el alumno configura `.mcp.json` en su copia local, abre Claude Code, aprueba el workspace y confirma el estado con `claude mcp list`. El preflight bloquea una corrida cuando un servidor requerido no está conectado o cuando una escritura externa no tiene confirmación humana declarada.
