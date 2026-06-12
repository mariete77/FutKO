// FutKO — Fetch image URLs for quiz questions
// Run:  dart run scripts/download_images.dart [--urls-only]
//
// Sources:
//   Badges:       TheSportsDB (free tier)
//   Stadiums:     Wikipedia REST API (page thumbnail)
//   Players:      Wikipedia REST API (page thumbnail)
//   Competitions: Wikipedia REST API (page thumbnail)
//
// Output: scripts/image_urls.json  (slug → URL map per category)

import 'dart:convert';
import 'dart:io';

// ─── TheSportsDB (badges) ────────────────────────────────────────
const String _sportsDbBase = 'https://www.thesportsdb.com/api/v1/json/3';

const List<String> teams = <String>[
  'Real Madrid', 'FC Barcelona', 'Manchester United', 'Liverpool FC',
  'Bayern Munich', 'Juventus', 'AC Milan', 'Paris Saint-Germain',
  'Ajax', 'Borussia Dortmund', 'Arsenal', 'Chelsea FC',
  'Manchester City', 'Inter Milan', 'Atletico Madrid', 'Benfica',
  'FC Porto', 'Celtic FC', 'Rangers FC', 'AS Roma',
  'Napoli', 'Olympique Marseille', 'Sporting CP', 'Feyenoord',
  'PSV Eindhoven', 'Tottenham Hotspur', 'West Ham United', 'Everton FC',
  'Newcastle United', 'Aston Villa', 'Sevilla FC', 'Valencia CF',
  'Real Betis', 'Athletic Bilbao', 'Bayer Leverkusen', 'RB Leipzig',
  'VfB Stuttgart', 'Borussia Monchengladbach', 'Lazio', 'Fiorentina',
  'Monaco', 'Olympique Lyonnais', 'Lille OSC', 'Cruz Azul',
  'America', 'Chivas Guadalajara', 'Flamengo', 'Palmeiras',
  'Santos FC', 'Sao Paulo FC', 'River Plate', 'Boca Juniors',
  'Independiente', 'Galatasaray', 'Fenerbahce', 'Al Ahly',
  'Esperance', 'Raja Casablanca',
];

// ─── Stadiums (name → Wikipedia search hint) ─────────────────────
const Map<String, String> stadiums = <String, String>{
  'Santiago Bernabéu': 'Santiago Bernabeu Stadium',
  'Camp Nou': 'Camp Nou',
  'Old Trafford': 'Old Trafford',
  'Anfield': 'Anfield',
  'Allianz Arena': 'Allianz Arena',
  'San Siro': 'San Siro',
  'Parc des Princes': 'Parc des Princes',
  'Emirates Stadium': 'Emirates Stadium',
  'Stamford Bridge': 'Stamford Bridge',
  'Etihad Stadium': 'Etihad Stadium Manchester',
  'Signal Iduna Park': 'Signal Iduna Park',
  'Johan Cruyff Arena': 'Johan Cruyff Arena',
  'Wembley Stadium': 'Wembley Stadium',
  'Maracanã': 'Maracana Stadium',
  'La Bombonera': 'La Bombonera',
  'El Monumental': 'Monumental Stadium Buenos Aires',
  'Estádio da Luz': 'Estadio da Luz',
  'Estádio do Dragão': 'Estadio do Dragao',
  'Estadio Azteca': 'Estadio Azteca',
  'Metropolitano': 'Civitas Metropolitano',
  'Mestalla': 'Mestalla Stadium',
  'Ramón Sánchez Pizjuán': 'Ramon Sanchez Pizjuan',
  'San Mamés': 'San Mames Stadium Bilbao',
  'Allianz Parque': 'Allianz Parque',
  'Celtic Park': 'Celtic Park Glasgow',
  'Ibrox Stadium': 'Ibrox Stadium',
  'Estadio Olímpico': 'Stadio Olimpico Rome',
  'Groupama Stadium': 'Groupama Stadium',
  'Stade Vélodrome': 'Stade Velodrome',
  'Tottenham Hotspur Stadium': 'Tottenham Hotspur Stadium',
  'Villa Park': 'Villa Park Birmingham',
  'Goodison Park': 'Goodison Park',
  "St James' Park": 'St James Park Newcastle',
  'London Stadium': 'London Stadium',
  'De Kuip': 'De Kuip',
  'Philips Stadion': 'Philips Stadion',
  'Estadio Akron': 'Estadio Akron',
  'Morumbis': 'Morumbi Stadium',
  'Vila Belmiro': 'Vila Belmiro',
  'Cairo International Stadium': 'Cairo International Stadium',
  'Rams Park': 'Rams Park Istanbul',
  'Stade Mohamed V': 'Stade Mohamed V',
  'BayArena': 'BayArena',
  'Borussia-Park': 'Borussia-Park',
  'Nou Mestalla': 'Nou Mestalla',
  'Estadio de la Cerámica': 'Estadio de la Ceramica',
  'Reale Arena': 'Reale Arena',
  'Deutsche Bank Park': 'Deutsche Bank Park',
  'Gewiss Stadium': 'Gewiss Stadium',
  'Karaiskakis Stadium': 'Karaiskakis Stadium',
  'St. Jakob-Park': 'St Jakob-Park',
  'Parken': 'Parken Stadium',
  'Neo Química Arena': 'Neo Quimica Arena',
  'Arena do Grêmio': 'Arena do Gremio',
  'Estadio Campeón del Siglo': 'Estadio Campeon del Siglo',
};

// ─── Players (name → Wikipedia search hint) ──────────────────────
const Map<String, String> playerHints = <String, String>{
  'Lionel Messi': 'Lionel Messi',
  'Cristiano Ronaldo': 'Cristiano Ronaldo',
  'Neymar Jr': 'Neymar',
  'Kylian Mbappé': 'Kylian Mbappe',
  'Erling Haaland': 'Erling Haaland',
  'Robert Lewandowski': 'Robert Lewandowski',
  'Kevin De Bruyne': 'Kevin De Bruyne',
  'Mohamed Salah': 'Mohamed Salah',
  'Karim Benzema': 'Karim Benzema',
  'Luka Modrić': 'Luka Modric',
  'Virgil van Dijk': 'Virgil van Dijk',
  'Thibaut Courtois': 'Thibaut Courtois',
  'Manuel Neuer': 'Manuel Neuer',
  'Sergio Ramos': 'Sergio Ramos',
  'Toni Kroos': 'Toni Kroos',
  'Harry Kane': 'Harry Kane',
  'Jude Bellingham': 'Jude Bellingham',
  'Vinícius Jr': 'Vinicius Junior',
  'Rodri': 'Rodri (footballer)',
  'Ronaldinho': 'Ronaldinho',
  'Zinedine Zidane': 'Zinedine Zidane',
  'Ronaldo Nazário': 'Ronaldo (Brazilian footballer)',
  'Diego Maradona': 'Diego Maradona',
  'Pelé': 'Pele',
  'Johan Cruyff': 'Johan Cruyff',
  'George Best': 'George Best',
  'Alfredo Di Stéfano': 'Alfredo Di Stefano',
  'Michel Platini': 'Michel Platini',
  'Marco van Basten': 'Marco van Basten',
  'Franz Beckenbauer': 'Franz Beckenbauer',
  'Paolo Maldini': 'Paolo Maldini',
  'Andrea Pirlo': 'Andrea Pirlo',
  'Xavi Hernández': 'Xavi',
  'Andrés Iniesta': 'Andres Iniesta',
  'Gianluigi Buffon': 'Gianluigi Buffon',
  'Iker Casillas': 'Iker Casillas',
  'Wayne Rooney': 'Wayne Rooney',
  'Thierry Henry': 'Thierry Henry',
  'Luis Suárez': 'Luis Suarez',
  'Antoine Griezmann': 'Antoine Griezmann',
  'Sergio Busquets': 'Sergio Busquets',
  "N'Golo Kanté": 'NGolo Kante',
  'Eden Hazard': 'Eden Hazard',
  'Gareth Bale': 'Gareth Bale',
  'Ruud Gullit': 'Ruud Gullit',
  'Paolo Rossi': 'Paolo Rossi',
  'Matthias Sammer': 'Matthias Sammer',
  'Hristo Stoichkov': 'Hristo Stoichkov',
  'George Weah': 'George Weah',
  'Roberto Baggio': 'Roberto Baggio',
  'Luis Figo': 'Luis Figo',
  'Rivaldo': 'Rivaldo',
  'Oleksandr Zinchenko': 'Oleksandr Zinchenko',
  'Bukayo Saka': 'Bukayo Saka',
  'Phil Foden': 'Phil Foden',
  'Victor Osimhen': 'Victor Osimhen',
  'Lautaro Martínez': 'Lautaro Martinez',
  'Jamal Musiala': 'Jamal Musiala',
  'Pedri': 'Pedri',
  'Gavi': 'Gavi (footballer)',
  'Florian Wirtz': 'Florian Wirtz',
  'Lamine Yamal': 'Lamine Yamal',
  'Cole Palmer': 'Cole Palmer',
  'Declan Rice': 'Declan Rice',
  'William Saliba': 'William Saliba',
  'Ruben Dias': 'Ruben Dias',
  'Martin Ødegaard': 'Martin Odegaard',
  'Bruno Fernandes': 'Bruno Fernandes',
  'Moisés Caicedo': 'Moises Caicedo',
  'Dusan Vlahovic': 'Dusan Vlahovic',
  'Khvicha Kvaratskhelia': 'Khvicha Kvaratskhelia',
  'Raphinha': 'Raphinha',
  'Federico Valverde': 'Federico Valverde',
  'Ronald Araújo': 'Ronald Araujo',
  'Alisson Becker': 'Alisson Becker',
  'Jan Oblak': 'Jan Oblak',
  "Marc-André ter Stegen": 'Marc-Andre ter Stegen',
  'Miroslav Klose': 'Miroslav Klose',
  'Gerd Müller': 'Gerd Muller',
  'Eusébio': 'Eusebio',
  'Ferenc Puskás': 'Ferenc Puskas',
  'Kenny Dalglish': 'Kenny Dalglish',
  'Alan Shearer': 'Alan Shearer',
  'Dino Zoff': 'Dino Zoff',
  'Fabio Cannavaro': 'Fabio Cannavaro',
  'Kaká': 'Kaka',
  "Samuel Eto'o": 'Samuel Etoo',
  'Didier Drogba': 'Didier Drogba',
  'Philipp Lahm': 'Philipp Lahm',
  'David Beckham': 'David Beckham',
  'Roberto Carlos': 'Roberto Carlos (footballer)',
  'Lilian Thuram': 'Lilian Thuram',
  'Dennis Bergkamp': 'Dennis Bergkamp',
  'Gianluigi Donnarumma': 'Gianluigi Donnarumma',
};

// ─── Competitions (name → Wikipedia search hint) ─────────────────
const Map<String, String> competitionHints = <String, String>{
  'FIFA World Cup': 'FIFA World Cup',
  'UEFA Champions League': 'UEFA Champions League',
  'UEFA Euro': 'UEFA European Championship',
  'Copa América': 'Copa America',
  'Premier League': 'Premier League',
  'La Liga': 'La Liga',
  'Bundesliga': 'Bundesliga',
  'Serie A': 'Serie A',
  'Ligue 1': 'Ligue 1',
  'Copa del Rey': 'Copa del Rey',
  'FA Cup': 'FA Cup',
  'Africa Cup of Nations': 'Africa Cup of Nations',
  'AFC Asian Cup': 'AFC Asian Cup',
  'CONCACAF Gold Cup': 'CONCACAF Gold Cup',
  'Copa Libertadores': 'Copa Libertadores',
  'UEFA Europa League': 'UEFA Europa League',
  'FIFA Club World Cup': 'FIFA Club World Cup',
  'Olympic Football Tournament': 'Football at the Summer Olympics',
  'UEFA Nations League': 'UEFA Nations League',
  'Copa Sudamericana': 'Copa Sudamericana',
  'UEFA Conference League': 'UEFA Conference League',
  'Supercopa de España': 'Supercopa de Espana',
  'Community Shield': 'FA Community Shield',
  'DFB-Pokal': 'DFB-Pokal',
  'Copa Italia': 'Coppa Italia',
  'UEFA Super Cup': 'UEFA Super Cup',
  'J.League': 'J1 League',
  'MLS Cup': 'MLS Cup',
  'Indian Super League': 'Indian Super League',
};

// ─── Helpers ─────────────────────────────────────────────────────

String slugify(String s) {
  var r = s.toLowerCase();
  const accents = [
    ['\u00e1', 'a'], ['\u00e9', 'e'], ['\u00ed', 'i'], ['\u00f3', 'o'], ['\u00fa', 'u'],
    ['\u00f1', 'n'], ['\u00fc', 'u'], ['\u00e4', 'a'], ['\u00f6', 'o'],
    ['\u00e0', 'a'], ['\u00e8', 'e'], ['\u00ec', 'i'], ['\u00f2', 'o'], ['\u00f9', 'u'],
    ['\u00e2', 'a'], ['\u00ea', 'e'], ['\u00ee', 'i'], ['\u00f4', 'o'], ['\u00fb', 'u'],
    ['\u00e3', 'a'], ['\u00f5', 'o'], ['\u00e7', 'c'], ['\u015b', 's'], ['\u0107', 'c'],
    ['\u017a', 'z'], ['\u017c', 'z'], ['\u0142', 'l'], ['\u0161', 's'], ['\u010d', 'c'],
    ['\u0159', 'r'], ['\u010f', 'd'], ['\u0165', 't'], ['\u0148', 'n'], ['\u016f', 'u'],
    ['\u011b', 'e'], ['\u00fd', 'y'], ['\u017e', 'z'],
  ];
  for (final pair in accents) {
    r = r.replaceAll(pair[0], pair[1]);
  }
  r = r.replaceAll(RegExp(r'[^a-z0-9]'), '_');
  r = r.replaceAll(RegExp(r'_+'), '_');
  if (r.startsWith('_')) r = r.substring(1);
  if (r.endsWith('_')) r = r.substring(0, r.length - 1);
  return r;
}

Future<String?> _httpGet(String url) async {
  try {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 15);
    final req = await client.getUrl(Uri.parse(url));
    final resp = await req.close();
    if (resp.statusCode != 200) {
      await resp.drain<void>();
      client.close();
      return null;
    }
    final body = await resp.transform(utf8.decoder).join();
    client.close();
    return body;
  } catch (_) {
    return null;
  }
}

Future<void> _download(String url, String path) async {
  try {
    final file = File(path);
    await file.parent.create(recursive: true);
    if (await file.exists()) {
      final stat = await file.stat();
      if (stat.size > 0) return;
    }
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 30);
    final req = await client.getUrl(Uri.parse(url));
    final resp = await req.close();
    if (resp.statusCode != 200) {
      await resp.drain<void>();
      client.close();
      return;
    }
    await resp.pipe(file.openWrite());
    client.close();
    stdout.write('.');
  } catch (_) {}
}

/// Fetch thumbnail URL from Wikipedia REST API.
/// Tries the direct page title first, then falls back to search.
Future<String?> _wikiThumbnail(String searchHint) async {
  // 1. Try direct page summary
  final encoded = Uri.encodeComponent(searchHint);
  final summaryUrl = 'https://en.wikipedia.org/api/rest_v1/page/summary/$encoded';
  final body = await _httpGet(summaryUrl);
  if (body != null) {
    try {
      final json = jsonDecode(body);
      final thumb = json['thumbnail'];
      if (thumb is Map && thumb['source'] is String) {
        final url = thumb['source'] as String;
        // Request a decent size (up to 500px wide)
        if (url.contains('/thumb/') && !url.contains('/500px-')) {
          return url.replaceFirst(RegExp(r'/\d+px-'), '/500px-');
        }
        return url;
      }
    } catch (_) {}
  }
  // 2. Fallback: search API, take first result
  final searchUrl =
      'https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch='
      '${Uri.encodeComponent(searchHint)}&format=json&srlimit=1';
  final searchBody = await _httpGet(searchUrl);
  if (searchBody != null) {
    try {
      final searchJson = jsonDecode(searchBody);
      final results = searchJson['query']?['search'] as List?;
      if (results != null && results.isNotEmpty) {
        final title = results[0]['title'] as String;
        final retryUrl =
            'https://en.wikipedia.org/api/rest_v1/page/summary/${Uri.encodeComponent(title)}';
        final retryBody = await _httpGet(retryUrl);
        if (retryBody != null) {
          final retryJson = jsonDecode(retryBody);
          final thumb = retryJson['thumbnail'];
          if (thumb is Map && thumb['source'] is String) {
            final url = thumb['source'] as String;
            if (url.contains('/thumb/') && !url.contains('/500px-')) {
              return url.replaceFirst(RegExp(r'/\d+px-'), '/500px-');
            }
            return url;
          }
        }
      }
    } catch (_) {}
  }
  return null;
}

// ─── Fetchers ────────────────────────────────────────────────────

Future<Map<String, String>> fetchBadges(bool urlsOnly) async {
  final map = <String, String>{};
  stdout.write('\n=== Team badges (TheSportsDB) ===\n');
  for (final team in teams) {
    final slug = slugify(team);
    final query = Uri.encodeComponent(team);
    final body = await _httpGet('$_sportsDbBase/searchteams.php?t=$query');
    if (body == null) { stdout.write('x'); continue; }
    final json = jsonDecode(body);
    final List teamsList = json['teams'] as List? ?? [];
    String? badge;
    for (final t in teamsList) {
      final name = (t['strTeam'] ?? '') as String;
      if (name.toLowerCase() == team.toLowerCase() ||
          name.toLowerCase().contains(team.toLowerCase().split(' ').first.toLowerCase())) {
        badge = (t['strBadge'] ?? t['strTeamBadge'] ?? '') as String;
        break;
      }
    }
    if (badge == null && teamsList.isNotEmpty) {
      badge = (teamsList[0]['strBadge'] ?? teamsList[0]['strTeamBadge'] ?? '') as String;
    }
    if (badge != null && badge.isNotEmpty) {
      map[slug] = badge;
      if (!urlsOnly) {
        await _download(badge, 'assets/images/badges/$slug.png');
      }
      stdout.write('+');
    } else {
      stdout.write('x');
    }
    await Future.delayed(const Duration(seconds: 2));
  }
  stdout.write('\n  => ${map.length}/${teams.length} badges found\n');
  return map;
}

Future<Map<String, String>> fetchStadiums(bool urlsOnly) async {
  final map = <String, String>{};
  stdout.write('\n=== Stadium images (Wikipedia) ===\n');
  for (final entry in stadiums.entries) {
    final slug = slugify(entry.key);
    final url = await _wikiThumbnail(entry.value);
    if (url != null) {
      map[slug] = url;
      if (!urlsOnly) {
        await _download(url, 'assets/images/stadiums/$slug.jpg');
      }
      stdout.write('+');
    } else {
      stdout.write('x');
    }
    await Future.delayed(const Duration(milliseconds: 500));
  }
  stdout.write('\n  => ${map.length}/${stadiums.length} stadiums found\n');
  return map;
}

Future<Map<String, String>> fetchSilhouettes(bool urlsOnly) async {
  final map = <String, String>{};
  stdout.write('\n=== Player images (Wikipedia) ===\n');
  for (final entry in playerHints.entries) {
    final slug = slugify(entry.key);
    final url = await _wikiThumbnail(entry.value);
    if (url != null) {
      map[slug] = url;
      if (!urlsOnly) {
        await _download(url, 'assets/images/silhouettes/$slug.png');
      }
      stdout.write('+');
    } else {
      stdout.write('x');
    }
    await Future.delayed(const Duration(milliseconds: 500));
  }
  stdout.write('\n  => ${map.length}/${playerHints.length} players found\n');
  return map;
}

Future<Map<String, String>> fetchCompetitions(bool urlsOnly) async {
  final map = <String, String>{};
  stdout.write('\n=== Competition logos (Wikipedia) ===\n');
  for (final entry in competitionHints.entries) {
    final slug = slugify(entry.key);
    final url = await _wikiThumbnail(entry.value);
    if (url != null) {
      map[slug] = url;
      if (!urlsOnly) {
        await _download(url, 'assets/images/competitions/$slug.png');
      }
      stdout.write('+');
    } else {
      stdout.write('x');
    }
    await Future.delayed(const Duration(milliseconds: 500));
  }
  stdout.write('\n  => ${map.length}/${competitionHints.length} competitions found\n');
  return map;
}

// ─── Main ────────────────────────────────────────────────────────

Future<void> main(List<String> args) async {
  final urlsOnly = args.contains('--urls-only');

  if (!urlsOnly) {
    stdout.write('Downloading images to assets/images/...\n');
    await Directory('assets/images/badges').create(recursive: true);
    await Directory('assets/images/stadiums').create(recursive: true);
    await Directory('assets/images/silhouettes').create(recursive: true);
    await Directory('assets/images/competitions').create(recursive: true);
  } else {
    stdout.write('URLs-only mode (no downloads).\n');
  }

  final badges = await fetchBadges(urlsOnly);
  final stadiums = await fetchStadiums(urlsOnly);
  final silhouettes = await fetchSilhouettes(urlsOnly);
  final comps = await fetchCompetitions(urlsOnly);

  final result = <String, dynamic>{
    'badges': badges,
    'stadiums': stadiums,
    'silhouettes': silhouettes,
    'competitions': comps,
  };

  final jsonFile = File('scripts/image_urls.json');
  await jsonFile.writeAsString(
    '${const JsonEncoder.withIndent('  ').convert(result)}\n',
  );
  stdout.write('\nSaved scripts/image_urls.json\n');
  stdout.write('  badges:        ${badges.length}\n');
  stdout.write('  stadiums:      ${stadiums.length}\n');
  stdout.write('  silhouettes:   ${silhouettes.length}\n');
  stdout.write('  competitions:  ${comps.length}\n');

  final total = badges.length + stadiums.length + silhouettes.length + comps.length;
  final expected = teams.length + stadiums.length + playerHints.length + competitionHints.length;
  stdout.write('  TOTAL:         $total / $expected\n');
  stdout.write('\nDone!\n');
}
