# FutKO — Instrucciones para Agentes IA (protocolo v2: aislamiento)

> Contrato compartido por **todos** los asistentes (Claude Code, OpenCode, Cline, Cursor…).
> v2 corrige el fallo de la v1: varios LLMs trabajaban sobre **el mismo working tree y el mismo HEAD**, y se pisaban (cambios de rama bajo los pies, commits en la rama equivocada, carreras en `TASKS.md`, `main` obsoleto). La causa: git solo admite **un working tree = un HEAD = un escritor**.
> Lee también `CLAUDE.md` (arquitectura + guías Karpathy).

## 🔑 Regla de oro: UN WORKING TREE POR LLM
Nunca trabajéis los tres en el mismo checkout. Cada agente, en su **propio** directorio aislado:

```bash
# Nivel 1 — git worktrees (mismo .git, distinto working tree + HEAD)
git worktree add ../futko-c1 carril/1-backend       # OpenCode
git worktree add ../futko-c2 carril/2-contenido     # Cline
git worktree add ../futko-c4 carril/4-pantallas      # Claude
```
- Lanza cada agente apuntando a SU carpeta (`../futko-cN`).
- **Nunca** hagas `git checkout` ni `git commit` en un worktree que no sea el tuyo.
- **Nivel 2 (ideal):** en vez de worktrees, un **clon separado por LLM** contra `git.futko.app` y trabajo por **Pull Requests**. Aislamiento total e historial limpio.

## 🧭 Coordinación: agentmemory, NO un .md compartido
El "quién hace qué" se lleva en **agentmemory** (`localhost:3111`, MCP), no editando todos el mismo archivo (eso provocó carreras en `TASKS.md`). Usa `project: "FutKO"`.
- **Al iniciar:** `memory_context`.
- **Antes de tocar un carril:** `memory_smart_search` (¿lo está haciendo otro?) y registra que lo tomas.
- **Al aprender algo / terminar:** `memory_save` (`decision` / `pattern` / `session`).
- `TASKS.md` queda como **snapshot de solo lectura**; si hay que editarlo, lo hace **solo el orquestador**.

## 🌿 Flujo git
- **Base común `develop`** que SIEMPRE compile. Cada carril es una rama **independiente** que sale de `develop` (no apiladas unas sobre otras).
- **PRs pequeños y frecuentes** → el **orquestador (Claude)** integra a `develop`. `main` solo se actualiza por merge de `develop` (nunca commits sueltos).
- Verifica **`flutter analyze` sin errores nuevos** antes de abrir PR; añade un test si metiste lógica.

## 🔥 Hot files — un solo dueño (o el orquestador)
`pubspec.yaml` · `pubspec.lock` · `lib/main.dart` · `lib/app.dart` · `lib/domain/entities/*` · `lib/core/constants/*`.
Si tu carril los necesita, queda registrado en agentmemory y eres el **único** que los toca.

## ⚙️ Código generado
Nunca edites `*.g.dart` / `*.freezed.dart` a mano. Tras cambiar `@riverpod` / `@freezed` / `@JsonSerializable`:
`dart run build_runner build --delete-conflicting-outputs`. En conflicto de merge de generados: **no mergees, regenera**.

## 🗣️ Estilo
UI y textos en **español** (locale `es`, plantilla `lib/l10n/app_es.arb`). Respeta las guías Karpathy de `CLAUDE.md`: mínimo código, cambios quirúrgicos, nada especulativo.

---
> Nota: este archivo debe vivir en `develop`/`main` para que aparezca en el worktree de cada LLM. Hasta consolidar (paso "main al día"), puede no estar presente en algunas ramas de carril.
