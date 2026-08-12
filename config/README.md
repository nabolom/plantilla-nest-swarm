# Configuraciones runtime

No llenes esta carpeta a mano antes de diagnosticar el proceso. Después de confirmar una arquitectura, `/configurar-nest` crea `config/nest.md`; `/configurar-swarm` crea `config/swarm.md`.

Los launchers leen una cabecera simple al inicio del archivo:

```text
arquitectura: Nest o Swarm
lider: nombre-del-lider
roles: rol-1, rol-2
entrada: entrada.md
salida: resultados/salida-nest.md o resultados/salida-swarm.md
```

Los nombres de líder y roles deben coincidir exactamente con archivos bajo `.claude/agents/`, por ejemplo `.claude/agents/coordinador.md` o `.claude/agents/riesgo.md`.
