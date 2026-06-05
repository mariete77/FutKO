import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:futko/main.dart' as app;
import 'firebase_emulators.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Flujo completo de la app', () {
    setUpAll(() async {
      await initializeFirebaseEmulators();
      await clearEmulatorData();
      await createTestUser();
      await seedTestQuestions();
    });

    testWidgets('Splash → Login → Home → Partida → Resultado', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 1. Verificar que aparece Login
      expect(find.text('Iniciar Sesión'), findsOneWidget);

      // 2. Ingresar credenciales
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@futko.app',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'test1234',
      );
      await tester.pumpAndSettle();

      // 3. Presionar botón de login
      await tester.tap(find.text('Iniciar Sesión'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 4. Verificar que estamos en Home
      expect(find.textContaining('ELO'), findsOneWidget);

      // 5. Iniciar partida rápida
      await tester.tap(find.text('Partida Rápida'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 6. Verificar que aparece la primera pregunta
      expect(find.byType(Card), findsWidgets);
      expect(find.textContaining('?'), findsWidgets);

      // 7. Responder primera pregunta (seleccionar primera opción)
      final firstOption = find.byType(ElevatedButton).first;
      if (firstOption.evaluate().isNotEmpty) {
        await tester.tap(firstOption);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      // 8. Continuar respondiendo hasta el final (máximo 10 preguntas)
      for (int i = 0; i < 9; i++) {
        await tester.pumpAndSettle(const Duration(seconds: 1));
        final option = find.byType(ElevatedButton).first;
        if (option.evaluate().isNotEmpty) {
          await tester.tap(option);
          await tester.pumpAndSettle(const Duration(seconds: 2));
        }
      }

      // 9. Verificar pantalla de resultados
      await tester.pumpAndSettle(const Duration(seconds: 3));
      final hasResultado = find.textContaining('Resultado').evaluate().isNotEmpty;
      final hasPuntuacion = find.textContaining('Puntuación').evaluate().isNotEmpty;
      expect(hasResultado || hasPuntuacion, true);

      // 10. Volver a Home
      final backButton = find.byIcon(Icons.arrow_back);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
        await tester.pumpAndSettle();
      }

      expect(find.textContaining('ELO'), findsOneWidget);
    }, timeout: const Timeout(Duration(minutes: 2)));
  });
}
