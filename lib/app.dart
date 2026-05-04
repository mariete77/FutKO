import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:futko/presentation/screens/splash/splash_screen.dart';
import 'package:futko/presentation/screens/auth/login_screen.dart';
import 'package:futko/presentation/screens/home/home_screen.dart';
import 'package:futko/presentation/screens/game/game_screen.dart';
import 'package:futko/presentation/screens/multiplayer/matchmaking_screen.dart';
import 'package:futko/presentation/screens/multiplayer/multiplayer_game_screen.dart';
import 'package:futko/presentation/screens/home/leaderboard_screen.dart';
import 'package:futko/presentation/screens/history/match_history_screen.dart';
import 'package:futko/presentation/screens/friends/friends_screen.dart';
import 'package:futko/presentation/providers/auth_provider.dart';
import 'package:futko/presentation/providers/multiplayer_provider.dart';
import 'package:futko/domain/entities/question.dart';
import 'package:futko/core/theme/app_theme.dart';
import 'package:futko/presentation/widgets/common/futko_page_transitions.dart';
import 'package:futko/l10n/generated/app_localizations.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authStreamState = ref.watch(authStateChangesProvider);
  final authNotifierState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Check both: direct auth state (from sign-in methods) and stream state (from Firebase)
      final isLoggedIn = authNotifierState.valueOrNull != null ||
          authStreamState.valueOrNull != null;
      final isGoingToLogin = state.matchedLocation == '/login';

      // Redirect to login if not authenticated
      if (!isLoggedIn && !isGoingToLogin && state.matchedLocation != '/') {
        return '/login';
      }

      // Redirect to home if authenticated and trying to access login
      if (isLoggedIn && isGoingToLogin) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => FutKOTransitions.splashPage(
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => FutKOTransitions.enterFadeScale(
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => FutKOTransitions.enterFadeScale(
          duration: const Duration(milliseconds: 450),
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: '/game/:difficulty',
        pageBuilder: (context, state) {
          final difficultyStr = state.pathParameters['difficulty'] ?? 'medium';
          final difficulty = Difficulty.values.firstWhere(
            (d) => d.name.toLowerCase() == difficultyStr.toLowerCase(),
            orElse: () => Difficulty.medium,
          );
          return FutKOTransitions.diagonalFootball(
            child: GameScreen(difficulty: difficulty),
          );
        },
      ),
      GoRoute(
        path: '/matchmaking/:mode',
        pageBuilder: (context, state) {
          final modeStr = state.pathParameters['mode'] ?? 'casual';
          final mode = MultiplayerMode.values.firstWhere(
            (m) => m.name.toLowerCase() == modeStr.toLowerCase(),
            orElse: () => MultiplayerMode.casual,
          );
          return FutKOTransitions.slideInFromBottom(
            child: MatchmakingScreen(mode: mode),
          );
        },
      ),
      GoRoute(
        path: '/leaderboard',
        pageBuilder: (context, state) => FutKOTransitions.slideHorizontal(
          child: const LeaderboardScreen(),
        ),
      ),
      GoRoute(
        path: '/multiplayer-game',
        pageBuilder: (context, state) => FutKOTransitions.slideInFromBottom(
          child: const MultiplayerGameScreen(),
        ),
      ),
      GoRoute(
        path: '/history',
        pageBuilder: (context, state) => FutKOTransitions.slideHorizontal(
          child: const MatchHistoryScreen(),
        ),
      ),
      GoRoute(
        path: '/friends',
        pageBuilder: (context, state) => FutKOTransitions.slideHorizontal(
          child: const FriendsScreen(),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// Main app widget
class FutKOBattleApp extends ConsumerWidget {
  const FutKOBattleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'FutKO Battle',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('es'),
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
    );
  }
}
