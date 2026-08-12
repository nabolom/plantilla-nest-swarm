---
description: Te entrevista para decidir topología, integraciones MCP, memoria y harnesses antes de crear agentes.
---

# Diagnosticar arquitectura operable

No propongas agentes ni integraciones antes de entender el proceso. Lee `proyecto.md`, `integraciones.md` y `memoria/estado.md`; si contienen placeholders, úsalos solo como borrador y entrevista al usuario.

> El diagnóstico debe dejar tres decisiones explícitas: **topología**, **acceso externo** y **estado/memoria**. Si cualquiera carece de evidencia, decide `evidencia insuficiente`; no inventes una arquitectura ni conectes un servicio.

## Entrevista: una pregunta a la vez

Haz cada pregunta, espera la respuesta y confirma lo que entendiste antes de continuar.

1. “¿Qué proceso quieres mejorar y qué salida verificable debe quedar?”
2. “¿Qué entrada recibe el sistema y qué reglas no puede romper?”
3. “¿Qué partes del trabajo pueden investigarse o ejecutarse de manera independiente?”
4. “¿Qué rol necesita hablar, cuestionar o negociar directamente con otro rol? Dame un ejemplo real de información que tendría que viajar entre ambos.”
5. “¿Un líder que recibe reportes claros podría resolver esa tensión? ¿Por qué?”
6. “¿El sistema necesita leer o escribir en una herramienta externa —por ejemplo CRM, Drive, tickets, correo, base de datos o API? Si sí: ¿cuál, qué rol la usa, qué dato necesita y solo lee o también escribe?”
7. “Para cada acción externa de escritura: ¿quién la confirma, qué registro queda y qué pasa si la integración no está conectada?”
8. “¿Qué debe recordar el sistema entre corridas? Define qué se guarda, qué nunca se guarda, cuánto tiempo vive y quién puede escribir ese estado.”
9. “¿Cada rol necesita una verificación distinta antes de declarar terminado? Para cada rol, ¿cuál es su entrada, herramientas permitidas, salida verificable, límite y fallback?”
10. “¿Cuándo debe detenerse, escalar a una persona o declarar que no sabe?”

No sugieras una topología hasta escuchar todas las respuestas. Si no hay razón concreta para comunicación entre pares, no elijas Swarm. Si un MCP, memoria duradera o harness no puede describirse con precisión, márcalo como pendiente y no lo habilites en runtime.

## Propuesta y confirmación

Resume en una tabla: proceso, salida, dependencias, comunicación, integración, memoria y paradas. Propón una decisión: `un solo agente`, `Nest`, `Swarm` o `evidencia insuficiente`.

Pregunta: **“¿Confirmas que guarde este diagnóstico y sus límites operativos?”** No escribas nada hasta obtener confirmación explícita.

## Archivos de decisión

Tras la confirmación, escribe estos tres archivos.

### A. `arquitectura/decision.md`

```markdown
# Decisión de arquitectura

## Proceso y salida verificable

[proceso y salida del usuario]

## Dependencias entre roles

[qué puede trabajarse en paralelo y qué no]

## Comunicación entre pares requerida

[sí/no y ejemplo concreto]

## Arquitectura elegida

**Decisión:** `un solo agente / Nest / Swarm / evidencia insuficiente`

**Justificación:**

1. [evidencia]
2. [evidencia]
3. [evidencia]

## Verificación, paradas y escalamiento

[condición de terminado, límites y humano responsable]

## Qué tendría que cambiar para elegir otra arquitectura

[condición explícita]
```

### B. `integraciones.md`

Si no necesita sistemas externos, escribe exactamente `requiere_mcp: no` al inicio y explica que no se habilitarán herramientas externas.

Si necesita MCP, escribe al inicio:

```text
requiere_mcp: si
mcp_servers: <nombre-1>[, <nombre-2>]
```

Después incluye una tabla: servidor, sistema, rol autorizado, lectura/escritura, datos permitidos, confirmación humana para escritura, evidencia/log y fallback si no conecta. Declara que `.mcp.json` se configura localmente desde `.mcp.json.example`, nunca con secretos versionados, y que cada servidor debe aprobarse en el workspace antes de correr.

### C. `memoria/estado.md`

Escribe al inicio:

```text
tipo_memoria: archivos_locales / sin_memoria_durable / servicio_externo
propietario_escritura: <lider o rol único>
```

Después define: qué se guarda, qué nunca se guarda, lectores autorizados, una única persona/agente que consolida escrituras, retención, formato de actualización, verificación antes de sobrescribir y escalamiento ante conflicto. Si no se necesita memoria entre corridas, escribe `tipo_memoria: sin_memoria_durable` y explica que la sesión no crea memoria persistente por defecto.

## Confirma

Después responde exactamente:

```text
DIAGNÓSTICO GUARDADO: arquitectura/decision.md, integraciones.md y memoria/estado.md
```
