# Contrato de integraciones

Este archivo declara **qué sistemas externos necesita el proyecto**. No guardes secretos, tokens ni URLs privadas aquí. Si no se requiere una integración, conserva `requiere_mcp: no`.

```text
requiere_mcp: no
mcp_servers:
```

| Sistema | Servidor MCP | Rol autorizado | Lectura o escritura | Datos permitidos | Confirmación humana | Evidencia o log | Fallback si falla |
|---|---|---|---|---|---|---|---|
| — | — | — | — | — | — | — | — |

> Una integración de escritura no se ejecuta sin confirmación humana explícita. Configura servidores reales únicamente en `.mcp.json` local, usando `.mcp.json.example` como guía, y comprueba su estado con `claude mcp list`.
