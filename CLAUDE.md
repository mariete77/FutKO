# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Karpathy Behavioral Guidelines

Behavioral guidelines to reduce common LLM coding mistakes. Derived from Andrej Karpathy's observations on LLM coding pitfalls.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

### 1. Think Before Coding
**Don't assume. Don't hide confusion. Surface tradeoffs.**
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

### 2. Simplicity First
**Minimum code that solves the problem. Nothing speculative.**
- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

### 3. Surgical Changes
**Touch only what you must. Clean up only your own mess.**
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.
- Every changed line should trace directly to the user's request.

### 4. Goal-Driven Execution
**Define success criteria. Loop until verified.**
- "Add validation" -> "Write tests for invalid inputs, then make them pass"
- "Fix the bug" -> "Write a test that reproduces it, then make it pass"
- "Refactor X" -> "Ensure tests pass before and after"

For multi-step tasks: 1. [Step] -> verify: [check]  2. [Step] -> verify: [check]

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites, and clarifying questions come before implementation.

---

## Project Overview

**FutKO** (Football Quiz Battle) is a Flutter mobile/web game: real-time 1v1 football trivia, 10 questions × 10s per match, ELO ranking, freemium model. It is a **fork of a geography game ("GeoC" / "GeoQuiz Battle")** rebranded to football — many geo artifacts remain (see Gotchas). UI text and the default locale are **Spanish**.

Stack: Flutter 3.x / Dart 3, Riverpod 2 (code-gen), Firebase (Auth, Firestore, Realtime Database, Storage, Analytics), freezed + json_serializable, go_router, dartz (`Either`), RevenueCat (`purchases_flutter`).

## Commands

```bash
flutter pub get                                          # install deps

# Code generation — REQUIRED after editing any @riverpod / @freezed / @JsonSerializable file.
# Generated *.g.dart and *.freezed.dart are committed to the repo.
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch  --delete-conflicting-outputs  # continuous

flutter gen-l10n            # regenerate localizations (template is lib/l10n/app_es.arb)
flutter analyze            # lint (strict rules in analysis_options.yaml)

flutter run                          # run the app (default lib/main.dart)
flutter run -d chrome                # run on web
flutter run -t lib/main_seed.dart    # SEED questions into Firestore, then run

flutter test                         # run tests (see Gotchas — current tests are broken)
flutter test test/widget_test.dart   # single test file
flutter test --name "<pattern>"      # single test by name

flutter build appbundle --release    # Android release
firebase deploy --only firestore:rules,storage   # deploy security rules
```

## Architecture

Clean Architecture in `lib/`, three layers plus shared `core/` and `services/`:

- **`domain/`** — `entities/` are plain immutable classes using `Equatable` (hand-written, NOT freezed). `repositories/` are abstract interfaces. No Flutter/Firebase imports here.
- **`data/`** — `models/` extend/serialize entities via **freezed + json_serializable**. `repositories/*_impl.dart` implement the domain interfaces and talk to **Firebase directly** (each constructs `FirebaseFirestore.instance` by default, but constructors accept overrides for testing). `datasources/remote/` wrap auth providers (`auth_remote_datasource.dart` for Firebase, `gitea_oauth_datasource.dart` for Gitea).
- **`presentation/`** — `screens/`, `widgets/`, and `providers/` (Riverpod). Repository providers (e.g. `questionRepositoryProvider`) just `return SomethingRepositoryImpl()` — there is no DI container.
- **`core/`** — `constants/` (`GameConstants`, `FirebaseConstants`, `GiteaConstants`), `errors/` (`exceptions.dart` = thrown, `failures.dart` = returned), `theme/`, `utils/` (`elo_calculator`, `score_calculator`, `fuzzy_matcher`, `validators`).
- **`services/`** — cross-cutting: `storage_service`, `revenuecat_service`, `question_seeder_service`.

**Error handling flow:** datasources/Firebase calls **throw** `*Exception` (from `core/errors/exceptions.dart`); repository impls catch them and **return** `Either<Failure, T>` (dartz `Left`/`Right`) using `*Failure` types. Providers/UI consume the `Either` via `.fold(...)`. Never let exceptions escape a repository method.

**State management:** Riverpod with `@riverpod` code-gen. Notifier state is usually a freezed union — e.g. `GameState` in `presentation/providers/game_provider.dart` (`initial` / `loading` / `playing` / `answered` / `finished` / `error`), consumed with `.maybeWhen(...)`. The `GameNotifier` runs the match timer and holds some progression bookkeeping in plain instance fields alongside the immutable state.

**Routing:** `lib/app.dart` defines `routerProvider` (go_router). It watches auth state and redirects unauthenticated users to `/login`. Page transitions come from `FutKOTransitions` in `presentation/widgets/common/futko_page_transitions.dart`.

**Auth is dual-provider:** `AuthRepositoryImpl` merges **Firebase auth** (Google, Apple, Email/Password) and **Gitea OAuth2/OIDC** (`git.futko.app`, contexts web/mobile/cli) into a single combined `Stream<User?>`. Both paths create/update the user document in the Firestore `users` collection on first sign-in.

**Backend / data:** Firestore collections are `users`, `matches`, `questions`, `ghostRuns`, `questionReports`, `quizAttempts` (names in `FirebaseConstants`). Real-time matchmaking uses a **Realtime Database** queue (`matchmaking/queue`). **ELO and matchmaking are computed client-side** — see `core/utils/elo_calculator.dart`; there are no Cloud Functions (see Gotchas). Questions are seeded from `data/questions/football_data.dart` via `question_seeder_service.dart`.

**Game mechanics:** A match pulls 10 random questions. ~30% of eligible questions are converted to free-text "type-answer" mode by stripping their options; typed answers are graded with `fuzzy_matcher.dart` (≥0.85 similarity = correct). Comparison-style question types are excluded from this conversion. Type-answer questions get 15s instead of 10s.

## Gotchas (fork artifacts & stale docs — verify against code, not docs)

- **`functions/` is empty.** `firebase.json` and `README.md` reference Cloud Functions for matchmaking/ELO, but no functions exist. That logic lives client-side. Don't go looking for a backend.
- **`README.md` and `DESIGN.md` are stale (geography era).** README describes the old GeoQuiz game; DESIGN.md describes a light "Explorer's Journal" theme. The **real, current theme is the dark "Stadium Arena" palette in `core/theme/app_colors.dart`** (the app forces `ThemeMode.dark`). **`PROGRESS.md` is the current source of truth** for project status.
- **Leftover geography question types.** `QuestionType` (in `domain/entities/question.dart`) still has `area`, `population`, `border`, `river`, `region`, `lake`, `mountain` alongside the football types; they are still referenced in game logic (`_convertToTypeAnswer`). Don't assume the enum is football-only.
- **`test/widget_test.dart` is the default Flutter counter template** and does not match this app — it will fail if run. There are effectively no working tests and no `integration_test/` directory despite the pubspec dependency.
- **Duplicate localization files.** Stale copies live in `lib/l10n/*.dart`; the app imports the generated ones from **`lib/l10n/generated/`**. `flutter gen-l10n` writes to `generated/`.
- **Firebase project ID is still `geoquiz-7790d`** and the Android `applicationId` is the default `com.example.futko` — neither is production-renamed yet.
- **App is locked to Spanish** (`locale: const Locale('es')` in `app.dart`); the ARB template is `app_es.arb`, not English.