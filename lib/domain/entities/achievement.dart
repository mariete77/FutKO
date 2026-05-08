import 'package:equatable/equatable.dart';

/// Types of achievements
enum AchievementType {
  firstWin,
  streak3,
  streak5,
  streak10,
  perfectGame,
  speedDemon,
  comeback,
  champion,
  legendary,
  collector,
}

/// Lottie animation paths for achievements
class AchievementLottieAnimations {
  static const String trophy = 'assets/lottie/trophy.json';
  static const String fire = 'assets/lottie/fire.json';
  static const String lightning = 'assets/lottie/lightning.json';
  static const String crown = 'assets/lottie/crown.json';
  static const String diamond = 'assets/lottie/diamond.json';
  static const String rocket = 'assets/lottie/rocket.json';
  static const String medal = 'assets/lottie/medal.json';
  static const String star = 'assets/lottie/star.json';
  static const String target = 'assets/lottie/target.json';

  /// Get the appropriate Lottie animation for an achievement type
  static String getAnimationForType(AchievementType type) {
    switch (type) {
      case AchievementType.firstWin:
        return trophy;
      case AchievementType.streak3:
      case AchievementType.streak5:
      case AchievementType.streak10:
        return fire;
      case AchievementType.perfectGame:
        return diamond;
      case AchievementType.speedDemon:
        return lightning;
      case AchievementType.comeback:
        return rocket;
      case AchievementType.champion:
        return medal;
      case AchievementType.legendary:
        return crown;
      case AchievementType.collector:
        return target;
    }
  }
}

/// Achievement entity
class Achievement extends Equatable {
  final String id;
  final AchievementType type;
  final String title;
  final String description;
  final String icon;
  final int points;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int progress;
  final int maxProgress;

  const Achievement({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.points,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress = 0,
    required this.maxProgress,
  });

  Achievement copyWith({
    bool? isUnlocked,
    DateTime? unlockedAt,
    int? progress,
  }) {
    return Achievement(
      id: id,
      type: type,
      title: title,
      description: description,
      icon: icon,
      points: points,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
      maxProgress: maxProgress,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        description,
        icon,
        points,
        isUnlocked,
        unlockedAt,
        progress,
        maxProgress,
      ];
}

/// Default achievements list
final List<Achievement> defaultAchievements = [
  const Achievement(
    id: 'first_win',
    type: AchievementType.firstWin,
    title: 'Primera Victoria',
    description: 'Gana tu primera partida',
    icon: '🏆',
    points: 10,
    maxProgress: 1,
  ),
  const Achievement(
    id: 'streak_3',
    type: AchievementType.streak3,
    title: 'En Racha',
    description: 'Responde 3 preguntas correctas seguidas',
    icon: '🔥',
    points: 25,
    maxProgress: 3,
  ),
  const Achievement(
    id: 'streak_5',
    type: AchievementType.streak5,
    title: 'Imparable',
    description: 'Responde 5 preguntas correctas seguidas',
    icon: '⚡',
    points: 50,
    maxProgress: 5,
  ),
  const Achievement(
    id: 'streak_10',
    type: AchievementType.streak10,
    title: 'Leyenda',
    description: 'Responde 10 preguntas correctas seguidas',
    icon: '👑',
    points: 100,
    maxProgress: 10,
  ),
  const Achievement(
    id: 'perfect_game',
    type: AchievementType.perfectGame,
    title: 'Juego Perfecto',
    description: 'Responde todas las preguntas correctamente',
    icon: '💎',
    points: 150,
    maxProgress: 10,
  ),
  const Achievement(
    id: 'speed_demon',
    type: AchievementType.speedDemon,
    title: 'Velocista',
    description: 'Responde 5 preguntas en menos de 3 segundos cada una',
    icon: '⚡',
    points: 75,
    maxProgress: 5,
  ),
  const Achievement(
    id: 'comeback',
    type: AchievementType.comeback,
    title: 'Remontada',
    description: 'Gana una partida después de ir perdiendo',
    icon: '🚀',
    points: 50,
    maxProgress: 1,
  ),
  const Achievement(
    id: 'champion',
    type: AchievementType.champion,
    title: 'Campeón',
    description: 'Alcanza 1500 de ELO',
    icon: '🥇',
    points: 200,
    maxProgress: 1500,
  ),
  const Achievement(
    id: 'legendary',
    type: AchievementType.legendary,
    title: 'Legendario',
    description: 'Alcanza 2000 de ELO',
    icon: '🌟',
    points: 500,
    maxProgress: 2000,
  ),
  const Achievement(
    id: 'collector',
    type: AchievementType.collector,
    title: 'Coleccionista',
    description: 'Desbloquea 5 logros',
    icon: '🎯',
    points: 100,
    maxProgress: 5,
  ),
];
