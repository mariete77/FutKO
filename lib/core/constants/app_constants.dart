/// App-wide constants
class AppConstants {
  // App Info
  static const String appName = 'FutKO';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String matchesCollection = 'matches';
  static const String questionsCollection = 'questions';
  static const String ghostRunsCollection = 'ghostRuns';

  // Firebase Realtime Database
  static const String matchmakingQueue = 'matchmaking/queue';

  // Storage Paths
  static const String badgesPath = 'badges';
  static const String playerPhotosPath = 'players';
  static const String stadiumsPath = 'stadiums';
  static const String avatarsPath = 'avatars';

  // Deep Links
  static const String deepLinkScheme = 'futko';
  static const String deepLinkHost = 'open';
}
