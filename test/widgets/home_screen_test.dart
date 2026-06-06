import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:futko/presentation/screens/home/home_screen.dart';
import 'package:futko/presentation/providers/auth_provider.dart';
import 'package:futko/presentation/providers/user_provider.dart';
import 'package:futko/presentation/providers/elo_history_provider.dart';
import 'package:futko/presentation/providers/match_history_provider.dart';
import 'package:futko/presentation/providers/active_players_provider.dart';
import 'package:futko/domain/entities/user.dart';
import 'package:futko/domain/entities/match.dart';
import 'package:futko/domain/repositories/match_repository.dart';
import 'package:futko/core/errors/failures.dart';

void main() {
  setUp(() {
    VideoPlayerPlatform.instance = _FakeVideoPlayerPlatform();
  });

  final testUser = User(
    userId: 'test-user-id',
    displayName: 'Test Player',
    email: 'test@example.com',
    elo: 1200,
    stats: const UserStats(totalGames: 10, wins: 6, losses: 4),
    subscription: const Subscription(),
    dailyGames: DailyGames.today(),
    createdAt: DateTime.now(),
  );

  Widget buildTestWidget() {
    return ProviderScope(
      overrides: [
        currentUserProvider.overrideWithValue(testUser),
        userNotifierProvider.overrideWith(() => _MockUserNotifier(testUser)),
        dailyGamesStatusProvider.overrideWithValue(
          const DailyGamesStatus(
            casualRemaining: 1,
            rankedRemaining: 1,
            canPlayCasual: true,
            canPlayRanked: true,
          ),
        ),
        eloHistoryProvider.overrideWithValue(
          const EloHistoryState(
            eloValues: [1000, 1050, 1100, 1150, 1200],
            currentElo: 1200,
            eloDelta: 50,
          ),
        ),
        matchHistoryProvider.overrideWith((ref) => MatchHistoryNotifier(_FakeMatchRepository(), 'test-user-id')),
        presenceServiceProvider.overrideWithValue(_MockPresenceService()),
        activePlayersProvider.overrideWith((ref) => const Stream.empty()),
      ],
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }

  group('HomeScreen', () {
    testWidgets('renders user display name', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Test Player'), findsOneWidget);
    });

    testWidgets('renders game modes section', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('SECCIONES'), findsOneWidget);
      expect(find.text('Partida Rápida'), findsOneWidget);
      expect(find.text('Clasificatoria'), findsOneWidget);
      expect(find.text('Entrenamiento'), findsOneWidget);
    });

    testWidgets('renders ELO display', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('1200'), findsWidgets);
    });

    testWidgets('shows loading indicator when user is null', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWithValue(null),
            userNotifierProvider.overrideWith(() => _MockUserNotifier(null)),
            presenceServiceProvider.overrideWithValue(_MockPresenceService()),
            activePlayersProvider.overrideWith((ref) => Stream.value(0)),
            matchHistoryProvider.overrideWith((ref) => MatchHistoryNotifier(_FakeMatchRepository(), null)),
            eloHistoryProvider.overrideWithValue(const EloHistoryState()),
            dailyGamesStatusProvider.overrideWithValue(DailyGamesStatus.unknown()),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}

class _MockUserNotifier extends UserNotifier {
  final User? _user;
  _MockUserNotifier(this._user);

  @override
  AsyncValue<User?> build() => AsyncValue.data(_user);

  @override
  Future<void> getUserProfile(String userId) async {}
}

class _FakeMatchRepository implements MatchRepository {
  @override
  Future<Either<Failure, List<GameMatch>>> getUserMatches(String userId, {int limit = 50, MatchStatus? status}) async {
    return const Right([]);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockPresenceService extends PresenceService {
  @override
  void startPresenceUpdates() {}

  @override
  void stopPresenceUpdates() {}
}

class _FakeVideoPlayerPlatform extends VideoPlayerPlatform {
  @override
  Future<void> init() async {}

  @override
  Future<void> dispose(int textureId) async {}

  @override
  Future<int> create(DataSource dataSource) async => 0;

  @override
  Future<void> setLooping(int textureId, bool looping) async {}

  @override
  Future<void> play(int textureId) async {}

  @override
  Future<void> pause(int textureId) async {}

  @override
  Future<void> setVolume(int textureId, double volume) async {}

  @override
  Future<void> setPlaybackSpeed(int textureId, double speed) async {}

  @override
  Future<void> seekTo(int textureId, Duration position) async {}

  @override
  Future<Duration> getPosition(int textureId) async => Duration.zero;

  @override
  Stream<VideoEvent> videoEventsFor(int textureId) => const Stream.empty();

  @override
  Widget buildView(int textureId) => const SizedBox.shrink();

  @override
  Future<VideoPlayerValue> getVideoValue(int textureId) async {
    return VideoPlayerValue(duration: Duration.zero, size: Size.zero);
  }
}
