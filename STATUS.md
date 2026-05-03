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
|| **Fase 4** | Ligas y Equipos (Infraestructura) | ✅ **Completada** | **Claw Bot** |
|| **Bloque 1** | Branding y UI | ✅ **Completado** | **Hermes Bot** |
|| **Bloque 2** | Firebase y Datos | 🛠️ **En Progreso** | **El Compa** |
|| **Bloque 3** | Infraestructura y Test | 🛠️ **En Progreso** | **Hermes Bot** |
| **Fase 5** | Matchmaking Multiplayer | ⏳ Pendiente | - |

---

## 👷‍♂️ Trabajo Actual (En vivo)

### 🤖 Hermes Bot (Rama: `feature/claw-predictions`)
*   **Commit actual:** `da84a49` (Bloque 1 completo: Branding y UI).
*   **Tarea ahora mismo:** 🔧 **BLOQUE 3 — Infraestructura y Test** (C1-C7).
    - C1: Copiar `android/` e `ios/` de GeoC, adaptar package name
    - C2: Actualizar `build.gradle` (applicationId, app name)
    - C3: Actualizar `Info.plist` (bundle name)
    - C4: Renombrar archivos con "geoc" restantes
    - C5: Verificar `build_runner` sin errores
    - C6: Test compilación `flutter build apk --debug`
    - C7: Primera versión funcional en dispositivo
*   **No tocar:** Bloque 2 (Firebase) → es del Compa.

### 👨‍💻 El Compa (Rama: `feature/compa-leagues`)
*   **Tarea asignada:** 🔥 **BLOQUE 2 — Firebase y Datos** (B1-B3, B6-B8).
    - B1: Crear proyecto Firebase `futko-app`
    - B2: Actualizar `firebase_constants.dart`
    - B3: Configurar `google-services.json` / `GoogleService-Info.plist`
    - B6: Primer lote de preguntas de fútbol (JSON → Firestore)
    - B7: Segundo lote de preguntas
    - B8: Cargar datos iniciales de Ligas y Equipos
*   **Ya completado:** B4 (firestore.rules) ✅, B5 (Modelos Ligas/Equipos) ✅

---

## 📝 Notas para el equipo
*   El juego es **1vs1 Trivia** (no pronósticos de resultados).
*   Usamos la arquitectura base de GeoC (Match, ELO, Multiplayer).
*   **Fase 4 Iniciada:** Se ha creado la estructura de datos para Ligas y Equipos.
*   Faltan los datos (seed) para tener contenido que mostrar.
