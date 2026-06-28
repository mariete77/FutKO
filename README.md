# FutKO ⚽🎮

Juego móvil/web de preguntas 1v1 de **fútbol** en tiempo real: 10 preguntas × 10 s por partida, ranking por **Ligas** (pirámide española) sobre un ELO oculto, multijugador en vivo y modelo freemium.

> **Fork rebranded.** FutKO nació como un juego de geografía ("GeoC"). Quedan
> algunos artefactos heredados; el tema real es el oscuro **"Stadium Arena"**
> (`lib/core/theme/app_colors.dart`, la app fuerza `ThemeMode.dark`). El locale
> por defecto es **español** (`lib/l10n/app_es.arb`).

## 📋 Descripción

FutKO es un juego competitivo de trivial de fútbol donde dos jugadores se
enfrentan respondiendo preguntas en tiempo real. Cada partida dura ~1 min con
10 preguntas de 10 s cada una (15 s en las de respuesta escrita).

### 🎯 Características Principales

- **Modos de juego**: Partida rápida (casual), Ranked, Reto de amigo y
  *Ghost Run* (contra mejores partidas grabadas)
- **Matchmaking**: cola en tiempo real (Realtime Database) por rango ELO ±200,
  con fallback asíncrono
- **Tipos de preguntas**: jugador, equipo, competición, historia, reglas,
  estadio, escudo, silueta/imagen de jugador, estadística, transferencia.
  ~30% se convierten en respuesta escrita (validación *fuzzy*, ≥0.85 = correcto)
- **Sistema de Ligas**: 5 tiers (Tercera RFEF → Primera División) con puntos
  0–99; ascenso/descenso por partida ranked. El ELO queda como MMR oculto
  (ver `ELO_LIGAS_DESIGN.md`). **El cálculo de ELO + LP es autoritativo en el
  backend** (Cloud Function `onMatchFinished`)
- **Modelo Freemium**: 1 casual + 1 ranked gratis/día; suscripción para más
  ranked (RevenueCat)
- **Game feel**: haptics, feedback instantáneo, "+puntos" flotante, timer con
  tensión, comodines en vivo (+tiempo, doble puntos), racha diaria y logros

## 🛠️ Stack Tecnológico

- **Frontend**: Flutter 3.x (Dart)
- **State Management**: Riverpod 2.x
- **Backend**: Firebase (Auth, Firestore, Functions, Storage)
- **Payments**: RevenueCat
- **Analytics**: Firebase Analytics

## 📱 Estructura del Proyecto

```
FutKO/
├── lib/                    # Código fuente Flutter
│   ├── core/              # Constantes, errores, utils, tema
│   ├── data/              # Models, repositories, datasources
│   ├── domain/            # Entidades, use cases
│   ├── presentation/      # Screens, widgets, providers
│   └── services/          # Firebase, audio, notifications
├── functions/             # Cloud Functions (TypeScript)
├── test/                  # Tests
├── docs/                  # Documentación adicional
└── scripts/               # Scripts útiles
```

## 🚀 Primeros Pasos

### Requisitos Previos

```bash
# Flutter SDK (3.16+)
flutter --version

# Firebase CLI
npm install -g firebase-tools
firebase login

# FlutterFire CLI
dart pub global activate flutterfire_cli
```

### Instalación

```bash
# Obtener dependencias
flutter pub get

# Generar código (freezed, json_serializable)
dart run build_runner build --delete-conflicting-outputs

# Iniciar proyecto
flutter run
```

### Configuración de Firebase

1. Crear proyecto en Firebase Console: https://console.firebase.google.com
2. Ejecutar: `flutterfire configure --project=futko-battle`
3. Habilitar servicios: Auth, Firestore, Functions, Storage, Realtime Database

## 🎮 Modos de Juego

### Casual (Partida Rápida)
- Sin afectar ELO ni liga (el backend lo ignora)
- 1 partida gratis/día (free users)
- Matchmaking casual

### Ranked
- Afecta tu ELO y tus puntos de Liga (autoritativo en el backend)
- 1 partida gratis/día (free users), 5/día (premium)
- Matchmaking por rango de ELO
- Sistema de ligas (pirámide española): Tercera RFEF → Primera División

## 💰 Monetización

| Característica | Gratis | Premium |
|---------------|--------|---------|
| Partidas casual/día | 1 | Ilimitadas |
| Partidas ranked/día | 1 | 5 |
| Sin anuncios | ❌ | ✅ |
| Estadísticas avanzadas | ❌ | ✅ |

## 🏆 Sistema de Ligas y ELO

- **ELO** (MMR oculto): inicial 1000, mínimo 100, K 32 (<30 partidas) / 16.
  Solo se usa para emparejar y modular los puntos de liga.
- **Ligas** (visible): 5 tiers — Tercera RFEF, Segunda RFEF, Primera RFEF,
  Segunda División, Primera División. Puntos 0–99 por liga; al cruzar 100
  asciendes, al bajar de 0 desciendes. Escudo anti-descenso en placement
  (5 primeras ranked).
- **Autoritativo:** ELO + LP los calcula la Cloud Function `onMatchFinished`
  al cerrar la partida ranked; el cliente solo reporta `scores` + `winnerId`.
- Rango de matchmaking: ±200 ELO.
- Detalle de diseño: [`ELO_LIGAS_DESIGN.md`](ELO_LIGAS_DESIGN.md)

## 📖 Documentación

- [`PROGRESS.md`](PROGRESS.md) — estado actual del proyecto (fuente de verdad)
- [`CLAUDE.md`](CLAUDE.md) — arquitectura, comandos y *gotchas* del fork
- [`AGENTS.md`](AGENTS.md) — protocolo para agentes IA (worktrees, coordinación)
- [`ELO_LIGAS_DESIGN.md`](ELO_LIGAS_DESIGN.md) — diseño del sistema de Ligas
- [`BRAINSTORM.md`](BRAINSTORM.md) — mejoras de *game feel* priorizadas
- [`Pantallas/DESIGN.md`](Pantallas/DESIGN.md) — design system **Stadium Arena** (el real)
- [`docs/GITEA_OAUTH_SETUP.md`](docs/GITEA_OAUTH_SETUP.md) — OAuth Gitea

> `DESIGN.md` (raíz) y secciones de fases más abajo son de la era geografía y
> están desactualizadas; consultar `PROGRESS.md` y `CLAUDE.md` para la verdad.

### Scripts Disponibles (`scripts/`)
- **seed_questions.dart** — siembra preguntas en Firestore desde `lib/data/questions/football_data.dart`
- **upload_images.dart** / **download_images.dart** — subir/bajar imágenes de preguntas a Firebase Storage
- **update_image_urls.dart** — actualizar `imageUrl` en preguntas existentes

## 🧪 Testing

```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Con cobertura
flutter test --coverage
```

## 🚀 Despliegue

```bash
# Android
flutter build appbundle --release

# iOS
flutter build ios --release

# Cloud Functions
cd functions
npm run deploy

# Firebase Rules
firebase deploy --only firestore:rules
firebase deploy --only storage
```

## 📊 Progreso del Desarrollo

### ✅ FASE 1: Fundamentos Backend (Completada)
- ✅ Modelos de datos (User, Question, Match, GhostRun)
- ✅ Repositorios del dominio (5 interfaces)
- ✅ Implementaciones con Firebase (5 repositorios)
- ✅ AuthRemoteDataSource (Google/Apple)
- ✅ Manejo de errores con dartz Either
- 📄 [Instrucciones detalladas](docs/FASE1_INSTRUCCIONES.md)

### ✅ FASE 2: Autenticación y Home (Completada)
- ✅ AuthProvider (Google/Apple sign-in)
- ✅ UserProvider (perfil, stats, juegos diarios)
- ✅ SplashScreen (animada)
- ✅ LoginScreen (social login)
- ✅ HomeScreen (dashboard completo)
- ✅ Go Router configuration (routing con protección)
- ✅ Widgets comunes (Loading, Error, Button)
- 📄 [Instrucciones detalladas](docs/FASE2_INSTRUCCIONES.md)

### ✅ FASE 3: Base de Datos de Preguntas (Completada)
- ✅ Dataset de fútbol en `lib/data/questions/football_data.dart`
- ✅ Seeder a Firestore (`scripts/seed_questions.dart`, `lib/services/question_seeder_service.dart`)
- ✅ ~10 tipos de preguntas (jugador, equipo, competición, estadio, escudo, etc.)
- ✅ Distractores coherentes por categoría (`_enrichOptions`)
- 🔴 Imágenes de preguntas pendientes de subir a Storage (escudos/estadios/siluetas)

> Las fases 4–8 (core del juego, matchmaking, ghost runs, monetización, polish)
> están **implementadas**. El detalle vivo del estado está en
> [`PROGRESS.md`](PROGRESS.md) — esta sección ya no se mantiene aquí para evitar
> dos fuentes de verdad.

## 📊 Arquitectura

El proyecto sigue una **arquitectura limpia** con separación de capas:

```
Presentation (UI) → Domain (Lógica de negocio) → Data (Persistencia)
                    ↓
                Services (Firebase, Audio, etc.)
```

## 🤝 Contribución

Este proyecto está en desarrollo activo. Para contribuir:

1. Fork el repositorio
2. Crea una rama: `git checkout -b feature/nueva-funcionalidad`
3. Commit: `git commit -m 'Añadir nueva funcionalidad'`
4. Push: `git push origin feature/nueva-funcionalidad`
5. Pull Request

## 📝 License

[Indicar licencia]

## 👥 Autores

- [@mariete77](https://github.com/mariete77) - Desarrollo principal

## 🙏 Agradecimientos

- Flutter Team
- Firebase
- Riverpod
- REST Countries API
- FlagCDN

---

**¡Prepárate para demostrar tus conocimientos de geografía! 🌍**
