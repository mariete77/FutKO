// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String?,
      photoUrl: json['photoUrl'] as String?,
      elo: (json['elo'] as num?)?.toInt() ?? 1000,
      stats: json['stats'] == null
          ? const UserStatsModel()
          : UserStatsModel.fromJson(json['stats'] as Map<String, dynamic>),
      subscription: json['subscription'] == null
          ? const SubscriptionModel()
          : SubscriptionModel.fromJson(
              json['subscription'] as Map<String, dynamic>),
      dailyGames: json['dailyGames'] == null
          ? const DailyGamesModel()
          : DailyGamesModel.fromJson(
              json['dailyGames'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
      friends: (json['friends'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      pendingFriendRequests: (json['pendingFriendRequests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'email': instance.email,
      'photoUrl': instance.photoUrl,
      'elo': instance.elo,
      'stats': instance.stats,
      'subscription': instance.subscription,
      'dailyGames': instance.dailyGames,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'friends': instance.friends,
      'pendingFriendRequests': instance.pendingFriendRequests,
    };

_$UserStatsModelImpl _$$UserStatsModelImplFromJson(Map<String, dynamic> json) =>
    _$UserStatsModelImpl(
      totalGames: (json['totalGames'] as num?)?.toInt() ?? 0,
      wins: (json['wins'] as num?)?.toInt() ?? 0,
      losses: (json['losses'] as num?)?.toInt() ?? 0,
      draws: (json['draws'] as num?)?.toInt() ?? 0,
      totalCorrectAnswers: (json['totalCorrectAnswers'] as num?)?.toInt() ?? 0,
      currentWinStreak: (json['currentWinStreak'] as num?)?.toInt() ?? 0,
      bestWinStreak: (json['bestWinStreak'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserStatsModelImplToJson(
        _$UserStatsModelImpl instance) =>
    <String, dynamic>{
      'totalGames': instance.totalGames,
      'wins': instance.wins,
      'losses': instance.losses,
      'draws': instance.draws,
      'totalCorrectAnswers': instance.totalCorrectAnswers,
      'currentWinStreak': instance.currentWinStreak,
      'bestWinStreak': instance.bestWinStreak,
    };

_$SubscriptionModelImpl _$$SubscriptionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SubscriptionModelImpl(
      type: json['type'] as String? ?? 'free',
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      isActive: json['isActive'] as bool? ?? false,
    );

Map<String, dynamic> _$$SubscriptionModelImplToJson(
        _$SubscriptionModelImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'isActive': instance.isActive,
    };

_$DailyGamesModelImpl _$$DailyGamesModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DailyGamesModelImpl(
      casualPlayed: (json['casualPlayed'] as num?)?.toInt() ?? 0,
      rankedPlayed: (json['rankedPlayed'] as num?)?.toInt() ?? 0,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$DailyGamesModelImplToJson(
        _$DailyGamesModelImpl instance) =>
    <String, dynamic>{
      'casualPlayed': instance.casualPlayed,
      'rankedPlayed': instance.rankedPlayed,
      'date': instance.date?.toIso8601String(),
    };
