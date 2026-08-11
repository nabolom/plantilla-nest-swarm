---
description: Configura un Nest confirmado: líder, especialistas, salida, verificación y paradas.
---

# Configurar Nest

Lee `proyecto.md` y `arquitectura/decision.md`. Si no existe una decisión confirmada que diga Nest, detente y pide correr `/diagnosticar-topologia` primero.

## Entrevista

Pregunta una cosa a la vez:

1. “¿Cómo se llama el líder y qué decisión o documento final debe producir?”
2. “Dame entre dos y cuatro especialistas. Para cada uno: qué fuente o parte del proceso revisa y qué reporte entrega al líder.”
3. “¿Qué debe verificar el líder antes de aceptar un reporte?”
4. “¿Cuál es la condición de éxito, el presupuesto/límite de iteraciones, el no-progreso y el escalamiento humano?”

Propón un diseño. Pide confirmación antes de escribir archivos.

## Archivos a crear tras confirmación

1. `config/nest.md` con el contrato del líder, tabla de especialistas, contrato de salida, verificaciones y cuatro paradas.
2. `.claude/agents/<lider>.md` con instrucciones para delegar, esperar los reportes y sintetizar.
3. `.claude/agents/<especialista>.md` para cada especialista, con alcance acotado y formato de reporte.

No crees subagentes con nombres inventados. No dejes un rol sin una fuente, salida o criterio de terminado.

Al terminar responde:

```text
NEST CONFIGURADO: revisa config/nest.md y los agentes creados.
```
