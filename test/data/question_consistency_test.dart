import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futko/data/questions/awards_data.dart';
import 'package:futko/data/questions/football_data.dart';
import 'package:futko/domain/entities/question.dart';
import 'package:futko/services/question_seeder_service.dart';

void main() {
  late QuestionSeederService service;

  setUp(() {
    service = QuestionSeederService(firestore: FakeFirebaseFirestore());
  });

  group('award options', () {
    test('Balón de Oro distractors stay in the same era', () {
      final questions = service.generateAllQuestionsForReview();
      final awardQuestions = questions.where((q) => q.type == QuestionType.award);

      expect(awardQuestions, isNotEmpty, reason: 'no award questions generated');

      final winnersByYear = <int, String>{
        for (final e in AwardsData.ballonDor) e.year: e.winner,
      };

      var checked = 0;
      for (final q in awardQuestions) {
        final year = q.extraData?['year'] as int?;
        if (year == null || !winnersByYear.containsKey(year)) continue;

        checked++;
          // Distractors should be other Ballon d'Or winners from nearby years.
          for (final opt in q.options) {
            if (opt == q.correctAnswer) continue;
            final optYear = winnersByYear.entries
                .firstWhere((e) => e.value == opt, orElse: () => const MapEntry(0, ''))
                .key;
            expect(optYear, isNonZero,
                reason: '$opt is not a Ballon d\'Or winner');
            expect((optYear - year).abs(), lessThanOrEqualTo(18),
                reason: '$opt ($optYear) is too far from $year');
          }
      }

      expect(checked, greaterThan(0),
          reason: 'no Ballon d\'Or questions were checked');
    });
  });

  group('player options', () {
    test('distractors share position and era when question asks for them', () {
      final questions = service.generateAllQuestionsForReview();
      final playerQuestions = questions.where(
        (q) =>
            q.type == QuestionType.player &&
            q.questionText!.toLowerCase().contains('juega como'),
      );

      expect(playerQuestions, isNotEmpty,
          reason: 'no player questions generated');

      final playersByName = <String, (int? birthYear, String position)>{
        for (final p in FootballData.players) p.name: (p.birthYear, p.position)
      };

      var checked = 0;
      for (final q in playerQuestions) {
        final correct = playersByName[q.correctAnswer];
        if (correct == null) continue;
        checked++;

        for (final opt in q.options) {
          if (opt == q.correctAnswer) continue;
          final distractor = playersByName[opt];
          expect(distractor, isNotNull, reason: '$opt is not a known player');
          // Position must match.
          expect(distractor!.$2, equals(correct.$2),
              reason: '$opt has a different position than the correct answer');
          // Birth year should be within a reasonable window. Older players
          // have fewer peers in the dataset, so we allow a wider range.
          if (correct.$1 != null && distractor.$1 != null) {
            final maxDelta = correct.$1! >= 1950 ? 20 : 60;
            expect((distractor.$1! - correct.$1!).abs(),
                lessThanOrEqualTo(maxDelta),
                reason: '$opt is from a different era');
          }
        }
      }

      expect(checked, greaterThan(0),
          reason: 'no player questions were checked');
    });
  });

  group('team options', () {
    test('distractors are from the same country', () {
      final questions = service.generateAllQuestionsForReview();
      final teamQuestions = questions.where((q) => q.type == QuestionType.team);

      expect(teamQuestions, isNotEmpty, reason: 'no team questions generated');

      final countries = <String, String>{
        for (final t in FootballData.teams) t.name: t.country
      };

      var checked = 0;
      for (final q in teamQuestions) {
        final correctCountry = countries[q.correctAnswer];
        if (correctCountry == null) continue;
        checked++;

        for (final opt in q.options) {
          if (opt == q.correctAnswer) continue;
          expect(countries[opt], equals(correctCountry),
              reason: '$opt is not from $correctCountry');
        }
      }

      expect(checked, greaterThan(0),
          reason: 'no team questions were checked');
    });
  });

  group('competition options', () {
    test('distractors share the competition type', () {
      final questions = service.generateAllQuestionsForReview();
      final compQuestions =
          questions.where((q) => q.type == QuestionType.competition);

      expect(compQuestions, isNotEmpty,
          reason: 'no competition questions generated');

      final types = <String, String>{
        for (final c in FootballData.competitions) c.name: c.type
      };

      var checked = 0;
      for (final q in compQuestions) {
        final correctType = types[q.correctAnswer];
        if (correctType == null) continue;
        checked++;

        for (final opt in q.options) {
          if (opt == q.correctAnswer) continue;
          expect(types[opt], equals(correctType),
              reason: '$opt is not a $correctType competition');
        }
      }

      expect(checked, greaterThan(0),
          reason: 'no competition questions were checked');
    });
  });

  group('statistic options', () {
    test('distractors share the subject category', () {
      final questions = service.generateAllQuestionsForReview();
      final statQuestions =
          questions.where((q) => q.type == QuestionType.statistic);

      expect(statQuestions, isNotEmpty,
          reason: 'no statistic questions generated');

      final categoriesBySubject = <String, Set<String>>{};
      for (final s in FootballData.statistics) {
        categoriesBySubject.putIfAbsent(s.subject, () => {}).add(s.category);
      }

      var checked = 0;
      for (final q in statQuestions) {
        final correctCategory = q.extraData?['category'] as String?;
        if (correctCategory == null) continue;
        checked++;

        for (final opt in q.options) {
          if (opt == q.correctAnswer) continue;
          final optCategories = categoriesBySubject[opt] ?? {};
          expect(optCategories, contains(correctCategory),
              reason: '$opt has no record in category $correctCategory');
        }
      }

      expect(checked, greaterThan(0),
          reason: 'no statistic questions were checked');
    });
  });

  group('transfer options', () {
    test('distractors are from the same transfer era', () {
      final questions = service.generateAllQuestionsForReview();
      final transferQuestions =
          questions.where((q) => q.type == QuestionType.transfer);

      expect(transferQuestions, isNotEmpty,
          reason: 'no transfer questions generated');

      final transfersByPlayer = <String, List<int>>{};
      for (final t in FootballData.transfers) {
        transfersByPlayer.putIfAbsent(t.player, () => []).add(t.year);
      }

      var checked = 0;
      for (final q in transferQuestions) {
        final correctYear = q.extraData?['transferYear'] as int?;
        if (correctYear == null) continue;
        checked++;

        for (final opt in q.options) {
          if (opt == q.correctAnswer) continue;
          final optYears = transfersByPlayer[opt];
          if (optYears == null || optYears.isEmpty) continue;
          final closest = optYears.reduce((a, b) =>
              (a - correctYear).abs() <= (b - correctYear).abs() ? a : b);
          if ((closest - correctYear).abs() > 10) {
            print('FAIL TRANSFER: ${q.questionText} correct=${q.correctAnswer} ($correctYear) options=${q.options} extra=${q.extraData}');
          }
          expect((closest - correctYear).abs(), lessThanOrEqualTo(10),
              reason: '$opt ($closest) is too far from $correctYear');
        }
      }

      expect(checked, greaterThan(0),
          reason: 'no transfer questions were checked');
    });
  });
}
