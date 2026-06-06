import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:futko/presentation/screens/auth/login_screen.dart';
import 'package:futko/presentation/providers/auth_provider.dart';
import 'package:futko/domain/entities/user.dart';

void main() {
  setUp(() {
    VideoPlayerPlatform.instance = _FakeVideoPlayerPlatform();
  });

  group('LoginScreen', () {
    Widget buildTestWidget() {
      return ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(() => _MockAuthNotifier()),
          authStateChangesProvider.overrideWith((ref) => const Stream.empty()),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      );
    }

    testWidgets('renders brand title', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('FutKO'), findsOneWidget);
    });

    testWidgets('renders email and password fields', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('renders Kick Off button', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('JUGAR'), findsOneWidget);
    });

    testWidgets('shows sign up toggle', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(RichText), findsWidgets);
    });

    testWidgets('toggles to sign up mode', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final toggleButton = find.byWidgetPredicate(
        (widget) => widget is TextButton && widget.onPressed != null,
      );
      await tester.ensureVisible(toggleButton.first);
      await tester.pumpAndSettle();
      await tester.tap(toggleButton.first);
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsNWidgets(3));
    });

    testWidgets('validates empty email', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('JUGAR'));
      await tester.pumpAndSettle();

      expect(find.text('Introduce tu email'), findsOneWidget);
    });

    testWidgets('validates empty password', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final emailField = find.byType(TextFormField).at(0);
      await tester.enterText(emailField, 'test@test.com');
      await tester.tap(find.text('JUGAR'));
      await tester.pumpAndSettle();

      expect(find.text('Introduce tu contraseña'), findsOneWidget);
    });

    testWidgets('validates short password', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final emailField = find.byType(TextFormField).at(0);
      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(emailField, 'test@test.com');
      await tester.enterText(passwordField, '123');
      await tester.tap(find.text('JUGAR'));
      await tester.pumpAndSettle();

      expect(find.text('Mínimo 6 caracteres'), findsOneWidget);
    });

    testWidgets('renders social login buttons', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('GOOGLE'), findsOneWidget);
      expect(find.text('APPLE ID'), findsOneWidget);
      expect(find.text('GITEA'), findsOneWidget);
    });

    testWidgets('renders pro tip section', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('CONSEJO PRO'), findsOneWidget);
    });
  });
}

class _MockAuthNotifier extends AuthNotifier {
  @override
  AsyncValue<User?> build() => const AsyncValue.data(null);

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signInWithApple() async {}

  @override
  Future<void> signInWithEmail(String email, String password) async {}

  @override
  Future<void> signUpWithEmail(String email, String password, String displayName) async {}

  @override
  Future<void> signInWithGitea(context) async {}

  @override
  Future<void> signOut() async {}
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
