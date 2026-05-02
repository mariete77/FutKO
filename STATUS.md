# 🦀 Estado del Proyecto FutKO

> **Actualizado:** 2026-05-02 por Claw Bot
> **Project Manager:** Mario Anaya
> **Concepto:** Juego de Trivia de Fútbol (Estilo GeoC) - 1vs1 en tiempo real.

---

## 🗺️ Roadmap (Según PROGRESS.md)

| Fase | Descripción | Estado | Responsable |
| :--- | :--- | :--- | :--- |
| **Fase 1** | Estructura Base (Clean Arch) | ✅ Completada | - |
| **Fase 2** | Modelos de Datos (Match, Question) | ✅ **Completada** | **Claw Bot** |
| **Fase 3** | Preguntas de Fútbol (Content/UI) | 🛠️ **En Progreso** | **Claw Bot** |
| **Fase 4** | Ligas y Equipos (CMS/Content) | ⏳ Pendiente | **Compa** |
| **Fase 5** | Matchmaking Multiplayer | ⏳ Pendiente | - |

---

## 👷‍♂️ Trabajo Actual (En vivo)

### 🦀 Claw Bot (Rama: `feature/claw-predictions`)
*   **Commit actual:** `41c4977` (Restore original trivia structure).
*   **Tarea ahora mismo:** Adaptar el `question_model.dart` para fútbol y ajustar UI (`game_screen`) con temática de fútbol.
*   **Siguiente paso:** Generar/Revisar preguntas de fútbol para la base de datos.

### 👨‍💻 El Compa (Rama: `feature/compa-leagues`)
*   **Tarea asignada:** Gestión de Ligas y Equipos (Administración de contenido).
*   **Estado:** Rama creada y lista para pull.

---

## 📝 Notas para el equipo
*   El juego es **1vs1 Trivia** (no pronósticos de resultados).
*   Usamos la arquitectura base de GeoC (Match, ELO, Multiplayer).
*   El foco ahora es el **CONTENIDO** (Preguntas de fútbol) y la **UI** (Fútbol themed).
