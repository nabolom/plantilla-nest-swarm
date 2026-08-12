# Plantilla Nest y Swarm

> **Primero diagnostica. Después configura. Finalmente corre una primera prueba.**

Este repo es una **plantilla ejecutable** para convertir un proceso propio en un sistema de Claude Code. No contiene un caso resuelto ni una arquitectura predeterminada. Claude te entrevista para decidir si necesitas un solo agente, un **Nest** o un **Swarm**; solo crea y ejecuta el patrón que la evidencia justifica.

| Patrón | Cuándo tiene sentido | Qué corre |
|---|---|---|
| **Un solo agente** | Una persona/rol puede resolver la tarea con un prompt, reglas y evals. | No configures multiagente todavía. |
| **Nest** | Especialistas independientes investigan o verifican partes del caso y reportan a un líder. | `bash scripts/correr-nest.sh` |
| **Swarm** | Los roles deben ver tareas compartidas, intercambiar mensajes directos y ajustar decisiones entre pares. | `bash scripts/correr-swarm.sh` |

---

## 1. Crea tu copia privada

En GitHub, pulsa **Use this template** → **Create a new repository**. Ponle el nombre que quieras y elige **Private**. Así tus reglas, procesos y conclusiones no quedan públicos.

Después abre Terminal y ejecuta:

```bash
git clone https://github.com/TU-USUARIO/TU-REPO.git
cd TU-REPO
bash scripts/verificar-plantilla.sh
claude
```

> Reemplaza `TU-USUARIO/TU-REPO` por la URL de tu copia privada. `git clone` descarga tu repo; `cd` entra a la carpeta; la verificación confirma que recibiste la plantilla completa; `claude` abre Claude Code dentro del proyecto.

---

## 2. Diagnostica antes de configurar

Dentro de Claude Code, escribe:

```text
/diagnosticar-topologia
```

Claude te entrevista sobre proceso, entrada, salida, roles, dependencias, comunicación entre pares, necesidad de herramientas externas, memoria entre corridas y controles por agente. Al final propone una de cuatro opciones:

| Decisión | Significa |
|---|---|
| **Un solo agente** | La tarea no necesita especialización ni coordinación. |
| **Nest** | Especialistas independientes reportan a un líder que sintetiza. |
| **Swarm** | Los roles necesitan tareas compartidas y comunicación directa entre pares. |
| **Evidencia insuficiente** | Todavía faltan datos para justificar una arquitectura. |

No se guarda nada sin tu confirmación. El diagnóstico deja `arquitectura/decision.md`, `integraciones.md` y `memoria/estado.md`. Estos últimos dos archivos declaran si necesitas MCP, qué rol puede usar cada herramienta, qué debe persistir y quién puede escribir ese estado.

---

## 3. Configura solo el patrón elegido

| Si elegiste | Corre dentro de Claude Code | Qué crea |
|---|---|---|
| **Nest** | `/configurar-nest` | `entrada.md`, `config/nest.md`, líder, especialistas, harnesses y contrato de runtime. |
| **Swarm** | `/configurar-swarm` | `entrada.md`, `config/swarm.md`, teammates, harnesses y contrato de Agent Teams. |
| **Un solo agente** | No configures múltiples agentes todavía. | Empieza con prompt, reglas y evals. |

Los comandos hacen preguntas de una en una, proponen el diseño y piden confirmación antes de escribir. Generan un harness por rol en `harnesses/`: entrada, herramientas autorizadas, salida verificable, checker, límite y fallback. No deben dejar nombres inventados, entrada vacía, salida subjetiva, permisos externos ambiguos ni paradas vagas.

---

## 4. Verifica la configuración antes de correr

Dentro de Claude Code:

```text
/verificar-configuracion
```

Ese comando audita el diseño y guarda una nota en `resultados/auditoria-configuracion.md`.

Después, en Terminal, ejecuta el preflight runtime:

```bash
bash scripts/verificar-runtime.sh
```

Este segundo check revisa los archivos que el launcher realmente necesita: decisión confirmada, configuración, agentes, entrada no vacía, salida, verificación, cuatro paradas, escalamiento, harnesses por rol, permisos MCP y ownership de memoria. Si bloquea, lee el mensaje, vuelve a Claude Code y corrige solo ese hueco.

---

## 5. Corre tu primera prueba

### Si tu patrón es Nest

En Terminal:

```bash
bash scripts/correr-nest.sh
```

El launcher abre Claude Code con el líder configurado. El líder lee tu entrada, delega a los especialistas declarados, espera los reportes, verifica y guarda la salida en:

```text
resultados/salida-nest.md
```

La corrida es válida solo si ves:

```text
SALIDA GUARDADA: resultados/salida-nest.md
NEST TERMINADO: todos los reportes configurados fueron recibidos o se documentó el bloqueo.
```

### Si tu patrón es Swarm

En Terminal:

```bash
bash scripts/correr-swarm.sh
```

El launcher activa Agent Teams y abre Claude Code con instrucciones de crear teammates usando los roles configurados. La corrida vale como Swarm solo si observas **teammates**, **una tarea compartida** y **un mensaje directo entre pares**. Al final debe escribir:

```text
resultados/salida-swarm.md
```

con este cierre:

```text
SALIDA GUARDADA: resultados/salida-swarm.md
SWARM TERMINADO: teammates, tareas compartidas y mensajes entre pares observados.
```

> Agent Teams es experimental. Si no aparecen teammates y tarea compartida, escribe `/exit`; no cuentes esa sesión como Swarm válido. Registra el riesgo en `resultados/` y considera que Nest puede ser suficiente.

---

## 6. Qué entregas después de una primera prueba

| Archivo | Qué demuestra |
|---|---|
| `arquitectura/decision.md` | Por qué elegiste un solo agente, Nest o Swarm. |
| `config/nest.md` o `config/swarm.md` | El contrato de roles, entrada, salida, verificaciones y paradas. |
| `resultados/salida-nest.md` o `resultados/salida-swarm.md` | La evidencia de una primera corrida. |
| `resultados/auditoria-configuracion.md` | Los huecos encontrados antes de correr. |
| `integraciones.md` | Sistemas externos, permisos mínimos, confirmación humana y fallback. |
| `memoria/estado.md` | Qué persiste, qué no, quién escribe y cómo se retiene. |
| `harnesses/<rol>.md` | Entrada, herramientas, salida, checker, límite y fallback por agente. |

La primera corrida no certifica producción. Sirve para aprender si tus roles, entrada, salida y paradas funcionan. Ajusta el diseño con la evidencia; no agregues más agentes solo porque la primera salida sea imperfecta.

---

## Estructura del repo

```text
proyecto.md                         ← proceso y salida verificable
entrada.md                          ← primer caso real no sensible
arquitectura/decision.md            ← por qué elegiste el patrón
config/nest.md o config/swarm.md    ← contrato runtime del patrón
.claude/agents/                     ← líder/especialistas o teammates generados
scripts/correr-*.sh                 ← launchers runtime
resultados/                         ← auditorías y salidas locales; no se suben
RUNTIME.md                          ← contrato y fallos seguros del runtime
integraciones.md                    ← permisos y fallback de MCP
memoria/estado.md                   ← contrato de memoria durable
harnesses/                          ← harness obligatorio por líder y rol
.mcp.json.example                   ← ejemplo local sin secretos
```

## Seguridad mínima

No pegues secretos, API keys, datos personales ni documentos confidenciales en `entrada.md`, `integraciones.md` o archivos versionados. Si necesitas MCP, usa `.mcp.json.example` para crear una `.mcp.json` **local** y no versionada; abre Claude Code, aprueba el workspace y confirma `claude mcp list` antes de correr. Toda escritura externa requiere confirmación humana explícita en `integraciones.md`. Empieza con un caso representativo y no sensible, y mantén privada tu copia del repo.
