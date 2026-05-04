# FutKO — Progreso y Roadmap

> Estado actual del proyecto FutKO (Football Quiz Battle). Última actualización: 03/05/2026.

---

## Estado de Compilación

| Aspecto | Estado |
|---------|--------|
| `flutter analyze` | ✅ Compila (0 errores, solo warnings menores de estilo) |
| `flutter build` | ⚠️ Bloqueado — falta `firebase_options.dart` (ver abajo) |
| Tests | ❌ No hay tests unitarios ni de integración |

---

## 1. Diseño y UI — Stadium Arena

| Módulo | Estado | Notas |
|--------|--------|-------|
| Design System (`AppColors`, `AppTheme`) | ✅ Completado | Paleta dark Stadium Arena implementada |
| Splash Screen | ✅ Completado | Glow radial, césped, portería, barra de progreso tipo campo |
| Login Screen | ✅ Completado | Glassmorphism, botón KICK OFF dorado, social login, pro tip |
| Home Screen | ✅ Completado | TopAppBar estadio, stats jugador, modos de juego, bottom nav |
| Game Screen | ✅ Completado | Pitch gradient, scoreboard glassmorphism, timer circular, grid 2x2 |
| Answer Feedback | ✅ Completado | "¡GOOOOL!" / "¡Tarjeta Roja!", stats grid, dato del partido |
| Game Result | ✅ Completado | Resumen champion, stats ELO, timeline de respuestas |
| Leaderboard Screen | ⚠️ Existe | Necesita revisar que use los nuevos colores del tema |
| Friends Screen | ⚠️ Existe | Necesita aplicar el tema Stadium Arena |
| Match History | ⚠️ Existe | Necesita aplicar el tema Stadium Arena |
| Subscription Modal | ⚠️ UI básica | Diseño funcional pero no integrado con RevenueCat |
| Multiplayer Game | ⚠️ Existe | Fondo hardcodeado (`#1A1A2E`), necesita aplicar tema Stadium |
| Matchmaking Screen | ⚠️ Existe | Necesita aplicar tema Stadium Arena |

---

## 2. Arquitectura y Código Base

| Aspecto | Estado | Prioridad |
|---------|--------|-----------|
| Clean Architecture (domain/data/presentation) | ✅ Implementada | — |
| Riverpod + State Management | ✅ Implementado | — |
| Go Router (navegación) | ✅ Implementado | — |
| Material 3 + Stadium Theme | ✅ Implementado | — |
| Generación de código (`build_runner`) | ✅ Funcionando | `.g.dart` y `.freezed.dart` generados |
| Localización (ES/EN) | ✅ Implementada | `flutter gen-l10n` funciona |
| `pubspec.yaml` | ✅ Reparado | Tenía corrupción de líneas, ya arreglado |
| `question_card.dart` | ✅ Reparado | Tenía corrupción de líneas, ya arreglado |
| `futko_page_transitions.dart` | ✅ Renombrado | Archivo estaba como `geoc_page_transitions.dart` |

---

## 3. Firebase y Backend

### 3.1 Configuración Firebase

| Componente | Estado | Bloqueo |
|------------|--------|---------|
| `firebase_core` | ✅ En `pubspec.yaml` | — |
| `firebase_auth` | ✅ En `pubspec.yaml` | — |
| `cloud_firestore` | ✅ En `pubspec.yaml` | — |
| `firebase_database` | ✅ En `pubspec.yaml` | — |
| `firebase_analytics` | ✅ En `pubspec.yaml` | — |
| **`lib/firebase_options.dart`** | ❌ **NO EXISTE** | 🔴 **Bloquea el arranque de la app** |
| `android/app/google-services.json` | ❌ No verificado | Necesario para Android |
| `ios/Runner/GoogleService-Info.plist` | ❌ No verificado | Necesario para iOS |
| `firebase.json` | ✅ Existe | Verificar configuración |
| `firestore.rules` | ✅ Existe | Verificar reglas de seguridad |
| Firebase Storage | ⏸️ Comentado en pubspec | Se necesitará para imágenes de preguntas |

### 3.2 Firestore — Estructura de Datos

| Colección | Estado | Notas |
|-----------|--------|-------|
| `users` | ✅ Definida | Perfil, ELO, stats, suscripción, dailyGames |
| `matches` | ✅ Definida | Partidas multijugador, respuestas, resultados |
| `questions` | ✅ Definida | Preguntas con tipos, dificultad, imágenes, opciones |
| `ghostRuns` | ✅ Definida | Partidas fantasma para entrenamiento |
| `questionReports` | ✅ Definida | Reportes de preguntas erróneas |
| `quizAttempts` | ✅ Definida | Intentos de quiz individuales |
| **Población de preguntas** | ❌ **Vacía / No seedeada** | 🔴 **Bloquea el juego** |

### 3.3 Funciones Backend

| Función | Estado | Notas |
|---------|--------|-------|
| Auth (email, Google, Apple) | ✅ Implementado | Incluye creación de perfil en Firestore |
| Sistema ELO | ✅ Implementado | Cálculo con K-factor, rangos Bronze→Diamond |
| Presence / Jugadores activos | ✅ Implementado | Actualiza `lastLoginAt` cada 5 min |
| Matchmaking | ✅ Implementado | Cola en Realtime Database, timeout 60s |
| Multijugador en tiempo real | ✅ Implementado | Provider + pantalla de juego |
| Ghost Runs | ✅ Implementado | Entrenamiento contra mejores partidas |
| Sistema de amigos | ✅ Implementado | Requests, lista, provider |
| Leaderboard global | ✅ Implementado | Pantalla + provider |
| Historial de partidas | ✅ Implementado | Match cards, stats resumen |
| Reporte de preguntas | ✅ Implementado | Dialog UI + service |

---

## 4. Base de Datos de Preguntas

Este es un punto crítico. La app obtiene preguntas desde Firestore (`questions` collection).

### Tipos de preguntas soportados

1. `player` — ¿Qué jugador es este?
2. `team` — ¿De qué equipo se trata?
3. `competition` — ¿Qué competición es esta?
4. `history` — Preguntas históricas
5. `rules` — Reglamento
6. `stadium` — ¿Qué estadio es este?
7. `badge` — Escudos de equipos
8. `playerImage` — Siluetas/imágenes de jugadores
9. `statistic` — Estadísticas
10. `transfer` — Transferencias

### Requisitos para completar

| Tarea | Prioridad | Notas |
|-------|-----------|-------|
| **Seed de preguntas iniciales** | 🔴 **Crítica** | Mínimo 200-500 preguntas para lanzar |
| Imágenes de escudos | 🔴 Crítica | Necesitan alojarse en Firebase Storage o CDN |
| Imágenes de estadios | 🔴 Crítica | — |
| Siluetas de jugadores | 🔴 Crítica | Carpeta `assets/silhouettes/` referenciada pero vacía |
| Imágenes de competiciones | 🟡 Media | — |
| Sistema de moderación de preguntas | 🟡 Media | Revisar reportes desde panel admin |
| Importador CSV/JSON de preguntas | 🟡 Media | Facilita añadir preguntas en batch |

---

## 5. Monetización y Suscripciones

| Componente | Estado | Notas |
|------------|--------|-------|
| `purchases_flutter` (RevenueCat) | ✅ En `pubspec.yaml` | SDK instalado |
| UI de suscripción (modal) | ✅ Implementada | Botón premium en Home |
| Configuración RevenueCat | ❌ No implementada | Falta API key, product IDs, entitlements |
| Lógica de límites free/premium | ✅ Implementada | `GameConstants`: 1 casual + 1 ranked/día gratis, 5 ranked premium |
| Restricción de modos por plan | ⚠️ Parcial | UI muestra modos pero no bloquea sin suscripción |

---

## 6. Multijugador

| Funcionalidad | Estado | Notas |
|---------------|--------|-------|
| Matchmaking (casual, ranked, ghostRun, friendChallenge) | ✅ Implementado | 4 modos soportados |
| Sincronización de preguntas | ✅ Implementado | Mismo set para ambos jugadores |
| Sistema de respuestas en tiempo real | ✅ Implementado | Comparativa post-partida |
| Chat / Emotes durante partida | ❌ No implementado | Mejora UX pero no es crítico |
| Reconexión si se cae la conexión | ⚠️ Básica | Firebase RTDB maneja esto parcialmente |
| Emparejamiento por rango ELO | ✅ Implementado | `matchmakingEloRange = 200` |
| Sistema de revancha | ✅ Implementado | Botón en GameResultWidget |
| Agregar oponente como amigo | ✅ Implementado | Botón post-partida |

---

## 7. Assets y Recursos

| Recurso | Estado | Prioridad |
|---------|--------|-----------|
| `assets/images/` | ❌ Vacío o no existe | 🟡 Media — fondos, branding |
| `assets/silhouettes/` | ❌ Vacío | 🔴 Crítica — para preguntas tipo `playerImage` |
| `assets/audio/` | ❌ Vacío | 🟡 Media — sonidos de gol, tarjeta, ambiente |
| `assets/lottie/` | ❌ Vacío | 🟢 Baja — animaciones opcionales |
| Icono de app (launcher) | ❌ No verificado | 🟡 Media |
| Splash nativo (Android/iOS) | ❌ No verificado | 🟡 Media |

---

## 8. Testing y Calidad

| Tipo | Estado | Notas |
|------|--------|-------|
| Tests unitarios | ❌ 0 tests | Carpeta `test/` no existe |
| Tests de integración | ❌ 0 tests | Carpeta `integration_test/` no existe |
| Tests de widgets | ❌ 0 tests | — |
| Golden tests (UI) | ❌ 0 tests | — |
| CI/CD (GitHub Actions) | ❌ No configurado | — |
| Firebase Crashlytics | ❌ No integrado | Recomendado para producción |
| Firebase Performance | ❌ No integrado | Opcional |

---

## 9. Plataformas y Despliegue

| Plataforma | Estado | Bloqueos |
|------------|--------|----------|
| Android | ⚠️ Configuración incompleta | Falta `google-services.json`, launcher icons, splash |
| iOS | ⚠️ Configuración incompleta | Falta `GoogleService-Info.plist`, configuración Xcode |
| Web | ⚠️ Configurada parcialmente | `main.dart` usa `DefaultFirebaseOptions.web` pero no existe `firebase_options.dart` |
| macOS | ❌ No configurado | — |
| Windows | ❌ No configurado | — |

---

## 10. Roadmap Recomendado

### Fase 1: Fundamentos (Bloqueantes para MVP)

1. **Generar `firebase_options.dart`**
   ```bash
   flutterfire configure
   ```
   Esto desbloquea el arranque de la app.

2. **Seed de preguntas**
   - Crear script para importar 500+ preguntas a Firestore.
   - Mínimo: 50 por tipo de pregunta.
   - Incluir URLs de imágenes (alojar en Storage o usar imágenes públicas).

3. **Configurar Firebase Storage**
   - Descomentar en `pubspec.yaml`.
   - Subir escudos, estadios, siluetas.
   - Actualizar URLs en documentos de preguntas.

4. **Configurar RevenueCat**
   - Crear cuenta/app en RevenueCat.
   - Configurar productos (App Store / Play Store).
   - Añadir API key al código.
   - Implementar lógica de purchase/restore.

### Fase 2: Calidad y Experiencia

5. **Aplicar tema Stadium Arena a pantallas restantes**
   - MultiplayerGameScreen (fondo hardcodeado)
   - MatchmakingScreen
   - LeaderboardScreen
   - FriendsScreen
   - MatchHistoryScreen
   - SubscriptionModal (quitar referencias "vintage")

6. **Tests mínimos**
   - Tests unitarios para `EloCalculator`, `ScoreCalculator`.
   - Tests de widgets para Login y Home.
   - 1 test de integración: flujo completo de partida rápida.

7. **Assets**
   - Icono launcher (Android/iOS).
   - Splash nativo.
   - Audio: sonido de gol, tarjeta roja, countdown.

### Fase 3: Features Avanzados

8. **Push Notifications**
   - `firebase_messaging` para invitaciones de amigos.
   - Notificaciones cuando un oponente responde en partidas asíncronas.

9. **Firebase Crashlytics + Analytics**
   - Trackear eventos: `game_started`, `question_answered`, `purchase_initiated`.
   - Crashlytics para errores en producción.

10. **Panel de Administración Web**
    - Ver reportes de preguntas.
    - Añadir/Editar preguntas.
    - Ver estadísticas de uso.

11. **Modo Asíncrono (Play-by-Mail)**
    - Jugar contra oponentes sin estar online al mismo tiempo.

12. **Temporadas y Torneos**
    - Reseteo de ELO cada temporada.
    - Torneos bracket-style.

---

## Checklist de Lanzamiento (MVP)

- [ ] `firebase_options.dart` generado
- [ ] `google-services.json` en Android
- [ ] `GoogleService-Info.plist` en iOS
- [ ] 500+ preguntas en Firestore
- [ ] Imágenes de preguntas en Firebase Storage
- [ ] RevenueCat configurado y funcionando
- [ ] Tests unitarios básicos
- [ ] Icono launcher y splash
- [ ] Política de privacidad + Términos
- [ ] Cuentas de desarrollador (App Store + Play Store)
- [ ] Beta cerrada con 20-50 usuarios

---

## Notas Técnicas

### Errores conocidos previos (ya resueltos)
- `pubspec.yaml` corrupto → Resuelto
- `question_card.dart` corrupto → Resuelto
- `futko_page_transitions.dart` no encontrado → Resuelto (renombrado)

### Generación de código
Si se modifica un provider o modelo con `@riverpod` / `@freezed`:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Localizaciones
```bash
flutter gen-l10n
```

---

*Documento vivo — actualizar tras cada milestone.*
