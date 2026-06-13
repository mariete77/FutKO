import 'package:equatable/equatable.dart';
import '../../core/utils/league_system.dart';

/// User entity
class User extends Equatable {
  final String userId;
  final String displayName;
  final String? email;
  final String? photoUrl;

  /// Hidden MMR used for matchmaking and to modulate league points.
  final int elo;

  /// Points within the current league (0–99). Reaching 100 promotes.
  final int leaguePoints;

  /// League tier 1 (Tercera RFEF) .. 5 (Primera División).
  final int leagueTier;
  final UserStats stats;
  final Subscription subscription;
  final DailyGames dailyGames;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final List<String> friends;
  final List<String> pendingFriendRequests;

  const User({
    required this.userId,
    required this.displayName,
    this.email,
    this.photoUrl,
    required this.elo,
    this.leaguePoints = 0,
    this.leagueTier = 2, // Segunda RFEF
    required this.stats,
    required this.subscription,
    required this.dailyGames,
    required this.createdAt,
    this.lastLoginAt,
    this.friends = const [],
    this.pendingFriendRequests = const [],
  });

  /// Create User from Firebase User
  factory User.fromFirebaseUser(dynamic firebaseUser) {
    return User(
      userId: firebaseUser.uid,
      displayName: firebaseUser.displayName ?? 'Player',
      email: firebaseUser.email,
      photoUrl: firebaseUser.photoURL,
      elo: 1000,
      stats: const UserStats(),
      subscription: const Subscription(),
      dailyGames: DailyGames.today(),
      createdAt: DateTime.now(),
      friends: const [],
      pendingFriendRequests: const [],
    );
  }

  /// Create User from Gitea profile
  factory User.fromGiteaProfile(dynamic giteaProfile) {
    return User(
      userId: 'gitea_${giteaProfile.id}',
      displayName: giteaProfile.fullName ?? giteaProfile.login,
      email: giteaProfile.email,
      photoUrl: giteaProfile.avatarUrl,
      elo: 1000,
      stats: const UserStats(),
      subscription: const Subscription(),
      dailyGames: DailyGames.today(),
      createdAt: DateTime.now(),
      friends: const [],
      pendingFriendRequests: const [],
    );
  }

  /// Create a copy with updated fields
  User copyWith({
    String? userId,
    String? displayName,
    String? email,
    String? photoUrl,
    int? elo,
    int? leaguePoints,
    int? leagueTier,
    UserStats? stats,
    Subscription? subscription,
    DailyGames? dailyGames,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    List<String>? friends,
    List<String>? pendingFriendRequests,
  }) {
    return User(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      elo: elo ?? this.elo,
      leaguePoints: leaguePoints ?? this.leaguePoints,
      leagueTier: leagueTier ?? this.leagueTier,
      stats: stats ?? this.stats,
      subscription: subscription ?? this.subscription,
      dailyGames: dailyGames ?? this.dailyGames,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      friends: friends ?? this.friends,
      pendingFriendRequests: pendingFriendRequests ?? this.pendingFriendRequests,
    );
  }

  /// Check if user is premium
  bool get isPremium => subscription.isActive;

  /// League name (derived from [leagueTier]).
  String get rank => LeagueSystem.nameForTier(leagueTier);

  /// Get win rate
  double get winRate {
    if (stats.totalGames == 0) return 0.0;
    return stats.wins / stats.totalGames;
  }

  @override
  List<Object?> get props => [
        userId,
        displayName,
        email,
        photoUrl,
        elo,
        leaguePoints,
        leagueTier,
        stats,
        subscription,
        dailyGames,
        createdAt,
        lastLoginAt,
        friends,
        pendingFriendRequests,
      ];
}

/// User statistics
class UserStats extends Equatable {
  final int totalGames;
  final int wins;
  final int losses;
  final int draws;
  final int totalCorrectAnswers;
  final int currentWinStreak;
  final int bestWinStreak;

  const UserStats({
    this.totalGames = 0,
    this.wins = 0,
    this.losses = 0,
    this.draws = 0,
    this.totalCorrectAnswers = 0,
    this.currentWinStreak = 0,
    this.bestWinStreak = 0,
  });

  /// Create a copy with updated fields
  UserStats copyWith({
    int? totalGames,
    int? wins,
    int? losses,
    int? draws,
    int? totalCorrectAnswers,
    int? currentWinStreak,
    int? bestWinStreak,
  }) {
    return UserStats(
      totalGames: totalGames ?? this.totalGames,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      draws: draws ?? this.draws,
      totalCorrectAnswers: totalCorrectAnswers ?? this.totalCorrectAnswers,
      currentWinStreak: currentWinStreak ?? this.currentWinStreak,
      bestWinStreak: bestWinStreak ?? this.bestWinStreak,
    );
  }

  @override
  List<Object?> get props => [
        totalGames,
        wins,
        losses,
        draws,
        totalCorrectAnswers,
        currentWinStreak,
        bestWinStreak,
      ];
}

/// Subscription info
class Subscription extends Equatable {
  final String type;
  final DateTime? expiresAt;
  final bool isActive;

  const Subscription({
    this.type = 'free',
    this.expiresAt,
    this.isActive = false,
  });

  @override
  List<Object?> get props => [type, expiresAt, isActive];
}

/// Daily games tracking
class DailyGames extends Equatable {
  final int casualPlayed;
  final int rankedPlayed;
  final DateTime date;

  const DailyGames({
    this.casualPlayed = 0,
    this.rankedPlayed = 0,
    required this.date,
  });

  factory DailyGames.today() => DailyGames(
        date: DateTime.now(),
      );

  /// Check if is from today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  List<Object?> get props => [casualPlayed, rankedPlayed, date];
}
