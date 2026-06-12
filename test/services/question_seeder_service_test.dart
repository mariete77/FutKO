import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futko/core/constants/firebase_constants.dart';
import 'package:futko/services/question_seeder_service.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late QuestionSeederService seeder;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    seeder = QuestionSeederService(firestore: firestore);
  });

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchAll() async {
    final snap =
        await firestore.collection(FirebaseConstants.questions).get();
    return snap.docs;
  }

  test('seeds questions into the collection', () async {
    final count = await seeder.seedQuestions();
    final docs = await fetchAll();

    expect(count, greaterThan(500),
        reason: 'must exceed the 500-op batch limit (exercises chunking)');
    expect(docs.length, count, reason: 'doc count must match returned count');
  });

  test('re-seeding is idempotent (wipes before writing, no duplicates)',
      () async {
    final first = await seeder.seedQuestions();
    final second = await seeder.seedQuestions();
    final docs = await fetchAll();

    expect(docs.length, second,
        reason: 'second seed must replace, not append');
    // Counts vary slightly run-to-run (some generators are randomized), but
    // the collection size must equal the latest run, never first + second.
    expect(docs.length, lessThan(first + second));
  });

  test('champion and topScorer categories are present', () async {
    await seeder.seedQuestions();
    final docs = await fetchAll();
    final types = docs.map((d) => d[FirebaseConstants.questionType]).toSet();

    expect(types, contains('champion'));
    expect(types, contains('topScorer'));
  });

  test('every multiple-choice question is well-formed', () async {
    await seeder.seedQuestions();
    final docs = await fetchAll();

    for (final d in docs) {
      final data = d.data();
      final answer = data[FirebaseConstants.correctAnswer] as String;
      final options =
          (data[FirebaseConstants.options] as List).cast<String>();

      expect(answer.trim(), isNotEmpty,
          reason: 'no question may have an empty answer');

      // Questions are seeded either with no options (type-answer, enriched at
      // play time) or with a full set of 4 distinct options.
      if (options.isNotEmpty) {
        expect(options.length, 4,
            reason: 'multiple-choice options must be exactly 4: $data');
        expect(options.toSet().length, options.length,
            reason: 'options must be distinct: $data');
        expect(options, contains(answer),
            reason: 'the correct answer must be among the options: $data');
      }
    }
  });
}
