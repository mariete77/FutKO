// FutKO - Download images from TheSportsDB
//
// Usage:
//   dart run scripts/download_images.dart
//   dart run scripts/download_images.dart --badges --stadiums
//   dart run scripts/download_images.dart --delay 500
//
// Downloads images from TheSportsDB API (free tier) and saves them
// to assets/images/ ready for upload to Firebase Storage.
//
// TheSportsDB API: https://www.thesportsdb.com/free_sports_api
// Free key: 3 (test key, rate-limited)

import 'dart:convert';
import 'dart:io';

const _apiKey = '3';
const _baseUrl = 'https://www.thesportsdb.com/api/v1/json';
const _outputBase = 'assets/images';
const _defaultDelayMs = 300;

// Teams in football_data.dart (must match exactly)
const _teams = <String>[
  'Real Madrid', 'FC Barcelona', 'Manchester United', 'Liverpool FC',
  'Bayern Munich', 'Juventus', 'AC Milan', 'Paris Saint-Germain',
  'Ajax', 'Borussia Dortmund', 'Arsenal', 'Chelsea FC',
  'Manchester City', 'Inter Milan', 'Atletico Madrid', 'Benfica',
  'FC Porto', 'Celtic FC', 'Rangers FC', 'AS Roma', 'Napoli',
  'Olympique Marseille', 'Sporting CP', 'Feyenoord', 'PSV Eindhoven',
  'Tottenham Hotspur', 'West Ham United', 'Everton FC',
  'Newcastle United', 'Aston Villa', 'Sevilla FC', 'Valencia CF',
  'Real Betis', 'Athletic Bilbao', 'Bayer Leverkusen', 'RB Leipzig',
  'VfB Stuttgart', 'Borussia Monchengladbach', 'Lazio', 'Fiorentina',
  'Monaco', 'Olympique Lyonnais', 'Lille OSC', 'Cruz Azul',
  'America', 'Chivas Guadalajara', 'Flamengo', 'Palmeiras',
  'Santos FC', 'Sao Paulo FC', 'River Plate', 'Boca Juniors',
  'Independiente', 'Galatasaray', 'Fenerbahce', 'Ajax Cape Town',
  'Al Ahly', 'Esperance', 'Raja Casabranca',
];

// Players in football_data.dart
const _players = <String>[
  'Lionel Messi', 'Cristiano Ronaldo', 'Neymar', 'Kylian Mbappe',
  'Erling Haaland', 'Robert Lewandowski', 'Kevin De Bruyne', 'Mohamed Salah',
  'Karim Benzema', 'Luka Modric', 'Virgil van Dijk', 'Thibaut Courtois',
  'Manuel Neuer', 'Sergio Ramos', 'Toni Kroos', 'Harry Kane',
  'Jude Bellingham', 'Vinicius Jr', 'Rodri', 'Ronaldinho',
  'Zinedine Zidane', 'Ronaldo Nazario', 'Diego Maradona', 'Pele',
  'Johan Cruyff', 'George Best', 'Alfredo Di Stefano', 'Michel Platini',
  'Marco van Basten', 'Franz Beckenbauer', 'Paolo Maldini', 'Andrea Pirlo',
  'Xavi Hernandez', 'Andres Iniesta', 'Gianluigi Buffon', 'Iker Casillas',
  'Wayne Rooney', 'Thierry Henry', 'Luis Suarez', 'Antoine Griezmann',
  'Sergio Busquets', "N'Golo Kante", 'Eden Hazard', 'Gareth Bale',
  'Ruud Gullit', 'Paolo Rossi', 'Matthias Sammer', 'Hristo Stoichkov',
  'George Weah', 'Roberto Baggio', 'Luis Figo', 'Rivaldo',
  'Oleksandr Zinchenko', 'Bukayo Saka', 'Phil Foden', 'Victor Osimhen',
  'Lautaro Martinez', 'Jamal Musiala', 'Pedri', 'Gavi',
];

// Competitions: name -> TheSportsDB search term
const _competitions = <String, String>{
  'FIFA World Cup': 'FIFA World Cup',
  'UEFA Champions League': 'UEFA Champions League',
  'UEFA Euro': 'UEFA European Championship',
  'Copa America': 'Copa America',
  'Premier League': 'English Premier League',
  'La Liga': 'Spanish La Liga',
  'Bundesliga': 'German Bundesliga',
  'Serie A': 'Italian Serie A',
  'Ligue 1': 'French Ligue 1',
  'Copa del Rey': 'Copa del Rey',
  'FA Cup': 'FA Cup',
  'Africa Cup of Nations': 'Africa Cup of Nations',
  'AFC Asian Cup': 'AFC Asian Cup',
  'CONCACAF Gold Cup': 'CONCACAF Gold Cup',
  'Copa Libertadores': 'Copa Libertadores',
  'UEFA Europa League': 'UEFA Europa League',
  'FIFA Club World Cup': 'FIFA Club World Cup',
  'Olympic Football Tournament': 'Olympic Football',
  'UEFA Nations League': 'UEFA Nations League',
  'Copa Sudamericana': 'Copa Sudamericana',
};

int _delayMs = _defaultDelayMs;
int _downloaded = 0;
int _skipped = 0;
int _failed = 0;

final _client = HttpClient();

Future<void> main(List<String> args) async {
  final flags = _parseArgs(args);

  print('''
========================================
  FutKO - Download images from TheSportsDB
  Output: $_outputBase/
  Delay: ${_delayMs}ms between requests
========================================
  ''');

  // Create output directories
  for (final dir in ['badges', 'stadiums', 'silhouettes', 'competitions']) {
    await Directory('$_outputBase/$dir').create(recursive: true);
  }

  try {
    if (flags['badges'] == true) await _downloadBadges();
    if (flags['stadiums'] == true) await _downloadStadiums();
    if (flags['silhouettes'] == true) await _downloadSilhouettes();
    if (flags['competitions'] == true) await _downloadCompetitions();
  } finally {
    _client.close();
  }

  print('''
========================================
  Done! Downloaded: $_downloaded  Skipped: $_skipped  Failed: $_failed
  
  Next step: upload to Firebase Storage
    dart run scripts/upload_images.dart --input $_outputBase
  ========================================
  ''');
}

Map<String, bool> _parseArgs(List<String> args) {
  var flags = <String, bool>{};
  for (var i = 0; i < args.length; i++) {
    if (args[i] == '--delay' && i + 1 < args.length) {
      _delayMs = int.tryParse(args[i + 1]) ?? _defaultDelayMs;
    } else if (args[i] == '--all' || args.isEmpty) {
      flags['badges'] = true;
      flags['stadiums'] = true;
      flags['silhouettes'] = true;
      flags['competitions'] = true;
    } else if (args[i].startsWith('--') && !['--delay', '--help'].contains(args[i])) {
      flags[args[i].substring(2)] = true;
    }
  }
  // Default: download all
  if (flags.isEmpty) {
    flags = {'badges': true, 'stadiums': true, 'silhouettes': true, 'competitions': true};
  }
  return flags;
}

// ── BADGES ──────────────────────────────────────────────
Future<void> _downloadBadges() async {
  print('\n-- BADGES (${_teams.length} teams) --');
  for (final teamName in _teams) {
    final slug = _slugify(teamName);
    final target = File('$_outputBase/badges/$slug.png');
    if (await target.exists()) {
      print('  SKIP $teamName (exists)');
      _skipped++;
      continue;
    }
    final url = await _findTeamBadge(teamName);
    if (url != null) {
      await _downloadFile(url, target);
      print('  OK   $teamName');
      _downloaded++;
    } else {
      print('  FAIL $teamName (not found)');
      _failed++;
    }
    await _delay();
  }
}

Future<String?> _findTeamBadge(String teamName) async {
  final results = await _searchTeams(teamName);
  if (results == null || results.isEmpty) return null;
  // Find best match by strTeam
  final match = results.firstWhere(
    (t) => (t['strTeam'] as String?)?.toLowerCase() == teamName.toLowerCase(),
    orElse: () => results.first,
  );
  return match['strBadge'] as String?;
}

// ── STADIUMS ────────────────────────────────────────────
Future<void> _downloadStadiums() async {
  print('\n-- STADIUMS (${_teams.length} teams -> venues) --');
  final seenVenues = <String>{};
  for (final teamName in _teams) {
    final results = await _searchTeams(teamName);
    if (results == null || results.isEmpty) {
      print('  FAIL $teamName (team not found)');
      _failed++;
      await _delay();
      continue;
    }
    final match = results.firstWhere(
      (t) => (t['strTeam'] as String?)?.toLowerCase() == teamName.toLowerCase(),
      orElse: () => results.first,
    );
    final venueId = match['idVenue']?.toString();
    if (venueId == null || venueId == '0' || venueId.isEmpty) {
      print('  FAIL $teamName (no venue id)');
      _failed++;
      await _delay();
      continue;
    }
    if (seenVenues.contains(venueId)) {
      _skipped++;
      continue;
    }
    seenVenues.add(venueId);

    final stadiumName = match['strStadium'] as String? ?? teamName;
    final slug = _slugify(stadiumName);
    final target = File('$_outputBase/stadiums/$slug.jpg');
    if (await target.exists()) {
      print('  SKIP $stadiumName (exists)');
      _skipped++;
      continue;
    }

    final venueUrl = await _findVenueThumb(venueId);
    if (venueUrl != null) {
      await _downloadFile(venueUrl, target);
      print('  OK   $stadiumName');
      _downloaded++;
    } else {
      print('  FAIL $stadiumName (no thumb)');
      _failed++;
    }
    await _delay();
  }
}

Future<String?> _findVenueThumb(String venueId) async {
  final uri = Uri.parse('$_baseUrl/$_apiKey/lookupvenue.php?id=$venueId');
  final data = await _getJson(uri);
  final venues = data?['venues'] as List?;
  if (venues == null || venues.isEmpty) return null;
  return venues.first['strThumb'] as String?;
}

// ── SILHOUETTES (player cutouts) ────────────────────────
Future<void> _downloadSilhouettes() async {
  print('\n-- SILHOUETTES (${_players.length} players) --');
  for (final playerName in _players) {
    final slug = _slugify(playerName);
    final target = File('$_outputBase/silhouettes/$slug.png');
    if (await target.exists()) {
      print('  SKIP $playerName (exists)');
      _skipped++;
      continue;
    }
    final url = await _findPlayerCutout(playerName);
    if (url != null) {
      await _downloadFile(url, target);
      print('  OK   $playerName');
      _downloaded++;
    } else {
      print('  FAIL $playerName (not found)');
      _failed++;
    }
    await _delay();
  }
}

Future<String?> _findPlayerCutout(String playerName) async {
  final uri = Uri.parse(
    '$_baseUrl/$_apiKey/searchplayers.php?p=${Uri.encodeComponent(playerName)}',
  );
  final data = await _getJson(uri);
  final players = data?['player'] as List?;
  if (players == null || players.isEmpty) return null;
  // Best match by strPlayer
  final match = players.firstWhere(
    (p) => (p['strPlayer'] as String?)?.toLowerCase() == playerName.toLowerCase(),
    orElse: () => players.first,
  );
  return match['strCutout'] as String?;
}

// ── COMPETITIONS ────────────────────────────────────────
Future<void> _downloadCompetitions() async {
  print('\n-- COMPETITIONS (${_competitions.length} leagues) --');
  // Get all leagues once
  final allLeagues = await _fetchAllLeagues();
  if (allLeagues == null) {
    print('  FAIL: Could not fetch leagues list');
    _failed += _competitions.length;
    return;
  }

  for (final entry in _competitions.entries) {
    final ourName = entry.key;
    final searchName = entry.value;
    final slug = _slugify(ourName);
    final target = File('$_outputBase/competitions/$slug.png');
    if (await target.exists()) {
      print('  SKIP $ourName (exists)');
      _skipped++;
      continue;
    }

    final match = allLeagues.firstWhere(
      (l) => (l['strLeague'] as String?)?.toLowerCase().contains(searchName.toLowerCase()) == true,
      orElse: () => <String, dynamic>{},
    );

    final badge = match['strBadge'] as String?;
    if (badge != null && badge.isNotEmpty) {
      await _downloadFile(badge, target);
      print('  OK   $ourName');
      _downloaded++;
    } else {
      print('  FAIL $ourName (not found in ${allLeagues.length} leagues)');
      _failed++;
    }
  }
}

Future<List<Map<String, dynamic>>?> _fetchAllLeagues() async {
  final uri = Uri.parse('$_baseUrl/$_apiKey/all_leagues.php');
  final data = await _getJson(uri);
  final leagues = data?['leagues'] as List?;
  return leagues?.cast<Map<String, dynamic>>();
}

// ── HTTP HELPERS ────────────────────────────────────────

Future<List<Map<String, dynamic>>?> _searchTeams(String query) async {
  final uri = Uri.parse(
    '$_baseUrl/$_apiKey/searchteams.php?t=${Uri.encodeComponent(query)}',
  );
  final data = await _getJson(uri);
  final teams = data?['teams'] as List?;
  return teams?.cast<Map<String, dynamic>>();
}

Future<Map<String, dynamic>?> _getJson(Uri uri) async {
  try {
    final request = await _client.getUrl(uri);
    final response = await request.close();
    if (response.statusCode != 200) return null;
    final body = await response.transform(utf8.decoder).join();
    return jsonDecode(body) as Map<String, dynamic>;
  } catch (e) {
    return null;
  }
}

Future<void> _downloadFile(String url, File target) async {
  try {
    final uri = Uri.parse(url);
    final request = await _client.getUrl(uri);
    final response = await request.close();
    if (response.statusCode != 200) throw Exception('HTTP ${response.statusCode}');
    final bytes = await response.expand((chunk) => chunk).toList();
    await target.writeAsBytes(bytes);
  } catch (e) {
    if (await target.exists()) await target.delete();
    rethrow;
  }
}

Future<void> _delay() async {
  await Future.delayed(Duration(milliseconds: _delayMs));
}

String _slugify(String name) {
  return name
      .toLowerCase()
      .replaceAll(RegExp(r"[^a-z0-9]+"), '_')
      .replaceAll(RegExp(r'^_|_\$'), '');
}
