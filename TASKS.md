# FutKO — Tablero de Carriles (trabajo en paralelo)

> Reparto del trabajo pendiente para varios LLMs a la vez. Lee primero `AGENTS.md` (reglas) y `CLAUDE.md` (arquitectura).
> Creado: 2026-06-05 · Basado en auditoría del estado real del código.

**Cómo usar este tablero:** reclama un carril poniendo tu nombre y `🔄` en la columna Estado **antes** de empezar. Un carril = un LLM. No edites archivos fuera de tu carril (ver Hot files en `AGENTS.md`).

**Leyenda de estado:** 🔲 LIBRE · 🔄 EN PROGRESO (owner) · ✅ HECHO · ⛔ BLOQUEADO

---

## ✅ Fase 0 — hecha por Claude Code (orquestador)
- `pubspec.yaml` congelado con las deps de los carriles: **+firebase_messaging, +firebase_crashlytics, +flutter_local_notifications**. Nadie más toca pubspec.
- Contrato de dominio limpiado: **eliminados los `QuestionType` geográficos** heredados del fork (`area, population, border, river, region, lake, mountain`). `QuestionType` ahora es solo fútbol.
- Creados `AGENTS.md` (reglas) y este `TASKS.md` (reparto).

---

## Carriles

### ✅ C1 — Backend & Seguridad · 🔴 P0 · Estado: ✅ OpenCode
**Por qué:** la app escribe en colecciones sin reglas → fallan en silencio; ELO/matchmaking son client-side (manipulables).
**Alcance (archivos):** `firestore.rules`, `storage.rules`, `firestore.indexes.json` (nuevo), `functions/` (Node 18 + TS, nuevo).
**Tareas:**
- [x] Reglas para **`quizAttempts`** (hoy SIN regla → denegado). La app escribe en `game_provider.dart:315`. `create: if isAuth()`, `read: owner`.
- [x] Reglas para **`questionReports`** (hoy SIN regla → denegado). Escribe `report_question_dialog`. `create: if isAuth()`.
- [x] **Endurecer `matches`**: hoy `create/update: if isAuth()` permite a cualquiera editar cualquier partida. Exigir que `request.auth.uid` esté en `players`.
- [x] Crear **`firestore.indexes.json`** con los índices compuestos que usan las queries (revisar `question_repository_impl.dart`, `multiplayer_provider.dart`, `match_repository_impl.dart`).
- [x] (Alto valor) **Cloud Functions** en `functions/` (ya declarado en `firebase.json`): ELO autoritativo al cerrar match, reset diario de `dailyGames`, validación de respuestas. Referencia de ELO: `core/utils/elo_calculator.dart`.
**Aceptación:** `firebase deploy --only firestore:rules,storage` OK; el tracking de `quizAttempts` y los reportes ya no fallan; un no-participante no puede editar un match.
**Dependencias:** ninguna — puede empezar ya.

### ✅ C2 — Contenido & Imágenes · 🔴 P0 · Estado: ✅ Cline
**Por qué:** el dataset tiene **0 `imageUrl`** y los distractores se mezclan entre tipos.
**Alcance:** `lib/data/questions/football_data.dart`, `lib/services/question_seeder_service.dart`, `lib/data/repositories/question_repository_impl.dart` (**solo** `_enrichOptions`), `scripts/`, bucket de Storage (`/badges`, `/stadiums`, `/players`, `/silhouettes`, `/competitions`).
**Tareas:**
- [x] **Distractores por categoría:** `_enrichOptions` filtra `sameTypeQuestions` (`q.type == question.type`) con fallback a cualquier tipo si no hay suficientes.
- [x] **Imágenes:** `imageUrl` se asigna en `question_seeder_service.dart` durante el seeding; scripts de descarga/subida en `scripts/`.
- [x] **Script de subida** a Firebase Storage: `scripts/upload_images.dart` + `scripts/download_images.dart`.
- [x] Ampliar volumen del dataset: ~360 registros (Team/Player/Stadium/Competition/HistoryFact/Rule/Statistic).
**Aceptación:** una partida muestra imágenes reales en preguntas `badge`/`stadium`/`playerImage`; los distractores son coherentes.
**Dependencias:** subir a Storage requiere que Storage esté activado en la consola Firebase (acción del usuario).

### ✅ C3 — Monetización (RevenueCat) · 🟡 P1 · Estado: ✅ OpenCode
**Por qué:** API key placeholder; sin productos/entitlements; gating por plan parcial.
**Alcance:** `lib/services/revenuecat_service.dart`, `lib/presentation/providers/subscription_provider.dart`, `lib/presentation/screens/home/widgets/subscription_modal.dart`. (Init en arranque: coordinar `main.dart` con el orquestador.)
**Tareas:**
- [x] Sustituir `_apiKey = 'YOUR_REVENUECAT_API_KEY'` (`revenuecat_service.dart:4`) por config real **por plataforma vía `--dart-define`** (no hardcode).
- [x] Configurar offering + entitlement `premium`; conectar compra/restore reales.
- [x] Aplicar **gating por plan** en los modos (hoy parcial). El límite diario ya existe en `user_provider.dart` / `home_screen.dart:546`.
- [x] Llamar a `subscription.initialize()` + `setUserId(uid)` tras el login.
**Aceptación:** compra en sandbox funciona; `isPremium` refleja la compra; modos premium bloqueados para free.
**Dependencias:** cuenta RevenueCat + productos en las stores (acción del usuario).

### ✅ C4 — Pantallas & UX · 🟡 P1 · Estado: ✅ Claude
**Por qué:** no existe pantalla de perfil; 3 TODOs de navegación muertos; avatars mock.
**Alcance:** `lib/presentation/screens/**` (archivos nuevos en `profile/`, `settings/`), `lib/app.dart` (**este carril es el ÚNICO dueño de las rutas nuevas**).
**Tareas:**
- [x] Crear **`ProfileScreen`** (perfil, stats, ELO, historial) y enlazar los TODOs: `home_screen.dart:268`, `friends_screen.dart:686`, `match_history_screen.dart:231`.
- [x] Crear **`SettingsScreen`** (logout, idioma, sonido, suscripción).
- [x] Sustituir "Participants avatars (mock)" (`game_screen.dart:596`) por datos reales.
- [x] Añadir rutas en `app.dart` (`/profile/:userId`, `/settings`).
**Aceptación:** tocar avatar/perfil navega a `ProfileScreen` real; Settings accesible; sin TODOs de navegación.
**Dependencias:** usa `AppColors`/tema existentes. Dueño exclusivo de `app.dart` mientras dure el carril.

### 🔲 C5 — Observabilidad & Push · 🟡 P1 · Estado: LIBRE
**Por qué:** sin push, sin crash reporting, sin instrumentación de analytics.
**Deps ya añadidas en Fase 0:** `firebase_messaging`, `firebase_crashlytics`, `flutter_local_notifications`.
**Alcance:** `lib/services/` (nuevos: `messaging_service.dart`, `crashlytics_service.dart`), instrumentación en providers, `android/`, `ios/`. (Init en `main.dart`: **coordinar con el orquestador**.)
**Tareas:**
- [ ] Inicializar **Crashlytics** (`FlutterError.onError`) y **Messaging** (permisos, token, handlers foreground/background con `flutter_local_notifications`).
- [ ] Push: invitaciones de amigos y aviso de turno en partidas asíncronas (usa `friend_repository` / ghost runs).
- [ ] Instrumentar **Analytics** (`firebase_analytics` ya está): `game_started`, `question_answered`, `match_finished`, `purchase_initiated`.
**Aceptación:** un crash forzado aparece en Crashlytics; el dispositivo recibe una push de prueba; eventos visibles en DebugView.
**Dependencias:** `main.dart` (hot file) — coordinar el orden de init con el orquestador.

### 🔄 C6 — Testing · 🟢 P2 · Estado: 🔄 unit tests hechos; faltan widget tests
**Por qué:** 0 tests reales; `widget_test.dart` es el template roto.
**Alcance:** `test/**`, `integration_test/**`. **Solo LEE `lib/`** (no modifica producción) → cero riesgo de choque.
**Tareas:**
- [x] Arreglar/borrar `test/widget_test.dart` (borrado en la consolidación).
- [x] Unit tests: `elo_calculator`, `score_calculator`, `fuzzy_matcher`, `dailyGamesStatus` (`test/core/`, 81 tests en verde). Falta test de `_enrichOptions`.
- [ ] Widget tests: `LoginScreen` y `HomeScreen`.
- [ ] (Opcional) `integration_test`: flujo de partida rápida.
**Aceptación:** `flutter test` en verde, cubriendo las utils de cálculo. ✅ (utils cubiertas; widget tests pendientes)
**Dependencias:** ninguna — puede empezar ya. Si C2 cambia `_enrichOptions`, sincronizar el test.

> Nota orquestador (2026-06-06): la rama `carril/6-testing` (tip `58432f5`) era de antes de la consolidación; su contenido (4 tests + `scripts/download_images.dart`) ya estaba en `main` idéntico. Mergearla habría revertido C2/C3/C4 y `functions/`, AGENTS.md, etc. **Borrada** para evitar un merge destructivo (recuperable: `git branch carril/6-testing 58432f5`).

---

## Orden recomendado
- **Arrancan ya, sin esperar a nadie:** C1, C2, C6.
- **Necesitan acción externa del usuario** (cuentas/activación): C3 (RevenueCat + stores), C2 (activar Storage).
- **Coordinan `main.dart` con el orquestador:** C3, C5. **Dueño de `app.dart`:** C4.

## Bloqueos
> Apunta aquí cualquier necesidad de tocar un archivo de otro carril o un hot file. Formato: `[carril] necesito X de [archivo] — motivo`.
- (vacío)
