import 'dart:convert';
import 'dart:io';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futko/services/question_seeder_service.dart';

/// Not a real test — a generator. Run with:
///   flutter test test/question_export_test.dart
/// Writes the exact (coherent) question set to scripts/questions_seed.json so
/// it can be uploaded to Firestore by an admin/REST script.
void main() {
  test('export generated questions to JSON', () {
    final service = QuestionSeederService(firestore: FakeFirebaseFirestore());
    final questions = service.generateAllQuestionsForReview();

    final list = questions
        .map((q) => {
              'type': q.type.name,
              'difficulty': q.difficulty.name,
              'correctAnswer': q.correctAnswer,
              'options': q.options,
              if (q.questionText != null) 'questionText': q.questionText,
              if (q.imageUrl != null) 'imageUrl': q.imageUrl,
              if (q.extraData != null) 'extraData': q.extraData,
            })
        .toList();

    final file = File('scripts/questions_seed.json');
    file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(list));
    // ignore: avoid_print
    print('EXPORTADAS=${list.length} -> ${file.path}');
  });
}
