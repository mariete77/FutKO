// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get userId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  int get elo => throw _privateConstructorUsedError;
  UserStatsModel get stats => throw _privateConstructorUsedError;
  SubscriptionModel get subscription => throw _privateConstructorUsedError;
  DailyGamesModel get dailyGames => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;
  List<String> get friends => throw _privateConstructorUsedError;
  List<String> get pendingFriendRequests => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String userId,
      String displayName,
      String? email,
      String? photoUrl,
      int elo,
      UserStatsModel stats,
      SubscriptionModel subscription,
      DailyGamesModel dailyGames,
      DateTime createdAt,
      DateTime? lastLoginAt,
      List<String> friends,
      List<String> pendingFriendRequests});

  $UserStatsModelCopyWith<$Res> get stats;
  $SubscriptionModelCopyWith<$Res> get subscription;
  $DailyGamesModelCopyWith<$Res> get dailyGames;
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? email = freezed,
    Object? photoUrl = freezed,
    Object? elo = null,
    Object? stats = null,
    Object? subscription = null,
    Object? dailyGames = null,
    Object? createdAt = null,
    Object? lastLoginAt = freezed,
    Object? friends = null,
    Object? pendingFriendRequests = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      elo: null == elo
          ? _value.elo
          : elo // ignore: cast_nullable_to_non_nullable
              as int,
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as UserStatsModel,
      subscription: null == subscription
          ? _value.subscription
          : subscription // ignore: cast_nullable_to_non_nullable
              as SubscriptionModel,
      dailyGames: null == dailyGames
          ? _value.dailyGames
          : dailyGames // ignore: cast_nullable_to_non_nullable
              as DailyGamesModel,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      friends: null == friends
          ? _value.friends
          : friends // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pendingFriendRequests: null == pendingFriendRequests
          ? _value.pendingFriendRequests
          : pendingFriendRequests // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserStatsModelCopyWith<$Res> get stats {
    return $UserStatsModelCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SubscriptionModelCopyWith<$Res> get subscription {
    return $SubscriptionModelCopyWith<$Res>(_value.subscription, (value) {
      return _then(_value.copyWith(subscription: value) as $Val);
    });
  }

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DailyGamesModelCopyWith<$Res> get dailyGames {
    return $DailyGamesModelCopyWith<$Res>(_value.dailyGames, (value) {
      return _then(_value.copyWith(dailyGames: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String displayName,
      String? email,
      String? photoUrl,
      int elo,
      UserStatsModel stats,
      SubscriptionModel subscription,
      DailyGamesModel dailyGames,
      DateTime createdAt,
      DateTime? lastLoginAt,
      List<String> friends,
      List<String> pendingFriendRequests});

  @override
  $UserStatsModelCopyWith<$Res> get stats;
  @override
  $SubscriptionModelCopyWith<$Res> get subscription;
  @override
  $DailyGamesModelCopyWith<$Res> get dailyGames;
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? email = freezed,
    Object? photoUrl = freezed,
    Object? elo = null,
    Object? stats = null,
    Object? subscription = null,
    Object? dailyGames = null,
    Object? createdAt = null,
    Object? lastLoginAt = freezed,
    Object? friends = null,
    Object? pendingFriendRequests = null,
  }) {
    return _then(_$UserModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      elo: null == elo
          ? _value.elo
          : elo // ignore: cast_nullable_to_non_nullable
              as int,
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as UserStatsModel,
      subscription: null == subscription
          ? _value.subscription
          : subscription // ignore: cast_nullable_to_non_nullable
              as SubscriptionModel,
      dailyGames: null == dailyGames
          ? _value.dailyGames
          : dailyGames // ignore: cast_nullable_to_non_nullable
              as DailyGamesModel,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      friends: null == friends
          ? _value._friends
          : friends // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pendingFriendRequests: null == pendingFriendRequests
          ? _value._pendingFriendRequests
          : pendingFriendRequests // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl extends _UserModel {
  const _$UserModelImpl(
      {required this.userId,
      required this.displayName,
      this.email,
      this.photoUrl,
      this.elo = 1000,
      this.stats = const UserStatsModel(),
      this.subscription = const SubscriptionModel(),
      this.dailyGames = const DailyGamesModel(),
      required this.createdAt,
      this.lastLoginAt,
      final List<String> friends = const [],
      final List<String> pendingFriendRequests = const []})
      : _friends = friends,
        _pendingFriendRequests = pendingFriendRequests,
        super._();

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String userId;
  @override
  final String displayName;
  @override
  final String? email;
  @override
  final String? photoUrl;
  @override
  @JsonKey()
  final int elo;
  @override
  @JsonKey()
  final UserStatsModel stats;
  @override
  @JsonKey()
  final SubscriptionModel subscription;
  @override
  @JsonKey()
  final DailyGamesModel dailyGames;
  @override
  final DateTime createdAt;
  @override
  final DateTime? lastLoginAt;
  final List<String> _friends;
  @override
  @JsonKey()
  List<String> get friends {
    if (_friends is EqualUnmodifiableListView) return _friends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_friends);
  }

  final List<String> _pendingFriendRequests;
  @override
  @JsonKey()
  List<String> get pendingFriendRequests {
    if (_pendingFriendRequests is EqualUnmodifiableListView)
      return _pendingFriendRequests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pendingFriendRequests);
  }

  @override
  String toString() {
    return 'UserModel(userId: $userId, displayName: $displayName, email: $email, photoUrl: $photoUrl, elo: $elo, stats: $stats, subscription: $subscription, dailyGames: $dailyGames, createdAt: $createdAt, lastLoginAt: $lastLoginAt, friends: $friends, pendingFriendRequests: $pendingFriendRequests)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.elo, elo) || other.elo == elo) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.subscription, subscription) ||
                other.subscription == subscription) &&
            (identical(other.dailyGames, dailyGames) ||
                other.dailyGames == dailyGames) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt) &&
            const DeepCollectionEquality().equals(other._friends, _friends) &&
            const DeepCollectionEquality()
                .equals(other._pendingFriendRequests, _pendingFriendRequests));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      displayName,
      email,
      photoUrl,
      elo,
      stats,
      subscription,
      dailyGames,
      createdAt,
      lastLoginAt,
      const DeepCollectionEquality().hash(_friends),
      const DeepCollectionEquality().hash(_pendingFriendRequests));

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel extends UserModel {
  const factory _UserModel(
      {required final String userId,
      required final String displayName,
      final String? email,
      final String? photoUrl,
      final int elo,
      final UserStatsModel stats,
      final SubscriptionModel subscription,
      final DailyGamesModel dailyGames,
      required final DateTime createdAt,
      final DateTime? lastLoginAt,
      final List<String> friends,
      final List<String> pendingFriendRequests}) = _$UserModelImpl;
  const _UserModel._() : super._();

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get userId;
  @override
  String get displayName;
  @override
  String? get email;
  @override
  String? get photoUrl;
  @override
  int get elo;
  @override
  UserStatsModel get stats;
  @override
  SubscriptionModel get subscription;
  @override
  DailyGamesModel get dailyGames;
  @override
  DateTime get createdAt;
  @override
  DateTime? get lastLoginAt;
  @override
  List<String> get friends;
  @override
  List<String> get pendingFriendRequests;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserStatsModel _$UserStatsModelFromJson(Map<String, dynamic> json) {
  return _UserStatsModel.fromJson(json);
}

/// @nodoc
mixin _$UserStatsModel {
  int get totalGames => throw _privateConstructorUsedError;
  int get wins => throw _privateConstructorUsedError;
  int get losses => throw _privateConstructorUsedError;
  int get draws => throw _privateConstructorUsedError;
  int get totalCorrectAnswers => throw _privateConstructorUsedError;
  int get currentWinStreak => throw _privateConstructorUsedError;
  int get bestWinStreak => throw _privateConstructorUsedError;

  /// Serializes this UserStatsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserStatsModelCopyWith<UserStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatsModelCopyWith<$Res> {
  factory $UserStatsModelCopyWith(
          UserStatsModel value, $Res Function(UserStatsModel) then) =
      _$UserStatsModelCopyWithImpl<$Res, UserStatsModel>;
  @useResult
  $Res call(
      {int totalGames,
      int wins,
      int losses,
      int draws,
      int totalCorrectAnswers,
      int currentWinStreak,
      int bestWinStreak});
}

/// @nodoc
class _$UserStatsModelCopyWithImpl<$Res, $Val extends UserStatsModel>
    implements $UserStatsModelCopyWith<$Res> {
  _$UserStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalGames = null,
    Object? wins = null,
    Object? losses = null,
    Object? draws = null,
    Object? totalCorrectAnswers = null,
    Object? currentWinStreak = null,
    Object? bestWinStreak = null,
  }) {
    return _then(_value.copyWith(
      totalGames: null == totalGames
          ? _value.totalGames
          : totalGames // ignore: cast_nullable_to_non_nullable
              as int,
      wins: null == wins
          ? _value.wins
          : wins // ignore: cast_nullable_to_non_nullable
              as int,
      losses: null == losses
          ? _value.losses
          : losses // ignore: cast_nullable_to_non_nullable
              as int,
      draws: null == draws
          ? _value.draws
          : draws // ignore: cast_nullable_to_non_nullable
              as int,
      totalCorrectAnswers: null == totalCorrectAnswers
          ? _value.totalCorrectAnswers
          : totalCorrectAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      currentWinStreak: null == currentWinStreak
          ? _value.currentWinStreak
          : currentWinStreak // ignore: cast_nullable_to_non_nullable
              as int,
      bestWinStreak: null == bestWinStreak
          ? _value.bestWinStreak
          : bestWinStreak // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserStatsModelImplCopyWith<$Res>
    implements $UserStatsModelCopyWith<$Res> {
  factory _$$UserStatsModelImplCopyWith(_$UserStatsModelImpl value,
          $Res Function(_$UserStatsModelImpl) then) =
      __$$UserStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalGames,
      int wins,
      int losses,
      int draws,
      int totalCorrectAnswers,
      int currentWinStreak,
      int bestWinStreak});
}

/// @nodoc
class __$$UserStatsModelImplCopyWithImpl<$Res>
    extends _$UserStatsModelCopyWithImpl<$Res, _$UserStatsModelImpl>
    implements _$$UserStatsModelImplCopyWith<$Res> {
  __$$UserStatsModelImplCopyWithImpl(
      _$UserStatsModelImpl _value, $Res Function(_$UserStatsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalGames = null,
    Object? wins = null,
    Object? losses = null,
    Object? draws = null,
    Object? totalCorrectAnswers = null,
    Object? currentWinStreak = null,
    Object? bestWinStreak = null,
  }) {
    return _then(_$UserStatsModelImpl(
      totalGames: null == totalGames
          ? _value.totalGames
          : totalGames // ignore: cast_nullable_to_non_nullable
              as int,
      wins: null == wins
          ? _value.wins
          : wins // ignore: cast_nullable_to_non_nullable
              as int,
      losses: null == losses
          ? _value.losses
          : losses // ignore: cast_nullable_to_non_nullable
              as int,
      draws: null == draws
          ? _value.draws
          : draws // ignore: cast_nullable_to_non_nullable
              as int,
      totalCorrectAnswers: null == totalCorrectAnswers
          ? _value.totalCorrectAnswers
          : totalCorrectAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      currentWinStreak: null == currentWinStreak
          ? _value.currentWinStreak
          : currentWinStreak // ignore: cast_nullable_to_non_nullable
              as int,
      bestWinStreak: null == bestWinStreak
          ? _value.bestWinStreak
          : bestWinStreak // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserStatsModelImpl implements _UserStatsModel {
  const _$UserStatsModelImpl(
      {this.totalGames = 0,
      this.wins = 0,
      this.losses = 0,
      this.draws = 0,
      this.totalCorrectAnswers = 0,
      this.currentWinStreak = 0,
      this.bestWinStreak = 0});

  factory _$UserStatsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserStatsModelImplFromJson(json);

  @override
  @JsonKey()
  final int totalGames;
  @override
  @JsonKey()
  final int wins;
  @override
  @JsonKey()
  final int losses;
  @override
  @JsonKey()
  final int draws;
  @override
  @JsonKey()
  final int totalCorrectAnswers;
  @override
  @JsonKey()
  final int currentWinStreak;
  @override
  @JsonKey()
  final int bestWinStreak;

  @override
  String toString() {
    return 'UserStatsModel(totalGames: $totalGames, wins: $wins, losses: $losses, draws: $draws, totalCorrectAnswers: $totalCorrectAnswers, currentWinStreak: $currentWinStreak, bestWinStreak: $bestWinStreak)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatsModelImpl &&
            (identical(other.totalGames, totalGames) ||
                other.totalGames == totalGames) &&
            (identical(other.wins, wins) || other.wins == wins) &&
            (identical(other.losses, losses) || other.losses == losses) &&
            (identical(other.draws, draws) || other.draws == draws) &&
            (identical(other.totalCorrectAnswers, totalCorrectAnswers) ||
                other.totalCorrectAnswers == totalCorrectAnswers) &&
            (identical(other.currentWinStreak, currentWinStreak) ||
                other.currentWinStreak == currentWinStreak) &&
            (identical(other.bestWinStreak, bestWinStreak) ||
                other.bestWinStreak == bestWinStreak));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalGames, wins, losses, draws,
      totalCorrectAnswers, currentWinStreak, bestWinStreak);

  /// Create a copy of UserStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatsModelImplCopyWith<_$UserStatsModelImpl> get copyWith =>
      __$$UserStatsModelImplCopyWithImpl<_$UserStatsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserStatsModelImplToJson(
      this,
    );
  }
}

abstract class _UserStatsModel implements UserStatsModel {
  const factory _UserStatsModel(
      {final int totalGames,
      final int wins,
      final int losses,
      final int draws,
      final int totalCorrectAnswers,
      final int currentWinStreak,
      final int bestWinStreak}) = _$UserStatsModelImpl;

  factory _UserStatsModel.fromJson(Map<String, dynamic> json) =
      _$UserStatsModelImpl.fromJson;

  @override
  int get totalGames;
  @override
  int get wins;
  @override
  int get losses;
  @override
  int get draws;
  @override
  int get totalCorrectAnswers;
  @override
  int get currentWinStreak;
  @override
  int get bestWinStreak;

  /// Create a copy of UserStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStatsModelImplCopyWith<_$UserStatsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) {
  return _SubscriptionModel.fromJson(json);
}

/// @nodoc
mixin _$SubscriptionModel {
  String get type => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this SubscriptionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionModelCopyWith<SubscriptionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionModelCopyWith<$Res> {
  factory $SubscriptionModelCopyWith(
          SubscriptionModel value, $Res Function(SubscriptionModel) then) =
      _$SubscriptionModelCopyWithImpl<$Res, SubscriptionModel>;
  @useResult
  $Res call({String type, DateTime? expiresAt, bool isActive});
}

/// @nodoc
class _$SubscriptionModelCopyWithImpl<$Res, $Val extends SubscriptionModel>
    implements $SubscriptionModelCopyWith<$Res> {
  _$SubscriptionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? expiresAt = freezed,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionModelImplCopyWith<$Res>
    implements $SubscriptionModelCopyWith<$Res> {
  factory _$$SubscriptionModelImplCopyWith(_$SubscriptionModelImpl value,
          $Res Function(_$SubscriptionModelImpl) then) =
      __$$SubscriptionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, DateTime? expiresAt, bool isActive});
}

/// @nodoc
class __$$SubscriptionModelImplCopyWithImpl<$Res>
    extends _$SubscriptionModelCopyWithImpl<$Res, _$SubscriptionModelImpl>
    implements _$$SubscriptionModelImplCopyWith<$Res> {
  __$$SubscriptionModelImplCopyWithImpl(_$SubscriptionModelImpl _value,
      $Res Function(_$SubscriptionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? expiresAt = freezed,
    Object? isActive = null,
  }) {
    return _then(_$SubscriptionModelImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionModelImpl implements _SubscriptionModel {
  const _$SubscriptionModelImpl(
      {this.type = 'free', this.expiresAt, this.isActive = false});

  factory _$SubscriptionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionModelImplFromJson(json);

  @override
  @JsonKey()
  final String type;
  @override
  final DateTime? expiresAt;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'SubscriptionModel(type: $type, expiresAt: $expiresAt, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionModelImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, expiresAt, isActive);

  /// Create a copy of SubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionModelImplCopyWith<_$SubscriptionModelImpl> get copyWith =>
      __$$SubscriptionModelImplCopyWithImpl<_$SubscriptionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionModelImplToJson(
      this,
    );
  }
}

abstract class _SubscriptionModel implements SubscriptionModel {
  const factory _SubscriptionModel(
      {final String type,
      final DateTime? expiresAt,
      final bool isActive}) = _$SubscriptionModelImpl;

  factory _SubscriptionModel.fromJson(Map<String, dynamic> json) =
      _$SubscriptionModelImpl.fromJson;

  @override
  String get type;
  @override
  DateTime? get expiresAt;
  @override
  bool get isActive;

  /// Create a copy of SubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionModelImplCopyWith<_$SubscriptionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyGamesModel _$DailyGamesModelFromJson(Map<String, dynamic> json) {
  return _DailyGamesModel.fromJson(json);
}

/// @nodoc
mixin _$DailyGamesModel {
  int get casualPlayed => throw _privateConstructorUsedError;
  int get rankedPlayed => throw _privateConstructorUsedError;
  DateTime? get date => throw _privateConstructorUsedError;

  /// Serializes this DailyGamesModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyGamesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyGamesModelCopyWith<DailyGamesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyGamesModelCopyWith<$Res> {
  factory $DailyGamesModelCopyWith(
          DailyGamesModel value, $Res Function(DailyGamesModel) then) =
      _$DailyGamesModelCopyWithImpl<$Res, DailyGamesModel>;
  @useResult
  $Res call({int casualPlayed, int rankedPlayed, DateTime? date});
}

/// @nodoc
class _$DailyGamesModelCopyWithImpl<$Res, $Val extends DailyGamesModel>
    implements $DailyGamesModelCopyWith<$Res> {
  _$DailyGamesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyGamesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? casualPlayed = null,
    Object? rankedPlayed = null,
    Object? date = freezed,
  }) {
    return _then(_value.copyWith(
      casualPlayed: null == casualPlayed
          ? _value.casualPlayed
          : casualPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      rankedPlayed: null == rankedPlayed
          ? _value.rankedPlayed
          : rankedPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyGamesModelImplCopyWith<$Res>
    implements $DailyGamesModelCopyWith<$Res> {
  factory _$$DailyGamesModelImplCopyWith(_$DailyGamesModelImpl value,
          $Res Function(_$DailyGamesModelImpl) then) =
      __$$DailyGamesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int casualPlayed, int rankedPlayed, DateTime? date});
}

/// @nodoc
class __$$DailyGamesModelImplCopyWithImpl<$Res>
    extends _$DailyGamesModelCopyWithImpl<$Res, _$DailyGamesModelImpl>
    implements _$$DailyGamesModelImplCopyWith<$Res> {
  __$$DailyGamesModelImplCopyWithImpl(
      _$DailyGamesModelImpl _value, $Res Function(_$DailyGamesModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyGamesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? casualPlayed = null,
    Object? rankedPlayed = null,
    Object? date = freezed,
  }) {
    return _then(_$DailyGamesModelImpl(
      casualPlayed: null == casualPlayed
          ? _value.casualPlayed
          : casualPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      rankedPlayed: null == rankedPlayed
          ? _value.rankedPlayed
          : rankedPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyGamesModelImpl implements _DailyGamesModel {
  const _$DailyGamesModelImpl(
      {this.casualPlayed = 0, this.rankedPlayed = 0, this.date});

  factory _$DailyGamesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyGamesModelImplFromJson(json);

  @override
  @JsonKey()
  final int casualPlayed;
  @override
  @JsonKey()
  final int rankedPlayed;
  @override
  final DateTime? date;

  @override
  String toString() {
    return 'DailyGamesModel(casualPlayed: $casualPlayed, rankedPlayed: $rankedPlayed, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyGamesModelImpl &&
            (identical(other.casualPlayed, casualPlayed) ||
                other.casualPlayed == casualPlayed) &&
            (identical(other.rankedPlayed, rankedPlayed) ||
                other.rankedPlayed == rankedPlayed) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, casualPlayed, rankedPlayed, date);

  /// Create a copy of DailyGamesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyGamesModelImplCopyWith<_$DailyGamesModelImpl> get copyWith =>
      __$$DailyGamesModelImplCopyWithImpl<_$DailyGamesModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyGamesModelImplToJson(
      this,
    );
  }
}

abstract class _DailyGamesModel implements DailyGamesModel {
  const factory _DailyGamesModel(
      {final int casualPlayed,
      final int rankedPlayed,
      final DateTime? date}) = _$DailyGamesModelImpl;

  factory _DailyGamesModel.fromJson(Map<String, dynamic> json) =
      _$DailyGamesModelImpl.fromJson;

  @override
  int get casualPlayed;
  @override
  int get rankedPlayed;
  @override
  DateTime? get date;

  /// Create a copy of DailyGamesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyGamesModelImplCopyWith<_$DailyGamesModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
