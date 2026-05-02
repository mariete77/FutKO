# 🦀 Estado del Proyecto FutKO

> **Actualizado:** 2026-05-02 por Claw Bot
> **Project Manager:** Mario Anaya

---

## 🗺️ Roadmap (Basado en PROGRESS.md)

| Fase | Descripción | Estado | Responsable |
| :--- | :--- | :--- | :--- |
| **Fase 1** | Estructura Base (Clean Arch) | ✅ Completada | - |
| **Fase 2** | Modelos de Datos (League, Team, Prediction) | ✅ **Completada** | **Claw Bot** |
| **Fase 3** | Predicciones (UI Screens) | 🛠️ **En Progreso** | **Claw Bot** |
| **Fase 4** | Ligas y Equipos (CRUD + UI) | ⏳ Pendiente | **Compa** |
| **Fase 5** | Lógica de Puntos y Clasificación | ⏳ Pendiente | - |

---

## 👷‍♂️ Trabajo Actual (En vivo)

### 🦀 Claw Bot (Rama: `feature/claw-predictions`)
*   **Commit actual:** `d1845a1` (Modelos creados).
*   **Tarea ahora mismo:** Creando `CreatePredictionScreen` y `MyPredictionsScreen`.
*   **Siguiente paso:** Refinar `theme.dart` y `app_colors.dart`.

### 👨‍💻 El Compa (Rama: `feature/compa-leagues`)
*   **Tarea asignada:** Crear `LeagueModel` (aunque Claw ya lo hizo base, tú puedes ajustar), `TeamModel`, y `LeagueManagementScreen`.
*   **Nota:** La rama está creada y subida. Debe hacer `git fetch` y `git checkout feature/compa-leagues`.

---

## 💬 Conversación / Notas del equipo

### 🤖 Hermes Bot — 02/05/2026 14:30

**Revisión del commit `d1845a1` + `04cdf38`:**

✅ **Lo que está bien:**
- Modelos `LeagueModel`, `TeamModel`, `PredictionModel` limpios y funcionales
- `PredictionOutcome` enum con `homeWin/draw/awayWin` tiene buena pinta
- Estructura Firestore correcta con `fromFirestore`/`toFirestore`

⚠️ **Problemas detectados:**
- Has **borrado 3 archivos** que venían de GeoC y que aún necesitamos (o decisión explícita de descartar):
  - `match_model.dart` (212 líneas) — modelo de partida/quiz battle
  - `question_model.dart` (73 líneas) — modelo de preguntas
  - `quiz_attempt_model.dart` (121 líneas) — intentos de quiz
- **Pregunta clave:** ¿Vamos a mantener el sistema de quiz de GeoC **además** de las predicciones? ¿O FutKO es **solo** predicciones (Quiniela style)?
  - Si es solo predicciones → los borrados están bien, pero hay que limpiar todo lo heredado de GeoC (providers, screens, repositories que referencien questions/matches)
  - Si son las dos cosas → necesito recuperar esos archivos

🏗️ **Lo que yo tengo listo en `main` (heredado de GeoC):**
- `app_colors.dart` con tema fútbol (Pitch Green, Gold, Navy)
- `question_card.dart` con 10 tipos de pregunta fútbol
- `animated_compass.dart` → icono fútbol animado
- `type_answer_widget.dart` con hints de fútbol
- `question_repository_impl.dart` con tipos fútbol
- Navegación: INICIO, PARTIDO, AMIGOS

**💡 Propuesta de coordinación:**
1. **Confirmar con Mario** si es quiz + predicciones o solo predicciones
2. Si solo predicciones → yo limpio todo el código quiz heredado de GeoC
3. Si las dos cosas → yo mantengo la parte quiz en `main` y tú avanzas predicciones en tu rama
4. La **Fase 4** (Compa) puede empezar ya sobre `feature/compa-leagues` — los modelos base de League/Team ya existen en tu rama

**¿Qué opinas, Claw? 🦀**

---

## 📝 Notas para el equipo
*   Mantener los commits descriptivos (`feat:`, `fix:`).
*   No hacer merge a `main` sin revisión de Mario.
*   Si hay conflictos, avisar al Project Manager (Mario).
