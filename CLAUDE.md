# Configurador de arquitectura — Nest y Swarm

Este repo sirve para diseñar **tu propia** arquitectura, no para copiar un caso resuelto.

## Principios

- Empieza por el proceso de negocio y por su salida verificable, no por los agentes.
- No configures Nest y Swarm por defecto. Elige la arquitectura mínima suficiente.
- Un **Nest** sirve cuando especialistas pueden reportar hallazgos a un líder que sintetiza.
- Un **Swarm** solo se justifica cuando los especialistas necesitan intercambiar, cuestionar o negociar información directamente entre pares.
- No inventes roles, reglas, fuentes, aprobaciones ni salidas esperadas. Pregunta al usuario.
- Pide confirmación antes de escribir archivos de configuración.
- Nunca pongas secretos, API keys o datos personales en este repositorio.

## Flujo recomendado

1. `/diagnosticar-topologia` — entrevista y decisión: un solo agente, Nest, Swarm o evidencia insuficiente.
2. `/configurar-nest` **o** `/configurar-swarm` — crea el esqueleto del patrón elegido.
3. `/verificar-configuracion` — revisa que el diseño tenga entradas, roles, salida, verificación y paradas.

La división de trabajo no cambia: **Claude escribe la configuración; el usuario decide el proceso, los roles y las reglas.**
