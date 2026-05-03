<div align="center">

# ⚽ FutKO

### Trivia de Fútbol 1vs1 en Tiempo Real

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=flat-square&logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?style=flat-square&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Riverpod](https://img.shields.io/badge/Riverpod-2.x-4C1?style=flat-square)](https://riverpod.dev)
[![Licencia](https://img.shields.io/badge/Licencia-Propietaria-red?style=flat-square)](LICENSE)

**Demostrá lo que sabés. Retá a tu rival. Ganá la partida.**

</div>

---

## 📋 Descripción

FutKO es un juego de trivia de fútbol competitivo donde dos jugadores se enfrentan en tiempo real respondiendo preguntas. Cada partida es un duelo de conocimiento: 10 preguntas, 10 segundos por pregunta, y solo uno sale victorioso.

Nacido como fork de [GeoC](https://github.com/mariete77/geoc) (quiz de geografía), FutKO adapta toda la infraestructura de batallas 1vs1, sistema ELO y matchmaking al mundo del fútbol.

---

## ✨ Características Principales

### 🎮 Modos de Juego
- **Modo Casual** — Partida rápida sin afectar tu ELO. Ideal para calentar.
- **Modo Competitivo (Ranked)** — Apuesta tu ELO y escalá en el ranking global.
- **Ghost Run** — Jugá contra tu mejor réplica. Competí contra vos mismo de forma asíncrona.
- **Amigos y Retos** — Desafiá directamente a tus amigos a un duelo de trivia.

### 📚 10 Categorías de Preguntas

| Categoría | Descripción | Ejemplo |
|-----------|-------------|---------|
| `player` | Datos de jugadores | *"¿En qué equipo jugaba Messi en 2012?"* |
| `team` | Equipos | *"¿Qué equipo ha ganado más Champions?"* |
| `competition` | Competiciones | *"¿En qué año se jugó el primer Mundial?"* |
| `history` | Historia del fútbol | *"¿Quién marcó el gol de la mano de Dios?"* |
| `rules` | Reglas | *"¿Cuántos expulsados hacen que se suspenda un partido?"* |
| `stadium` | Estadios | *"¿Cómo se llama el estadio del Real Madrid?"* |
| `badge` | Escudos (con imagen) | *"¿De qué equipo es este escudo?"* |
| `playerImage` | Fotos de jugadores | *"¿Quién es este jugador?"* |
| `statistic` | Estadísticas | *"¿Quién es el máximo goleador de la Champions?"* |
| `transfer` | Traspasos | *"¿En qué año fichó Cristiano por la Juventus?"* |

### 🏆 Sistema de Ranking ELO

Competí y subí de rango según tu rendimiento:

| Rango | ELO | Color |
|-------|-----|-------|
| 🌟 **Leyenda** | 2400+ | Diamante |
| 🥇 **Balón de Oro** | 2000–2399 | Oro |
| 🏅 **Campeón** | 1600–1999 | Platino |
| ⚽ **Titular** | 1200–1599 | Plata |
| 🔰 **Promesa** | < 1200 | Bronce |

- **ELO inicial:** 1000
- **K-factor (nuevos):** 32 (< 30 partidas)
- **K-factor (establecidos):** 16 (≥ 30 partidas)
- **Rango de matchmaking:** ± 200 ELO

### 🏟️ Ligas y Equipos

Datos de las principales ligas del mundo para enriquecer las preguntas:

- 🇪🇸 La Liga
- 🏴󠁧󠁢󠁥󠁮󠁧󠁿 Premier League
- 🇮🇹 Serie A
- 🇩🇪 Bundesliga
- 🇫🇷 Ligue 1

---

## 🛠️ Stack Tecnológico

| Capa | Tecnología |
|------|------------|
| **Framework** | Flutter 3.x (Dart ≥ 3.0) |
| **Backend** | Firebase (Firestore, Auth, Realtime Database, Analytics) |
| **Autenticación** | Google Sign-In, Sign in with Apple |
| **Estado** | Flutter Riverpod 2.x + Riverpod Annotation |
| **Navegación** | GoRouter 13.x |
| **Pagos** | RevenueCat (Purchases Flutter) |
| **Modelos** | Freezed + json_serializable |
| **Programación funcional** | dartz (Either para manejo de errores) |
| **UI** | Lottie, Shimmer, Cached Network Image, Flutter SVG, Google Fonts |
| **Audio** | Audioplayers |
| **Tests** | flutter_test, Mockito, Integration Test |

---

## 🏗️ Arquitectura

El proyecto sigue **Clean Architecture** con separación estricta de capas:

```
Presentation (UI + Providers)
        │
        ▼
   Domain (Entities + Repository Interfaces)
        │
        ▼
    Data (Models + Repository Implementations + Services)
```

### Principios
- **Domain** no depende de ningún framework — entidades puras en Dart.
- **Data** implementa las interfaces del dominio usando Firebase como fuente de datos.
- **Presentation** consume el dominio a través de providers (Riverpod).
- Manejo de errores funcional con `Either<Failure, T>` (dartz).

---

## 🎨 Paleta de Colores

FutKO utiliza una identidad visual inspirada en el césped del estadio, el oro de los trofeos y la noche de las finales europeas.

| Color | Hex | Uso |
|-------|-----|-----|
| 🟢 **Pitch Green** | `#1B5E20` | Color primario, CTAs, elementos principales |
| 🟡 **Gold** | `#C6A54E` | Color secundario, acentos, highlights |
| 🔵 **Deep Navy** | `#1A237E` | Color terciario, elementos competitivos |
| ⬜ **Background** | `#F8FAF8` | Fondo de la app |
| ⬛ **On Surface** | `#1A1C1B` | Texto principal |

**Regla de diseño:** No se usan bordes de 1px. La jerarquía se define exclusivamente mediante cambios de tono en los fondos (tonal layering).

---

## 📂 Estructura del Proyecto

```
FutKO/
├── lib/
│   ├── main.dart                        # Punto de entrada
│   ├── app.dart                         # Configuración de la app + GoRouter
│   ├── core/
│   │   ├── constants/                   # AppConstants, FirebaseConstants, GameConstants
│   │   ├── errors/                      # Failures y Exceptions
│   │   ├── theme/                       # AppColors, AppTheme
│   │   └── utils/                       # Helpers y utilidades
│   ├── data/
│   │   ├── datasources/remote/          # Fuentes de datos remotas (Firebase)
│   │   ├── models/                      # DTOs (Freezed + json_serializable)
│   │   ├── repositories/                # Implementaciones de repositorios
│   │   └── services/                    # Servicios (audio, notificaciones)
│   ├── domain/
│   │   ├── entities/                    # Entidades de dominio (User, Match, Question, League, Team)
│   │   └── repositories/               # Interfaces de repositorios
│   ├── presentation/
│   │   ├── providers/                   # Riverpod providers
│   │   ├── screens/
│   │   │   ├── auth/                    # Login, registro
│   │   │   ├── friends/                 # Lista de amigos, retos
│   │   │   ├── game/                    # Pantalla de juego, widgets de pregunta
│   │   │   ├── history/                 # Historial de partidas
│   │   │   ├── home/                    # Dashboard, leaderboard
│   │   │   ├── multiplayer/             # Matchmaking
│   │   │   └── splash/                  # Pantalla de carga
│   │   └── widgets/common/             # Widgets reutilizables
│   └── l10n/                            # Internacionalización (ES, EN)
├── assets/
│   ├── images/
│   ├── silhouettes/
│   ├── audio/
│   └── lottie/
├── firestore.rules                      # Reglas de seguridad Firestore
├── firebase.json                        # Configuración Firebase
├── pubspec.yaml
├── DESIGN.md                            # Documento de diseño visual
├── STATUS.md                            # Estado actual del proyecto
└── PROGRESS.md                          # Hoja de ruta colaborativa
```

---

## 🚀 Primeros Pasos

### Requisitos Previos

- **Flutter SDK** 3.16+ (`flutter --version`)
- **Dart SDK** ≥ 3.0
- **Firebase CLI** (`npm install -g firebase-tools`)
- **FlutterFire CLI** (`dart pub global activate flutterfire_cli`)
- Un proyecto Firebase configurado

### Instalación

```bash
# 1. Clonar el repositorio
git clone https://github.com/mariete77/FutKO.git
cd FutKO

# 2. Obtener dependencias
flutter pub get

# 3. Generar código (Freezed, json_serializable, Riverpod)
dart run build_runner build --delete-conflicting-outputs

# 4. Ejecutar la app
flutter run
```

### Configuración de Firebase

1. Crear un proyecto en [Firebase Console](https://console.firebase.google.com).
2. Habilitar los servicios necesarios:
   - **Authentication** — Google y Apple como proveedores.
   - **Cloud Firestore** — Base de datos principal.
   - **Realtime Database** — Estado en tiempo real de partidas.
   - **Analytics** — Métricas de uso.
3. Ejecutar la configuración de FlutterFire:
   ```bash
   flutterfire configure --project=tu-proyecto-firebase
   ```
4. Colocar los archivos de configuración:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
5. Desplegar las reglas de Firestore:
   ```bash
   firebase deploy --only firestore:rules
   ```

---

## 🧪 Testing

```bash
# Tests unitarios
flutter test

# Tests de integración
flutter test integration_test/

# Tests con cobertura
flutter test --coverage
```

---

## 📦 Build y Despliegue

```bash
# Android (App Bundle para Play Store)
flutter build appbundle --release

# iOS (para App Store Connect)
flutter build ios --release
```

---

## 📊 Estado del Proyecto

| Fase | Descripción | Estado |
|------|-------------|--------|
| **Fase 1** | Estructura base (Clean Architecture) | ✅ Completada |
| **Fase 2** | Modelos de datos (Match, Question, ELO) | ✅ Completada |
| **Fase 3** | Preguntas de fútbol (Content/UI) | 🛠️ En progreso |
| **Fase 4** | Ligas y Equipos (Infraestructura) | 🛠️ En progreso |
| **Fase 5** | Matchmaking Multiplayer | ⏳ Pendiente |

> 📄 Para más detalle, consultá [PROGRESS.md](PROGRESS.md) y [STATUS.md](STATUS.md).

---

## 🤝 Contribución

Este proyecto está en desarrollo activo. Para contribuir:

1. Hacé fork del repositorio.
2. Creá una rama: `git checkout -b feature/mi-funcionalidad`
3. Commiteá tus cambios: `git commit -m "Añadir mi funcionalidad"`
4. Hacé push: `git push origin feature/mi-funcionalidad`
5. Abrí un Pull Request.

**Convenciones:**
- Commits en español.
- Push después de cada commit.
- Actualizar `PROGRESS.md` al finalizar cada tarea.

---

## 👥 Autores

- **[@mariete77](https://github.com/mariete77)** — Desarrollo principal

---

## 🙏 Agradecimientos

- [Flutter](https://flutter.dev) — Framework UI
- [Firebase](https://firebase.google.com) — Backend serverless
- [Riverpod](https://riverpod.dev) — Gestión de estado reactiva
- [GeoC](https://github.com/mariete77/geoc) — Proyecto original del cual nace FutKO

---

<div align="center">

**⚽ ¡Preparate para demostrar lo que sabés de fútbol! 🏆**

</div>
