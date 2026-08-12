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

Si no hay una razón concreta para mensajes entre pares y tareas compartidas, no configures Swarm: explica que Nest puede ser suficiente y pide volver a `/diagnosticar-topologia`.

## 2. Propuesta y confirmación

Resume en una tabla: líder, teammates, tarea compartida, mensaje obligatorio, entrada, salida, verificación y cuatro paradas. Pregunta: **“¿Confirmas que escriba el runtime Swarm y sus teammates?”**

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
```

### C. Agentes teammates

Para cada rol, escribe `.claude/agents/<rol>.md` con frontmatter que incluya `name`, `description`, `tools: [Read]` y `model: inherit`. El cuerpo debe indicar qué revisa, qué no puede inventar, qué publica en la tarea compartida, qué mensaje debe enviar a su par y su criterio de terminado.

No crees archivos `.claude/teams/`: Claude Code administra el runtime de Agent Teams fuera del proyecto. Los agentes de proyecto son definiciones reutilizables; el launcher inicia el team en la sesión.

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
