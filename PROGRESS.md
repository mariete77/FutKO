# ⚽ FutKO — Hoja de Ruta Colaborativa

> **Documento vivo** — actualizar con cada push.  
> Dos agentes trabajan en paralelo. Cada tarea indica quién la hace para evitar conflictos.

---

## 📋 Estado General

| Área | Estado | Progreso |
|------|--------|----------|
|| Estructura base (copia de GeoC) | ✅ Completado | 100% |
|| Branding (nombre, colores, iconos) | ✅ Completado | 100% |
|| Tipos de pregunta (fútbol) | ✅ Completado | 100% |
|| Pantallas UI adaptadas | ✅ Completado | 100% |
|| Firebase (nuevo proyecto) | 🔄 En progreso (El Compa) | 0% |
|| Preguntas de fútbol (datos) | 🔄 En progreso (El Compa) | 0% |
|| **Infraestructura Ligas/Equipos** | ✅ **Completado** | 100% |
|| Infraestructura y compilación | 🔄 Hermes Bot — En progreso | 10% |

---

## ✅ Completado

- [x] Clonado repositorio GeoC → FutKO
- [x] `pubspec.yaml` renombrado (geoquiz_battle → futko)
- [x] Colores cambiados: verde bosque → verde césped (#1B5E20), dorado (#C6A54E), navy (#1A237E)
- [x] `QuestionType` enum: 10 categorías de fútbol (player, team, competition, history, rules, stadium, badge, playerImage, statistic, transfer)
- [x] `app_constants.dart` actualizado (appName, storage paths, deep links)
- [x] `game_constants.dart` actualizado (comentario question types)
- [x] `json_key_converter.dart` fallback: flag → player
- [x] `question_model.dart` fallback: flag → player
- [x] `question_card.dart` reescrito con builders de fútbol
- [x] `type_answer_widget.dart` hints traducidos a fútbol
- [x] `question_repository_impl.dart` multipleChoiceTypes adaptado
- [x] Iconos nav bar: explore → sports_soccer, sports_martial_arts → sports_soccer
- [x] Labels nav: BATTLE → PARTIDO, HOME → INICIO, FRIENDS → AMIGOS
- [x] Splash: brújula → balón de fútbol animado
- [x] Renombradas todas las refs `geoquiz_battle` → `futko`

---

## 🔲 Tareas Pendientes

### 🔴 BLOQUE 1 — Branding y UI (AGENTE A)

Archivos que tocará → no pisar estos si eres AGENTE B.

|| # | Tarea | Archivos | Estado ||
---|-------|----------|--------||
 A1 | Renombrar `geoc_page_transitions.dart` → `futko_page_transitions.dart` y actualizar imports | `lib/presentation/widgets/common/futko_page_transitions.dart`, `lib/app.dart` | ✅ ||
 A2 | Cambiar `Icons.flag_outlined` → `Icons.report_outlined` en feedback y report dialog | `answer_feedback_widget.dart`, `report_question_dialog.dart` | ✅ ||
 A3 | Pantalla login: actualizar branding GeoC → FutKO, textos e iconos | `lib/presentation/screens/auth/login_screen.dart` | ✅ ||
 A4 | Home screen: actualizar textos vacíos, iconos → tema fútbol | `lib/presentation/screens/home/home_screen.dart` | ✅ ||
 A5 | Match history screen: textos, iconos, nav bar labels | `lib/presentation/screens/history/match_history_screen.dart` | ✅ ||
 A6 | Friends screen: textos, iconos, nav bar labels | `lib/presentation/screens/friends/friends_screen.dart` | ✅ ||
 A7 | Leaderboard: textos y estilos → Tabla de Posiciones | `lib/presentation/screens/home/leaderboard_screen.dart` | ✅ ||
 A8 | Matchmaking screen: estilo fútbol/estadio | `lib/presentation/screens/multiplayer/matchmaking_screen.dart` | ✅ ||
 A9 | Game result widget: rangos fútbol, textos en español | `lib/presentation/screens/game/widgets/game_result_widget.dart` | ✅ ||
 A10 | Localización: GeoQuiz→FutKO, geografía→fútbol | `lib/l10n/*.arb`, `lib/l10n/*.dart` | ✅ ||
 A11 | README.md: reescribir para FutKO | `README.md` | ✅ ||
 A12 | DESIGN.md: actualizar tema visual | `DESIGN.md` | ✅ ||

---

### 🔵 BLOQUE 2 — Firebase y Datos (AGENTE B)

Archivos que tocará → no pisar estos si eres AGENTE A.

| # | Tarea | Archivos | Estado |
|---|-------|----------|--------|
| B1 | Crear nuevo proyecto Firebase `futko-app` (o similar) y configurar | Firebase Console | 🔲 |
| B2 | Actualizar `firebase_constants.dart` si cambian nombres de colección | `lib/core/constants/firebase_constants.dart` | 🔲 |
| B3 | Configurar `google-services.json` / `GoogleService-Info.plist` | `android/app/`, `ios/Runner/` | 🔲 |
| B4 | `firebase.json` y `firestore.rules`: revisar y adaptar | Raíz del proyecto | ✅ **Completado** |
| **B5** | **Modelos de datos para Ligas y Equipos (Entities, Models, Repos)** | `lib/domain/`, `lib/data/` | ✅ **Completado** |
| B6 | Crear primer lote de preguntas de fútbol en JSON → importar a Firestore | `scripts/questions_football.json` (nuevo) | 🔲 |
| B7 | Crear segundo lote de preguntas (más categorías) | `scripts/questions_football_batch2.json` (nuevo) | 🔲 |
| B8 | **Cargar datos iniciales de Ligas y Equipos (La Liga, Premier, etc.)** | Firestore Console / Script | 🔲 |

---

### 🟢 BLOQUE 3 — Infraestructura y Test (SHARED — coordinar)

| # | Tarea | Archivos | Estado |
|---|-------|----------|--------|
| C1 | Copiar `android/` y `ios/` de GeoC y adaptar package name | `android/`, `ios/` | 🔲 |
| C2 | Actualizar `android/app/build.gradle` (applicationId, app name) | `android/app/build.gradle` | 🔲 |
| C3 | Actualizar `ios/Runner/Info.plist` (bundle name) | `ios/Runner/Info.plist` | 🔲 |
| C4 | Renombrar archivos con "geoc" en el nombre: `geoc_page_transitions.dart` | Varios | 🔲 |
| C5 | Verificar que `build_runner` no da errores (ejecutar localmente con Flutter) | Todo el proyecto | 🔲 |
| C6 | Test de compilación: `flutter build apk --debug` | — | 🔲 |
| C7 | Primera versión funcional en dispositivo real | — | 🔲 |

---

## 🎨 Paleta de Colores FutKO

```
Primary:      #1B5E20 (Pitch Green)
Primary Var:  #2E7D32 (Lighter Green)
Secondary:    #C6A54E (Gold)
Tertiary:     #1A237E (Deep Navy)
Background:   #F8FAF8
Surface:      #FFFFFF
On Surface:   #1A1C1B
```

---

## 📂 Categorías de Preguntas (QuestionType)

| Tipo | Descripción | Ejemplo pregunta | ¿Imagen? |
|------|-------------|------------------|----------|
| `player` | Datos de jugadores | "¿En qué equipo jugaba Messi en 2012?" | No |
| `team` | Equipos | "¿Qué equipo ha ganado más Champions?" | No |
| `competition` | Competiciones | "¿En qué año se jugó el primer Mundial?" | No |
| `history` | Historia del fútbol | "¿Quién marcó el gol de la mano de Dios?" | No |
| `rules` | Reglas | "¿Cuántos jugadores expulsados hacen que se suspenda?" | No |
| `stadium` | Estadios | "¿Cómo se llama el estadio del Real Madrid?" | Sí |
| `badge` | Escudos | "¿De qué equipo es este escudo?" | Sí |
| `playerImage` | Fotos de jugadores | "¿Quién es este jugador?" | Sí |
| `statistic` | Estadísticas | "¿Quién es el máximo goleador de la Champions?" | No |
| `transfer` | Traspasos | "¿En qué año fichó Cristiano por la Juve?" | No |

---

## 📝 Convenciones

- **Commits en español** (ej: "Fix: textos en login screen")
- **Push después de cada commit** — si falla, `git pull --rebase && git push`
- **Actualizar este documento** al finalizar cada tarea
- **Marcar con emoji** el estado: ✅ → 🔄 → 🔲

---

## 📊 Log de Cambios

| Fecha | Commit | Descripción |
|-------|--------|-------------|
| 2026-05-03 | bea439d | Fase 4: Infraestructura Ligas y Equipos (Models, Repos, Providers) |
| 2026-05-03 | da84a49 | Bloque 1 completo: Branding y UI adaptada a tema fútbol (19 archivos) |
