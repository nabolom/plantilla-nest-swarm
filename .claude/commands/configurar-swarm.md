---
description: Configura un Swarm ejecutable: teammates, tarea compartida, mensajes entre pares, síntesis, salida y paradas.
---

# Configurar Swarm ejecutable

Lee `proyecto.md`, `arquitectura/decision.md`, `entrada.md` y `RUNTIME.md`.

Si `arquitectura/decision.md` no confirma exactamente `**Decisión:** \`Swarm\``, detente y pide correr `/diagnosticar-topologia` primero. No cambies una decisión confirmada por tu cuenta.

> Un Swarm en esta plantilla significa un Agent Team de Claude Code. El objetivo no es documentar compañeros: al terminar, el alumno debe poder correr `bash scripts/correr-swarm.sh`, observar teammates, tareas compartidas y mensajes entre pares, y obtener `resultados/salida-swarm.md`.

## 1. Entrevista: una pregunta a la vez

Haz cada pregunta y espera la respuesta antes de continuar.

1. “¿Cuál es el primer caso no sensible que quieres procesar? Escríbelo como entrada concreta para `entrada.md`.”
2. “¿Cómo se llamará el líder que sintetiza? Usa minúsculas y guiones, por ejemplo `coordinador`.”
3. “Dame entre dos y cuatro teammates. Para cada uno: nombre con minúsculas y guiones, qué parte del caso revisa y qué debe compartir con el resto.”
4. “¿Qué tarea compartida o dependencia deben ver todos los teammates?”
5. “¿Qué mensaje directo entre pares debe ocurrir antes de la síntesis? Nombra emisor, receptor y contenido.”
6. “¿Qué debe producir el sistema en `resultados/salida-swarm.md` para que alguien pueda comprobarlo?”
7. “Define las cuatro paradas: éxito, presupuesto o límite, no-progreso y escalamiento humano. ¿Quién recibe el escalamiento?”
8. “Según `integraciones.md`, ¿algún teammate necesita un MCP? Para cada uno, dime servidor, herramienta exacta, lectura o escritura y confirmación humana si escribe. Si no hace falta, confirma que todos trabajan solo con archivos locales.”
9. “Según `memoria/estado.md`, ¿qué información debe sobrevivir a la sesión? Nombra un único rol que consolida estado, qué guarda, qué nunca guarda y cuándo escala un conflicto.”
10. “Para el líder y cada teammate, confirma: entrada mínima, herramientas permitidas, salida verificable, checker, límite y fallback. Eso será su harness.”

Si no hay una razón concreta para mensajes entre pares y tareas compartidas, no configures Swarm: explica que Nest puede ser suficiente y pide volver a `/diagnosticar-topologia`. Si no hay contrato de permisos, memoria y harnesses, no propongas archivos todavía.

## 2. Propuesta y confirmación

Resume en una tabla: líder, teammates, tarea compartida, mensaje obligatorio, entrada, salida, verificación, cuatro paradas, MCPs requeridos, memoria y harnesses. Pregunta: **“¿Confirmas que escriba el runtime Swarm, sus teammates y sus controles operativos?”**

No escribas ni sobrescribas archivos hasta obtener confirmación explícita.

## 3. Archivos que debes crear tras confirmación

### A. Entrada

Reemplaza el contenido de `entrada.md` con el caso real no sensible que el alumno confirmó. No dejes corchetes ni placeholders.

### B. Contrato runtime

Escribe `config/swarm.md`. Debe iniciar exactamente con estas cinco líneas, sin Markdown antes:

```text
arquitectura: Swarm
lider: <nombre-del-lider>
roles: <rol-1>, <rol-2>[, <rol-3>, <rol-4>]
entrada: entrada.md
salida: resultados/salida-swarm.md
```

Después incluye estas secciones exactas:

```markdown
## Propósito

[proceso y decisión que el Swarm resuelve]

## Tarea compartida

[qué todos deben poder ver y actualizar]

## Mensaje entre pares obligatorio

[emisor → receptor: contenido y por qué es necesario]

## Contrato de roles

| Teammate | Parte del caso | Qué comparte con pares | Criterio de terminado |
|---|---|---|---|

## Verificación

- [check 1]
- [check 2]

## Cuatro paradas

- Éxito: [regla verificable]
- Presupuesto: [límite]
- No-progreso: [regla]
- Escalamiento humano: [persona o canal y disparador]

## Integraciones autorizadas

[solo rol → herramienta MCP exacta → lectura/escritura → confirmación humana. Si no hay MCP, escribe: Ninguna; solo archivos locales.]

## Memoria y ownership

[referencia a memoria/estado.md; único rol que consolida memoria durable después de la síntesis]

## Harnesses

[líder y cada teammate → harnesses/<rol>.md]
```

### C. Agentes teammates

Para cada rol, escribe `.claude/agents/<rol>.md` con frontmatter que incluya `name`, `description`, herramientas mínimas y `model: inherit`. Por defecto usa `tools: [Read]`. Si un teammate requiere MCP, agrega solo la herramienta exacta permitida, por ejemplo `mcp__crm__buscar_cliente`; no uses comodines ni concedas escritura si no está declarada en `integraciones.md`. El cuerpo debe indicar que primero lee `harnesses/<rol>.md`, qué revisa, qué no puede inventar, qué publica en la tarea compartida, qué mensaje debe enviar a su par y su criterio de terminado. Si hay MCP, solo usa la herramienta exacta declarada para su rol y nunca realiza una escritura externa sin confirmación humana.

No crees archivos `.claude/teams/`: Claude Code administra el runtime de Agent Teams fuera del proyecto. Los agentes de proyecto son definiciones reutilizables; el launcher inicia el team en la sesión. El líder debe leer `config/swarm.md`, `integraciones.md`, `memoria/estado.md` y su propio harness antes de crear teammates; al finalizar, solo el rol declarado como `propietario_escritura` puede consolidar memoria durable.

### D. Harnesses por agente

Crea `harnesses/<lider>.md` y `harnesses/<rol>.md` para cada teammate, usando `harnesses/PLANTILLA-HARNESS-AGENTE.md`. Cada harness debe declarar entrada, herramientas, datos prohibidos, salida verificable, checker, límite y fallback. Solo un harness puede declarar `puede_escribir_estado: si`; debe coincidir exactamente con `propietario_escritura` de `memoria/estado.md` y será el rol que consolida memoria después de la síntesis. Sin memoria durable, todos declaran `no`.

### E. Integración y memoria

Completa `integraciones.md` y `memoria/estado.md` con las respuestas confirmadas. Si `requiere_mcp: si`, crea `.mcp.json` solo en la copia local del alumno a partir de `.mcp.json.example`; nunca escribas un token o secreto en un archivo versionado. Indica que debe abrir Claude Code, aprobar el workspace y verificar `claude mcp list` antes de correr.

## 4. Verificación y prueba

Después de crear los archivos, ejecuta:

```bash
bash scripts/verificar-runtime.sh
```

Si el runtime pasa, indícale al alumno que ejecute en Terminal:

```bash
bash scripts/correr-swarm.sh
```

Explícale que una corrida vale como Swarm solo si observa teammates, lista compartida y al menos un mensaje entre pares. Si no aparecen teammates, debe escribir `/exit`, registrar el riesgo y volver a Nest; no simules una corrida válida.

Al terminar responde exactamente:

```text
SWARM CONFIGURADO Y LISTO: usa bash scripts/correr-swarm.sh
```
