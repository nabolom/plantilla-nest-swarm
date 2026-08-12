---
description: Configura un Nest ejecutable: contrato runtime, líder, especialistas, entrada, verificación y paradas.
---

# Configurar Nest ejecutable

Lee `proyecto.md`, `arquitectura/decision.md`, `entrada.md` y `RUNTIME.md`.

Si `arquitectura/decision.md` no confirma exactamente `**Decisión:** \`Nest\``, detente y pide correr `/diagnosticar-topologia` primero. No cambies una decisión confirmada por tu cuenta.

> El objetivo no es solo documentar roles. Al terminar, el alumno debe poder correr `bash scripts/correr-nest.sh` y obtener `resultados/salida-nest.md`.

## 1. Entrevista: una pregunta a la vez

Haz cada pregunta y espera la respuesta antes de continuar.

1. “¿Cuál es el primer caso no sensible que quieres procesar? Escríbelo como entrada concreta para `entrada.md`.”
2. “¿Cómo se llamará el líder? Usa minúsculas y guiones, por ejemplo `coordinador`.”
3. “Dame entre dos y cuatro especialistas. Para cada uno: nombre con minúsculas y guiones, qué fuente o parte revisa, y qué reporte exacto entrega al líder.”
4. “¿Qué debe producir el sistema en `resultados/salida-nest.md` para que alguien pueda comprobarlo?”
5. “¿Qué verifica el líder antes de aceptar cada reporte?”
6. “Define las cuatro paradas: éxito, presupuesto o límite, no-progreso y escalamiento humano. ¿Quién recibe el escalamiento?”
7. “Según `integraciones.md`, ¿algún rol necesita un MCP? Para cada uno, dime servidor, herramienta exacta, lectura o escritura y confirmación humana si escribe. Si no hace falta, confirma que todos trabajan solo con archivos locales.”
8. “Según `memoria/estado.md`, ¿hay memoria duradera? Si sí, ¿qué rol único consolida el estado, qué guarda, qué nunca guarda y cuándo limpia o escala un conflicto?”
9. “Para el líder y cada especialista, confirma: entrada mínima, herramientas permitidas, salida verificable, checker, límite y fallback. Eso será su harness.”

Si el alumno no puede nombrar salida verificable, paradas, persona/canal de escalamiento, permisos externos o harness, no propongas archivos todavía: explica el hueco y sigue preguntando.

## 2. Propuesta y confirmación

Resume en una tabla: líder, especialistas, entrada, salida, verificación, cuatro paradas, MCPs requeridos, memoria y harnesses. Pregunta: **“¿Confirmas que escriba el runtime Nest, sus agentes y sus controles operativos?”**

No escribas ni sobrescribas archivos hasta obtener confirmación explícita.

## 3. Archivos que debes crear tras confirmación

### A. Entrada

Reemplaza el contenido de `entrada.md` con el caso real no sensible que el alumno confirmó. No dejes corchetes ni placeholders.

### B. Contrato runtime

Escribe `config/nest.md`. Debe iniciar exactamente con estas cinco líneas, sin Markdown antes:

```text
arquitectura: Nest
lider: <nombre-del-lider>
roles: <rol-1>, <rol-2>[, <rol-3>, <rol-4>]
entrada: entrada.md
salida: resultados/salida-nest.md
```

Después incluye estas secciones exactas:

```markdown
## Propósito

[proceso y decisión que el Nest resuelve]

## Contrato de roles

| Rol | Fuente o parte revisada | Reporte exacto para el líder | Criterio de terminado |
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

[referencia a memoria/estado.md; único rol que consolida estado, o sin memoria durable]

## Harnesses

[líder y cada especialista → harnesses/<rol>.md]
```

### C. Agente líder

Escribe `.claude/agents/<lider>.md` con este frontmatter, sustituyendo los nombres de roles reales:

```yaml
---
name: <lider>
description: Lidera el Nest configurado para <proceso>.
tools:
  - Read
  - Write
  - Agent(<rol-1>)
  - Agent(<rol-2>)
model: inherit
---
```

El cuerpo debe obligar al líder a leer `config/nest.md`, `entrada.md`, `integraciones.md`, `memoria/estado.md` y `harnesses/<lider>.md`; delegar exactamente una vez a cada rol configurado; exigir que cada reporte cumpla su harness; verificar según el contrato; respetar las cuatro paradas; escalar cuando aplique; y escribir la salida en `resultados/salida-nest.md`. Si hay MCP, solo usa la herramienta exacta declarada y nunca ejecuta una escritura externa sin confirmación humana. Debe cerrar con:

```text
SALIDA GUARDADA: resultados/salida-nest.md
NEST TERMINADO: todos los reportes configurados fueron recibidos o se documentó el bloqueo.
```

### D. Agentes especialistas

Para cada rol, escribe `.claude/agents/<rol>.md` con frontmatter que incluya `name`, `description`, herramientas mínimas y `model: inherit`. Por defecto usa `tools: [Read]`. Si un rol requiere MCP, agrega solo el nombre exacto de la herramienta permitida, por ejemplo `mcp__crm__buscar_cliente`; no uses un comodín ni concedas escritura si no está declarada en `integraciones.md`. El cuerpo debe indicar que primero lee `harnesses/<rol>.md`, qué fuente/parcela revisa, qué no puede inventar, el formato exacto de su reporte y su criterio de terminado. No incluyas `Write`: los especialistas reportan al líder; el líder escribe la salida final.

### E. Harnesses por agente

Crea `harnesses/<lider>.md` y `harnesses/<rol>.md` para cada especialista, usando `harnesses/PLANTILLA-HARNESS-AGENTE.md`. Cada harness debe declarar la entrada, herramientas permitidas, datos prohibidos, salida verificable, checker, límite y fallback. Solo un harness puede declarar `puede_escribir_estado: si`; debe coincidir exactamente con `propietario_escritura` de `memoria/estado.md`. Si `tipo_memoria` es `sin_memoria_durable`, todos deben declarar `puede_escribir_estado: no`.

### F. Integración y memoria

Completa `integraciones.md` y `memoria/estado.md` con las respuestas confirmadas. Si `requiere_mcp: si`, crea `.mcp.json` solo en la copia local del alumno a partir de `.mcp.json.example`; nunca escribas un token o secreto en un archivo versionado. Indica que debe abrir Claude Code, aprobar el workspace y verificar `claude mcp list` antes de correr.

## 4. Verificación y prueba

Después de crear los archivos, ejecuta:

```bash
bash scripts/verificar-runtime.sh
```

Si el runtime pasa, indícale al alumno que ejecute en Terminal:

```bash
bash scripts/correr-nest.sh
```

Si falla, muestra el hueco concreto y corrígelo solo con confirmación del alumno.

Al terminar responde exactamente:

```text
NEST CONFIGURADO Y LISTO: usa bash scripts/correr-nest.sh
```
