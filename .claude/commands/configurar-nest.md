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

Si el alumno no puede nombrar salida verificable, paradas o persona/canal de escalamiento, no propongas archivos todavía: explica el hueco y sigue preguntando.

## 2. Propuesta y confirmación

Resume en una tabla: líder, especialistas, entrada, salida, verificación y cuatro paradas. Pregunta: **“¿Confirmas que escriba el runtime Nest y sus agentes?”**

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

El cuerpo debe obligar al líder a leer `config/nest.md` y `entrada.md`, delegar exactamente una vez a cada rol configurado, esperar sus reportes, verificar según el contrato, respetar las cuatro paradas, escalar cuando aplique y escribir la salida en `resultados/salida-nest.md`. Debe cerrar con:

```text
SALIDA GUARDADA: resultados/salida-nest.md
NEST TERMINADO: todos los reportes configurados fueron recibidos o se documentó el bloqueo.
```

### D. Agentes especialistas

Para cada rol, escribe `.claude/agents/<rol>.md` con frontmatter que incluya `name`, `description`, `tools: [Read]` y `model: inherit`. El cuerpo debe indicar qué fuente/parcela revisa, qué no puede inventar, el formato exacto de su reporte y su criterio de terminado. No incluyas `Write`: los especialistas reportan al líder; el líder escribe la salida final.

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
