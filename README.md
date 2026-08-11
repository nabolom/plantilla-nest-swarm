# Plantilla para configurar Nest o Swarm

> **Primero diseña el flujo. Después decide si necesitas un agente, un Nest o un Swarm.**

Este repositorio es el espacio de trabajo para configurar **tu propio** sistema de agentes después de la S5. No contiene un caso resuelto: contiene las preguntas, comandos y archivos para convertir un proceso real en una configuración defendible.

---

## 1. Crea tu propia copia privada

En GitHub, pulsa **Use this template** → **Create a new repository**. Ponle el nombre que quieras y elige **Private**. Así tus reglas, procesos y conclusiones no quedan públicos.

Después abre Terminal y ejecuta:

```bash
git clone https://github.com/TU-USUARIO/TU-REPO.git
cd TU-REPO
claude
```

> Reemplaza `TU-USUARIO/TU-REPO` por la URL de la copia privada que acabas de crear. `git clone` descarga tu copia; `cd` entra a esa carpeta; `claude` abre Claude Code dentro del proyecto.

---

## 2. Diagnostica antes de configurar

Dentro de Claude Code, escribe:

```text
/diagnosticar-topologia
```

Claude te entrevista sobre tu proceso, entradas, salida, roles, dependencias y necesidad de comunicación entre pares. Al final propone una de cuatro opciones:

| Decisión | Significa |
|---|---|
| **Un solo agente** | La tarea no necesita especialización ni coordinación. |
| **Nest** | Especialistas independientes reportan a un líder que sintetiza. |
| **Swarm** | Los roles necesitan tareas compartidas y comunicación directa entre pares. |
| **Evidencia insuficiente** | Todavía faltan datos para justificar una arquitectura. |

No se guarda nada sin tu confirmación. La decisión vive en `arquitectura/decision.md`.

---

## 3. Configura solo el patrón elegido

| Si elegiste | Corre | Qué crea |
|---|---|---|
| **Nest** | `/configurar-nest` | Roles especializados, líder, contrato de salida, verificación y paradas. |
| **Swarm** | `/configurar-swarm` | Roles, tarea compartida, mensajes entre pares, síntesis y condiciones de parada. |
| **Un solo agente** | No configures múltiples agentes todavía. Escribe primero tu prompt y evals. | Un caso simple no se vuelve mejor por tener más agentes. |

Los archivos de configuración quedan en `config/`. Los agentes de proyecto se crean en `.claude/agents/` solo después de que confirmes los roles.

---

## 4. Verifica antes de correr

Dentro de Claude Code:

```text
/verificar-configuracion
```

El comando revisa si existe un proceso definido, una decisión arquitectónica, una salida verificable, roles explícitos, condiciones de parada, escalamiento y una forma de comprobar el resultado.

También puedes ejecutar en Terminal:

```bash
bash scripts/verificar-plantilla.sh
```

---

## Estructura del repo

```text
proyecto.md                         ← el proceso y su salida
arquitectura/decision.md            ← por qué elegiste un agente, Nest o Swarm
config/nest.md o config/swarm.md    ← contrato del patrón elegido
.claude/agents/                     ← roles que Claude crea tras tu confirmación
resultados/                         ← trazas y conclusiones locales; no se suben
```

## Entregable recomendado

Al final, deberías poder mostrar un `arquitectura/decision.md` y un archivo en `config/` que respondan tres preguntas:

1. ¿Qué problema resuelve este sistema?
2. ¿Por qué esta arquitectura es la mínima suficiente?
3. ¿Cómo sabrás que funcionó y cuándo debe detenerse o escalar?
