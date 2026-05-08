import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/question.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Achievement state
class AchievementsState {
  final List<Achievement> achievements;
  final bool isLoading;
  final String? error;
  final Achievement? lastUnlocked;

  const AchievementsState({
    this.achievements = const [],
    this.isLoading = false,
    this.error,
    this.lastUnlocked,
  });

  AchievementsState copyWith({
    List<Achievement>? achievements,
    bool? isLoading,
    String? error,
    Achievement? lastUnlocked,
  }) {
    return AchievementsState(
      achievements: achievements ?? this.achievements,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastUnlocked: lastUnlocked,
    );
  }

  int get totalPoints =>
      achievements.where((a) => a.isUnlocked).fold(0, (sum, a) => sum + a.points);

  int get unlockedCount =>
      achievements.where((a) => a.isUnlocked).length;
}

/// Achievements notifier
class AchievementsNotifier extends StateNotifier<AchievementsState> {
  AchievementsNotifier() : super(const AchievementsState()) {
    loadAchievements();
  }

  static const _storageKey = 'futko_achievements';

  /// Load achievements from storage
  Future<void> loadAchievements() async {
    state = state.copyWith(isLoading: true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_storageKey);

      if (stored != null) {
        final List<dynamic> decoded = jsonDecode(stored);
        final loadedAchievements = decoded
            .map((data) => Achievement(
                  id: data['id'],
                  type: AchievementType.values.firstWhere(
                    (t) => t.name == data['type'],
                    orElse: () => AchievementType.firstWin,
                  ),
                  title: data['title'],
                  description: data['description'],
                  icon: data['icon'],
                  points: data['points'],
                  isUnlocked: data['isUnlocked'],
                  unlockedAt: data['unlockedAt'] != null
                      ? DateTime.parse(data['unlockedAt'])
                      : null,
                  progress: data['progress'],
                  maxProgress: data['maxProgress'],
                ))
            .toList();
        state = AchievementsState(achievements: loadedAchievements);
      } else {
        state = AchievementsState(achievements: defaultAchievements);
      }
    } catch (e) {
      state = AchievementsState(
        achievements: defaultAchievements,
        error: 'Error loading achievements',
      );
    }
  }

  /// Save achievements to storage
  Future<void> _saveAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final data = state.achievements
        .map((a) => {
              'id': a.id,
              'type': a.type.name,
              'title': a.title,
              'description': a.description,
              'icon': a.icon,
              'points': a.points,
              'isUnlocked': a.isUnlocked,
              'unlockedAt': a.unlockedAt?.toIso8601String(),
              'progress': a.progress,
              'maxProgress': a.maxProgress,
            })
        .toList();
    await prefs.setString(_storageKey, jsonEncode(data));
  }

  /// Check and update achievements after a game
  void checkGameAchievements({
    required int score,
    required int correctAnswers,
    required int totalQuestions,
    required int currentStreak,
    required int maxStreak,
    required int elo,
    required List<Answer> answers,
    required bool won,
  }) {
    final updatedAchievements = <Achievement>[];
    Achievement? newlyUnlocked;

    for (final achievement in state.achievements) {
      Achievement? updated;

      switch (achievement.type) {
        case AchievementType.firstWin:
          if (won && !achievement.isUnlocked) {
            updated = achievement.copyWith(
              isUnlocked: true,
              unlockedAt: DateTime.now(),
              progress: 1,
            );
          }
          break;

        case AchievementType.streak3:
          if (maxStreak >= 3 && !achievement.isUnlocked) {
            updated = achievement.copyWith(
              isUnlocked: true,
              unlockedAt: DateTime.now(),
              progress: maxStreak,
            );
          } else if (maxStreak > achievement.progress) {
            updated = achievement.copyWith(progress: maxStreak.clamp(0, achievement.maxProgress));
          }
          break;

        case AchievementType.streak5:
          if (maxStreak >= 5 && !achievement.isUnlocked) {
            updated = achievement.copyWith(
              isUnlocked: true,
              unlockedAt: DateTime.now(),
              progress: maxStreak,
            );
          } else if (maxStreak > achievement.progress) {
            updated = achievement.copyWith(progress: maxStreak.clamp(0, achievement.maxProgress));
          }
          break;

        case AchievementType.streak10:
          if (maxStreak >= 10 && !achievement.isUnlocked) {
            updated = achievement.copyWith(
              isUnlocked: true,
              unlockedAt: DateTime.now(),
              progress: maxStreak,
            );
          } else if (maxStreak > achievement.progress) {
            updated = achievement.copyWith(progress: maxStreak.clamp(0, achievement.maxProgress));
          }
          break;

        case AchievementType.perfectGame:
          if (correctAnswers == totalQuestions && !achievement.isUnlocked) {
            updated = achievement.copyWith(
              isUnlocked: true,
              unlockedAt: DateTime.now(),
              progress: totalQuestions,
            );
          }
          break;

        case AchievementType.speedDemon:
          final fastAnswers = answers.where((a) => a.timeMs < 3000 && a.isCorrect).length;
          if (fastAnswers >= 5 && !achievement.isUnlocked) {
            updated = achievement.copyWith(
              isUnlocked: true,
              unlockedAt: DateTime.now(),
              progress: fastAnswers,
            );
          } else if (fastAnswers > achievement.progress) {
            updated = achievement.copyWith(progress: fastAnswers.clamp(0, achievement.maxProgress));
          }
          break;

        case AchievementType.champion:
          if (elo >= 1500 && !achievement.isUnlocked) {
            updated = achievement.copyWith(
              isUnlocked: true,
              unlockedAt: DateTime.now(),
              progress: elo,
            );
          } else if (elo > achievement.progress) {
            updated = achievement.copyWith(progress: elo.clamp(0, achievement.maxProgress));
          }
          break;

        case AchievementType.legendary:
          if (elo >= 2000 && !achievement.isUnlocked) {
            updated = achievement.copyWith(
              isUnlocked: true,
              unlockedAt: DateTime.now(),
              progress: elo,
            );
          } else if (elo > achievement.progress) {
            updated = achievement.copyWith(progress: elo.clamp(0, achievement.maxProgress));
          }
          break;

        case AchievementType.collector:
          final unlockedCount = state.achievements.where((a) => a.isUnlocked && a.type != AchievementType.collector).length;
          if (unlockedCount >= 5 && !achievement.isUnlocked) {
            updated = achievement.copyWith(
              isUnlocked: true,
              unlockedAt: DateTime.now(),
              progress: unlockedCount,
            );
          } else {
            updated = achievement.copyWith(progress: unlockedCount.clamp(0, achievement.maxProgress));
          }
          break;

        default:
          break;
      }

      if (updated != null) {
        updatedAchievements.add(updated);
        if (updated.isUnlocked && !achievement.isUnlocked) {
          newlyUnlocked = updated;
        }
      } else {
        updatedAchievements.add(achievement);
      }
    }

    state = state.copyWith(
      achievements: updatedAchievements,
      lastUnlocked: newlyUnlocked,
    );
    _saveAchievements();
  }

  /// Clear last unlocked achievement (after showing)
  void clearLastUnlocked() {
    state = state.copyWith(lastUnlocked: null);
  }

  /// Reset all achievements (for testing)
  Future<void> resetAchievements() async {
    state = const AchievementsState(achievements: defaultAchievements);
    await _saveAchievements();
  }
}

/// Achievements provider
final achievementsProvider =
    StateNotifierProvider<AchievementsNotifier, AchievementsState>((ref) {
  return AchievementsNotifier();
});

/// Provider for total achievement points
final achievementPointsProvider = Provider<int>((ref) {
  return ref.watch(achievementsProvider).totalPoints;
});

/// Provider for unlocked achievements count
final unlockedAchievementsCountProvider = Provider<int>((ref) {
  return ref.watch(achievementsProvider).unlockedCount;
});
