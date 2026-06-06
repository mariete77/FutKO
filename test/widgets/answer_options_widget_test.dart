import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futko/domain/entities/question.dart';
import 'package:futko/presentation/screens/game/widgets/answer_options_widget.dart';

void main() {
  const options = ['Diego Maradona', 'Pelé', 'Zinedine Zidane', 'Ronaldo'];

  const question = Question(
    id: 'p_003',
    type: QuestionType.player,
    difficulty: Difficulty.medium,
    correctAnswer: 'Diego Maradona',
    options: options,
    questionText: '¿Quién marcó el "Gol del Siglo"?',
  );

  Widget wrap({required void Function(String) onSelected}) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: AnswerOptionsWidget(
            question: question,
            onAnswerSelected: onSelected,
          ),
        ),
      ),
    );
  }

  group('AnswerOptionsWidget', () {
    // Regresión: el fork había cambiado el layout a un GridView que renderizaba
    // las opciones vacías (sin texto). Este test fija que el texto SÍ aparece.
    testWidgets('muestra el texto de las 4 opciones', (tester) async {
      await tester.pumpWidget(wrap(onSelected: (_) {}));
      await tester.pumpAndSettle();

      for (final option in options) {
        expect(find.text(option), findsOneWidget);
      }
    });

    testWidgets('cada opción se renderiza con tamaño visible (no colapsada)',
        (tester) async {
      await tester.pumpWidget(wrap(onSelected: (_) {}));
      await tester.pumpAndSettle();

      final size = tester.getSize(find.text(options.first));
      expect(size.width, greaterThan(0));
      expect(size.height, greaterThan(0));
    });

    testWidgets('al tocar una opción llama onAnswerSelected con su valor',
        (tester) async {
      String? selected;
      await tester.pumpWidget(wrap(onSelected: (value) => selected = value));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pelé'));
      expect(selected, 'Pelé');
    });

    testWidgets('descarta opciones vacías', (tester) async {
      const q = Question(
        id: 'x',
        type: QuestionType.team,
        difficulty: Difficulty.easy,
        correctAnswer: 'Real Madrid',
        options: ['Real Madrid', '', 'Barcelona', ''],
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AnswerOptionsWidget(
                question: q,
                onAnswerSelected: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Solo las 2 no vacías deben renderizarse como botones.
      expect(find.byType(InkWell), findsNWidgets(2));
    });
  });
}
