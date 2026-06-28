import 'dart:io';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futko/domain/entities/question.dart';
import 'package:futko/services/question_seeder_service.dart';

/// Coherence review of every generated question + answer.
///
/// Generates the full set many times (to surface random template variants and
/// option shuffles) and FAILS if any question is incoherent. Also dumps a
/// human-readable report to question_review_report.txt.
void main() {
  test('every generated question + answer is coherent', () {
    final service = QuestionSeederService(firestore: FakeFirebaseFirestore());

    final unique = <String, Question>{};
    for (var i = 0; i < 120; i++) {
      for (final q in service.generateAllQuestionsForReview()) {
        final sig =
            '${q.type}|${q.questionText}|${q.imageUrl}|${q.correctAnswer}|${q.options.join(",")}';
        unique.putIfAbsent(sig, () => q);
      }
    }
    final questions = unique.values.toList();

    // Same key as the seeder: image questions are disambiguated by the image.
    String key(Question q) =>
        '${q.type}|${(q.imageUrl ?? q.questionText ?? '').toLowerCase().trim()}';

    final validAnswersByKey = <String, Set<String>>{};
    for (final q in questions) {
      validAnswersByKey
          .putIfAbsent(key(q), () => <String>{})
          .add(q.correctAnswer.toLowerCase().trim());
    }

    final taAmbiguous = <String>[]; // type-answer with >1 valid answer
    final taLeak = <String>[]; // type-answer answer spelled in prompt
    final mcMultiCorrect = <String>[]; // MC with >1 option being valid
    final mcBad = <String>[]; // MC missing correct / dup / too few
    final semanticTA = <String>[]; // type-answer that's semantically ambiguous

    // Tipos que NUNCA deben ser de escribir: nombrar a una persona desde una
    // descripción de texto es ambiguo aunque el enunciado sea único en la BD.
    const neverTypeAnswer = {QuestionType.player};

    for (final q in questions) {
      final valid = validAnswersByKey[key(q)]!;
      final isTypeAnswer = q.options.isEmpty;

      if (isTypeAnswer) {
        if (neverTypeAnswer.contains(q.type)) {
          semanticTA.add('[${q.type.name}] ${q.questionText} (ans=${q.correctAnswer})');
        }
        if (valid.length > 1) {
          taAmbiguous.add('[${q.type.name}] ${q.questionText} -> ${valid.join(" | ")}');
        }
        if (q.questionText != null) {
          final ans = q.correctAnswer.toLowerCase().trim();
          if (ans.length > 2 && q.questionText!.toLowerCase().contains(ans)) {
            taLeak.add('[${q.type.name}] ans="${q.correctAnswer}" :: ${q.questionText}');
          }
        }
      } else {
        final lowered = q.options.map((o) => o.toLowerCase().trim()).toList();
        final correctCount = lowered.where(valid.contains).length;
        if (correctCount != 1) {
          mcMultiCorrect.add('[${q.type.name}] correct=$correctCount ${q.questionText ?? q.imageUrl} opts=${q.options}');
        }
        if (!lowered.contains(q.correctAnswer.toLowerCase().trim())) {
          mcBad.add('NO-CORRECT [${q.type.name}] ${q.questionText} ans=${q.correctAnswer} opts=${q.options}');
        } else if (lowered.toSet().length != lowered.length) {
          mcBad.add('DUP [${q.type.name}] ${q.questionText} opts=${q.options}');
        } else if (q.options.length < 3) {
          mcBad.add('FEW(${q.options.length}) [${q.type.name}] ${q.questionText} opts=${q.options}');
        }
      }
    }

    final buf = StringBuffer()
      ..writeln('TOTAL preguntas únicas: ${questions.length}')
      ..writeln('\n=== ESCRIBIR AMBIGUO (${taAmbiguous.length}) ===')
      ..writeAll(taAmbiguous.map((e) => '$e\n'))
      ..writeln('\n=== ESCRIBIR FILTRADO (${taLeak.length}) ===')
      ..writeAll(taLeak.map((e) => '$e\n'))
      ..writeln('\n=== MC CON VARIOS CORRECTOS (${mcMultiCorrect.length}) ===')
      ..writeAll(mcMultiCorrect.map((e) => '$e\n'))
      ..writeln('\n=== MC OPCIONES INVÁLIDAS (${mcBad.length}) ===')
      ..writeAll(mcBad.map((e) => '$e\n'))
      ..writeln('\n=== ESCRIBIR SEMÁNTICAMENTE AMBIGUO (${semanticTA.length}) ===')
      ..writeAll(semanticTA.map((e) => '$e\n'));
    File('question_review_report.txt').writeAsStringSync(buf.toString());

    expect(semanticTA, isEmpty,
        reason: 'tipos que no deben ser de escribir (jugador por descripción)');
    expect(taAmbiguous, isEmpty, reason: 'preguntas de escribir con respuesta ambigua');
    expect(taLeak, isEmpty, reason: 'preguntas de escribir que filtran la respuesta');
    expect(mcMultiCorrect, isEmpty, reason: 'preguntas MC con más de una opción correcta');
    expect(mcBad, isEmpty, reason: 'preguntas MC con opciones inválidas');
  });
}
