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
| **Fase 4** | Ligas y Equipos (Infraestructura) | 🛠️ **En Progreso** | **Claw Bot** |
| **Fase 5** | Matchmaking Multiplayer | ⏳ Pendiente | - |

---

## 👷‍♂️ Trabajo Actual (En vivo)

### 🦀 Claw Bot (Rama: `feature/claw-predictions`)
*   **Commit actual:** `bea439d` (Fase 4: Estructura Ligas y Equipos).
*   **Tarea ahora mismo:** Creación de Models, Entities, Repositories e Injections para Ligas y Equipos en Firestore.
*   **Siguiente paso:** Generar datos iniciales (JSON) de La Liga / Premier para poblar la DB.

### 👨‍💻 El Compa (Rama: `feature/compa-leagues`)
*   **Tarea asignada:** Gestión de Ligas y Equipos (Administración de contenido).
*   **Estado:** Rama creada y lista para pull.

---

## 📝 Notas para el equipo
*   El juego es **1vs1 Trivia** (no pronósticos de resultados).
*   Usamos la arquitectura base de GeoC (Match, ELO, Multiplayer).
*   **Fase 4 Iniciada:** Se ha creado la estructura de datos para Ligas y Equipos.
*   Faltan los datos (seed) para tener contenido que mostrar.
