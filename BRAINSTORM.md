# Brainstorm: hacer FutKO más dinámico

> Generado el 2026-06-13. Anclado al código real (no a README/DESIGN, que están
> obsoletos). Fuente: exploración del juego en `lib/` + síntesis priorizada.

## 🎯 Diagnóstico (design read)

FutKO ya tiene buen esqueleto y un tema sólido (Stadium Arena oscuro), pero **la
partida se siente más estática de lo que debería**: el 1v1 no se vive en tiempo
real (las respuestas del rival se leen al *final*), hay un "hueco muerto" tras
cada respuesta, el timer solo cambia de color, y faltaba *juiciness* (sin
haptics, sin partículas, sin "+100" flotante, sin feedback al pulsar). Las
palancas de dinamismo más rentables son baratas; la más grande (1v1 en vivo) es
la apuesta de fondo.

## Las 10 mejoras priorizadas

| #  | Mejora | Dinamismo | Impacto | Esfuerzo | Estado |
|----|--------|:---:|:---:|:---:|---|
| 1  | Haptics en respuesta/timeout/racha | 🔥 alto | alto | bajo | ✅ Hecho |
| 2  | Feedback instantáneo al pulsar + recortar el "hueco muerto" | 🔥 alto | alto | bajo | ✅ Hecho |
| 3  | Popup flotante "+100" (rise & fade) al puntuar | 🔥 alto | medio | bajo | ✅ Hecho |
| 4  | Timer con pulso de tensión (late/satura, no solo color) | 🔥 alto | medio | bajo | ✅ Hecho |
| 5  | Celebración de racha y victoria (confetti/partículas) | 🔥 alto | alto | medio | ✅ Racha (confetti victoria pend.) |
| 6  | **1v1 en vivo de verdad** (marcador del rival en tiempo real) | 🔥 alto | alto | alto | Pendiente (requiere prueba 2 clientes) |
| 7  | Modos rápidos: Blitz / Muerte súbita / Racha infinita | 🔥 alto | alto | medio | Pendiente (decisión de UX) |
| 8  | Comodines en vivo (+tiempo, doble puntos) | medio | medio | medio | ✅ Hecho |
| 9  | Racha diaria (la Pregunta del Día hoy NO tiene streak) | medio | alto | bajo | ✅ Hecho |
| 10 | Logros (no existe nada) | medio | alto | medio | ✅ Hecho |

> Los quick wins 1–4 están implementados en la rama `feat/game-feel-quickwins`.

### Quick wins de *game feel* (1–4) — ✅ implementados
- **Haptics** — `HapticsService` (espeja `AudioService`) + toggle "Vibración" en
  Ajustes. Vibración en acierto/fallo (`answer_feedback_widget`) y tic en cuenta
  atrás (`game_provider`).
- **Feedback al pulsar + matar el hueco muerto** — `AnswerOptionsWidget` ahora es
  stateful: al pulsar muestra flash verde/rojo + escala y revela la correcta
  antes de pasar al feedback; delays recortados (`game_constants`).
- **"+puntos" flotante** — `GameNotifier.lastScoreDelta` + animación de "+X" que
  sube y se desvanece sobre el icono de resultado (`answer_feedback_widget`).
- **Timer con tensión** — `_PulseTimer` late y se enrojece en los últimos 5 s.

### Celebración (5) — pendiente
Confetti/partículas al encadenar racha (hitos 5/10) y al ganar; animar el
contador de racha del home (hoy es estático). **Ojo:** la racha que llega al
`AnswerFeedbackWidget` viene como 0 — el "fix" de anoche lee el estado `playing`
cuando ya está en `answered`. Hay que pasar la racha real (vía `_pendingStreak`).

### Apuestas grandes (6–7) — pendiente
- **1v1 en vivo de verdad** — es *la* mejora de fondo. Hoy es asíncrono: las
  respuestas del rival se traen al terminar tus 10 preguntas → 30–40 s sin
  tensión. Usar la Realtime Database que ya existe (`multiplayer_provider`) para
  emitir el avance pregunta-a-pregunta y mostrar el marcador del rival en directo.
- **Modos rápidos** — Blitz (5×5 s), Muerte súbita, Racha infinita. Reaprovechan
  el loop y el banco de preguntas existentes.

### Retención que alimenta el dinamismo (9–10) — pendiente
- **Racha diaria** — la Pregunta del Día no lleva streak; añadir `dailyStreak` al
  `User` con llama/contador y recompensa por días seguidos.
- **Logros y misiones** — no existe ningún sistema de logros.

## ⚠️ Hallazgos extra (no son "dinamismo" pero importan)
1. **El proyecto no compilaba desde anoche** — 8 errores de compilación en
   `question_stats_provider`, `multiplayer_provider`, `game_screen`,
   `home_screen` y `settings_screen` (el "0 errores" de los commits no era real).
   **Corregido** en la rama `feat/game-feel-quickwins`.
2. **Los límites del freemium NO se validan en cliente** (`subscription_provider`):
   cualquiera juega ilimitado. Sin backend, el enforcement debe ser client-side.
3. **Casual calcula ELO pero quizá no lo aplica** — verificar que casual no toque
   el ELO. Además: sin notificaciones, sin replay de partida, sin chat.

## Temas transversales
1. Cerrar bucles de feedback a medias (sonido sí, faltaba haptic/visual).
2. Convertir lo asíncrono en síncrono donde da tensión (1v1 en vivo).
3. Celebrar lo que ya se mide (racha, ELO, aciertos) en vez de solo mostrarlo.

## Secuencia recomendada
1. ✅ Lote 1–5 de *game feel* (1–4 hechos; falta la celebración 5).
2. Racha diaria + logros (9–10).
3. Modos rápidos (7) y comodines en vivo (8).
4. Proyecto grande: 1v1 en vivo (6).
5. Transversal: sistema de **Ligas/ELO** (ver `ELO_LIGAS_DESIGN.md`).
