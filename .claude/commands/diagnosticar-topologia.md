---
description: Te entrevista para decidir si tu proceso necesita un solo agente, un Nest, un Swarm o más evidencia.
---

# Diagnosticar topología

No propongas agentes antes de entender el proceso. Lee `proyecto.md`; si contiene placeholders, úsalo solo como borrador y entrevista al usuario.

## Entrevista: una pregunta a la vez

1. “¿Qué proceso quieres mejorar y qué salida verificable debe quedar?”
2. “¿Qué entrada recibe el sistema y qué reglas no puede romper?”
3. “¿Qué partes del trabajo pueden investigarse o ejecutarse de manera independiente?”
4. “¿Qué rol necesita hablar, cuestionar o negociar directamente con otro rol? Dame un ejemplo real de información que tendría que viajar entre ambos.”
5. “¿Un líder que recibe reportes claros podría resolver esa tensión? ¿Por qué?”
6. “¿Cuándo debe detenerse, escalar a una persona o declarar que no sabe?”

No sugieras una topología hasta escuchar todas las respuestas. Si faltan datos, decide **evidencia insuficiente**.

## Propuesta y confirmación

Resume el proceso, las dependencias, la comunicación requerida y una decisión: `un solo agente`, `Nest`, `Swarm` o `evidencia insuficiente`. Explica la decisión con evidencia aportada por el usuario.

Pregunta: **“¿Confirmas que guarde esta decisión?”** No escribas nada hasta obtener confirmación explícita.

## Archivo de decisión

Tras la confirmación, escribe `arquitectura/decision.md`:

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

Después responde exactamente:

```text
DECISIÓN GUARDADA: arquitectura/decision.md
```
