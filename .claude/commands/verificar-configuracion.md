---
description: Audita si tu configuración tiene proceso, decisión, roles, integraciones, memoria, harnesses, salida verificable y paradas.
---

# Verificar configuración operable

Lee `proyecto.md`, `arquitectura/decision.md`, `integraciones.md`, `memoria/estado.md`, `harnesses/`, y, si existe, `config/nest.md` o `config/swarm.md`.

Revisa y reporta en una tabla:

| Elemento | Estado | Evidencia o hueco |
|---|---|---|
| Proceso definido | | |
| Entrada y salida verificable | | |
| Decisión arquitectónica con evidencia | | |
| Roles con alcance explícito | | |
| Harness para líder y cada rol | | |
| Herramientas permitidas por rol | | |
| Salida y checker por rol | | |
| Límite y fallback por rol | | |
| Integraciones MCP declaradas | | |
| Mínimo privilegio y confirmación para escritura externa | | |
| Estado o memoria con propietario único de escritura | | |
| Retención, datos prohibidos y escalamiento de conflicto | | |
| Verificación entre pasos | | |
| Condición de éxito | | |
| Presupuesto o límite | | |
| No-progreso | | |
| Escalamiento humano | | |

Aplica estas reglas:

1. Si `integraciones.md` declara `requiere_mcp: si`, no declares listo hasta que haya servidor, rol, herramienta exacta, lectura/escritura, confirmación humana, fallback y el alumno confirme que `claude mcp list` muestra el servidor conectado o cached.
2. Si `memoria/estado.md` declara memoria durable, exige exactamente un propietario de escritura, retención, datos prohibidos y verificación antes de sobrescribir. Si no necesita memoria durable, confirma que todos los harnesses declaran `puede_escribir_estado: no`.
3. Cada archivo `harnesses/<rol>.md` debe declarar objetivo, entrada, herramientas, restricciones, salida verificable, checker, límite y fallback. No aceptes un rol descrito solo con un prompt.
4. Si falta cualquier parada, rol con harness, permiso externo, contrato de memoria o salida verificable, di **NO LISTO PARA CORRER** y nombra el siguiente archivo que hay que completar.

Escribe el reporte en `resultados/auditoria-configuracion.md`. Si todo está completo, indica que el alumno debe ejecutar `bash scripts/verificar-runtime.sh` antes de cualquier launcher.

Responde exactamente:

```text
AUDITORÍA GUARDADA: resultados/auditoria-configuracion.md
```
