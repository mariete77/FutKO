class FootballData {
  static final List<_Team> teams = [
    _Team('Real Madrid', 'España', 'La Liga', 1902, 'Santiago Bernabéu'),
    _Team('FC Barcelona', 'España', 'La Liga', 1899, 'Camp Nou'),
    _Team('Manchester United', 'Inglaterra', 'Premier League', 1878, 'Old Trafford'),
    _Team('Liverpool FC', 'Inglaterra', 'Premier League', 1892, 'Anfield'),
    _Team('Bayern Munich', 'Alemania', 'Bundesliga', 1900, 'Allianz Arena'),
    _Team('Juventus', 'Italia', 'Serie A', 1897, 'Allianz Stadium'),
    _Team('AC Milan', 'Italia', 'Serie A', 1899, 'San Siro'),
    _Team('Paris Saint-Germain', 'Francia', 'Ligue 1', 1970, 'Parc des Princes'),
    _Team('Ajax', 'Países Bajos', 'Eredivisie', 1900, 'Johan Cruyff Arena'),
    _Team('Borussia Dortmund', 'Alemania', 'Bundesliga', 1909, 'Signal Iduna Park'),
    _Team('Arsenal', 'Inglaterra', 'Premier League', 1886, 'Emirates Stadium'),
    _Team('Chelsea FC', 'Inglaterra', 'Premier League', 1905, 'Stamford Bridge'),
    _Team('Manchester City', 'Inglaterra', 'Premier League', 1880, 'Etihad Stadium'),
    _Team('Inter Milan', 'Italia', 'Serie A', 1908, 'San Siro'),
    _Team('Atlético Madrid', 'España', 'La Liga', 1903, 'Metropolitano'),
    _Team('Benfica', 'Portugal', 'Primeira Liga', 1904, 'Estádio da Luz'),
    _Team('FC Porto', 'Portugal', 'Primeira Liga', 1893, 'Estádio do Dragão'),
    _Team('Celtic FC', 'Escocia', 'Scottish Premiership', 1887, 'Celtic Park'),
    _Team('Rangers FC', 'Escocia', 'Scottish Premiership', 1872, 'Ibrox Stadium'),
    _Team('AS Roma', 'Italia', 'Serie A', 1927, 'Stadio Olimpico'),
    _Team('Napoli', 'Italia', 'Serie A', 1926, 'Diego Armando Maradona'),
    _Team('Olympique Marseille', 'Francia', 'Ligue 1', 1899, 'Stade Vélodrome'),
    _Team('Sporting CP', 'Portugal', 'Primeira Liga', 1906, 'Estádio José Alvalade'),
    _Team('Feyenoord', 'Países Bajos', 'Eredivisie', 1908, 'De Kuip'),
    _Team('PSV Eindhoven', 'Países Bajos', 'Eredivisie', 1913, 'Philips Stadion'),
    _Team('Tottenham Hotspur', 'Inglaterra', 'Premier League', 1882, 'Tottenham Hotspur Stadium'),
    _Team('West Ham United', 'Inglaterra', 'Premier League', 1895, 'London Stadium'),
    _Team('Everton FC', 'Inglaterra', 'Premier League', 1878, 'Goodison Park'),
    _Team('Newcastle United', 'Inglaterra', 'Premier League', 1892, "St James' Park"),
    _Team('Aston Villa', 'Inglaterra', 'Premier League', 1874, 'Villa Park'),
    _Team('Sevilla FC', 'España', 'La Liga', 1890, 'Ramón Sánchez Pizjuán'),
    _Team('Valencia CF', 'España', 'La Liga', 1919, 'Mestalla'),
    _Team('Real Betis', 'España', 'La Liga', 1907, 'Benito Villamarín'),
    _Team('Athletic Bilbao', 'España', 'La Liga', 1898, 'San Mamés'),
    _Team('Bayer Leverkusen', 'Alemania', 'Bundesliga', 1904, 'BayArena'),
    _Team('RB Leipzig', 'Alemania', 'Bundesliga', 2009, 'Red Bull Arena'),
    _Team('VfB Stuttgart', 'Alemania', 'Bundesliga', 1893, 'MHPArena'),
    _Team('Borussia Mönchengladbach', 'Alemania', 'Bundesliga', 1900, 'Borussia-Park'),
    _Team('Lazio', 'Italia', 'Serie A', 1900, 'Stadio Olimpico'),
    _Team('Fiorentina', 'Italia', 'Serie A', 1926, 'Stadio Artemio Franchi'),
    _Team('Monaco', 'Francia', 'Ligue 1', 1924, 'Stade Louis II'),
    _Team('Olympique Lyonnais', 'Francia', 'Ligue 1', 1950, 'Groupama Stadium'),
    _Team('Lille OSC', 'Francia', 'Ligue 1', 1944, 'Stade Pierre-Mauroy'),
    _Team('Cruz Azul', 'México', 'Liga MX', 1927, 'Estadio Azteca'),
    _Team('América', 'México', 'Liga MX', 1916, 'Estadio Azteca'),
    _Team('Chivas Guadalajara', 'México', 'Liga MX', 1906, 'Estadio Akron'),
    _Team('Flamengo', 'Brasil', 'Brasileirão', 1895, 'Maracanã'),
    _Team('Palmeiras', 'Brasil', 'Brasileirão', 1914, 'Allianz Parque'),
    _Team('Santos FC', 'Brasil', 'Brasileirão', 1912, 'Vila Belmiro'),
    _Team('São Paulo FC', 'Brasil', 'Brasileirão', 1930, 'Morumbis'),
    _Team('River Plate', 'Argentina', 'Primera División', 1901, 'El Monumental'),
    _Team('Boca Juniors', 'Argentina', 'Primera División', 1905, 'La Bombonera'),
    _Team('Independiente', 'Argentina', 'Primera División', 1905, 'Estadio Libertadores'),
    _Team('Galatasaray', 'Turquía', 'Süper Lig', 1905, 'Rams Park'),
    _Team('Fenerbahçe', 'Turquía', 'Süper Lig', 1907, 'Şükrü Saracoğlu'),
    _Team('Ajax Cape Town', 'Sudáfrica', 'Premier Division', 1999, 'Cape Town Stadium'),
    _Team('Al Ahly', 'Egipto', 'Egyptian Premier League', 1907, 'Cairo International Stadium'),
    _Team('Espérance', 'Túnez', 'Tunisian Ligue', 1919, 'Stade Hammadi Agrebi'),
    _Team('Raja Casablanca', 'Marruecos', 'Botola', 1949, 'Stade Mohamed V'),
  ];

  static final List<_Player> players = [
    _Player('Lionel Messi', 'Argentina', 'Delantero', 8, 'FC Barcelona/PSG/Inter Miami'),
    _Player('Cristiano Ronaldo', 'Portugal', 'Delantero', 5, 'Manchester United/Real Madrid/Juventus/Al Nassr'),
    _Player('Neymar Jr', 'Brasil', 'Delantero', 0, 'Santos/FC Barcelona/PSG/Al Hilal'),
    _Player('Kylian Mbappé', 'Francia', 'Delantero', 0, 'Monaco/PSG/Real Madrid'),
    _Player('Erling Haaland', 'Noruega', 'Delantero', 0, 'RB Salzburg/Dortmund/Manchester City'),
    _Player('Robert Lewandowski', 'Polonia', 'Delantero', 0, 'Dortmund/Bayern/FC Barcelona'),
    _Player('Kevin De Bruyne', 'Bélgica', 'Centrocampista', 0, 'Chelsea/Wolfsburg/Manchester City'),
    _Player('Mohamed Salah', 'Egipto', 'Delantero', 0, 'Roma/Liverpool'),
    _Player('Karim Benzema', 'Francia', 'Delantero', 1, 'Lyon/Real Madrid/Al Ittihad'),
    _Player('Luka Modrić', 'Croacia', 'Centrocampista', 1, 'Tottenham/Real Madrid'),
    _Player('Virgil van Dijk', 'Países Bajos', 'Defensa', 0, 'Celtic/Southampton/Liverpool'),
    _Player('Thibaut Courtois', 'Bélgica', 'Portero', 0, 'Chelsea/Real Madrid'),
    _Player('Manuel Neuer', 'Alemania', 'Portero', 0, 'Schalke/Bayern Munich'),
    _Player('Sergio Ramos', 'España', 'Defensa', 0, 'Real Madrid/PSG/Sevilla'),
    _Player('Toni Kroos', 'Alemania', 'Centrocampista', 0, 'Bayern Munich/Real Madrid'),
    _Player('Harry Kane', 'Inglaterra', 'Delantero', 0, 'Tottenham/Bayern Munich'),
    _Player('Jude Bellingham', 'Inglaterra', 'Centrocampista', 0, 'Birmingham/Dortmund/Real Madrid'),
    _Player('Vinícius Jr', 'Brasil', 'Delantero', 0, 'Flamengo/Real Madrid'),
    _Player('Rodri', 'España', 'Centrocampista', 1, 'Atlético Madrid/Manchester City'),
    _Player('Ronaldinho', 'Brasil', 'Centrocampista', 1, 'PSG/FC Barcelona/AC Milan'),
    _Player('Zinedine Zidane', 'Francia', 'Centrocampista', 1, 'Juventus/Real Madrid'),
    _Player('Ronaldo Nazário', 'Brasil', 'Delantero', 2, 'PSV/FC Barcelona/Inter/Real Madrid/AC Milan'),
    _Player('Diego Maradona', 'Argentina', 'Centrocampista', 0, 'Boca Juniors/FC Barcelona/Napoli'),
    _Player('Pelé', 'Brasil', 'Delantero', 0, 'Santos/New York Cosmos'),
    _Player('Johan Cruyff', 'Países Bajos', 'Centrocampista', 1, 'Ajax/FC Barcelona'),
    _Player('George Best', 'Irlanda del Norte', 'Delantero', 1, 'Manchester United'),
    _Player('Alfredo Di Stéfano', 'Argentina/España', 'Delantero', 2, 'River Plate/Real Madrid'),
    _Player('Michel Platini', 'Francia', 'Centrocampista', 3, 'Nancy/Saint-Étienne/Juventus'),
    _Player('Marco van Basten', 'Países Bajos', 'Delantero', 3, 'Ajax/AC Milan'),
    _Player('Franz Beckenbauer', 'Alemania', 'Defensa', 2, 'Bayern Munich/New York Cosmos'),
    _Player('Paolo Maldini', 'Italia', 'Defensa', 0, 'AC Milan'),
    _Player('Andrea Pirlo', 'Italia', 'Centrocampista', 0, 'AC Milan/Juventus/NYCFC'),
    _Player('Xavi Hernández', 'España', 'Centrocampista', 0, 'FC Barcelona/Al Sadd'),
    _Player('Andrés Iniesta', 'España', 'Centrocampista', 0, 'FC Barcelona/Vissel Kobe'),
    _Player('Gianluigi Buffon', 'Italia', 'Portero', 0, 'Parma/Juventus/PSG'),
    _Player('Iker Casillas', 'España', 'Portero', 0, 'Real Madrid/FC Porto'),
    _Player('Wayne Rooney', 'Inglaterra', 'Delantero', 0, 'Everton/Manchester United/DC United'),
    _Player('Thierry Henry', 'Francia', 'Delantero', 0, 'Monaco/Arsenal/FC Barcelona/NYRB'),
    _Player('Luis Suárez', 'Uruguay', 'Delantero', 0, 'Ajax/Liverpool/FC Barcelona/Atlético Madrid/Grêmio'),
    _Player('Antoine Griezmann', 'Francia', 'Delantero', 0, 'Real Sociedad/Atlético Madrid/FC Barcelona'),
    _Player('Sergio Busquets', 'España', 'Centrocampista', 0, 'FC Barcelona/Inter Miami'),
    _Player('N\'Golo Kanté', 'Francia', 'Centrocampista', 0, 'Caen/Leicester/Chelsea/Al Ittihad'),
    _Player('Eden Hazard', 'Bélgica', 'Delantero', 0, 'Lille/Chelsea/Real Madrid'),
    _Player('Gareth Bale', 'Gales', 'Delantero', 0, 'Tottenham/Real Madrid/LAFC'),
    _Player('Ruud Gullit', 'Países Bajos', 'Centrocampista', 1, 'Feyenoord/PSV/AC Milan'),
    _Player('Paolo Rossi', 'Italia', 'Delantero', 1, 'Juventus/AC Milan'),
    _Player('Matthias Sammer', 'Alemania', 'Defensa', 1, 'Stuttgart/Dortmund/Bayern Munich'),
    _Player('Hristo Stoichkov', 'Bulgaria', 'Delantero', 1, 'CSKA Sofia/FC Barcelona'),
    _Player('George Weah', 'Liberia', 'Delantero', 1, 'Monaco/PSG/AC Milan/Chelsea'),
    _Player('Roberto Baggio', 'Italia', 'Delantero', 1, 'Fiorentina/Juventus/AC Milan'),
    _Player('Luis Figo', 'Portugal', 'Centrocampista', 1, 'FC Barcelona/Real Madrid/Inter Milan'),
    _Player('Rivaldo', 'Brasil', 'Centrocampista', 1, 'FC Barcelona/AC Milan'),
    _Player('Oleksandr Zinchenko', 'Ucrania', 'Defensa', 0, 'Ufa/Manchester City/Arsenal'),
    _Player('Bukayo Saka', 'Inglaterra', 'Centrocampista', 0, 'Arsenal'),
    _Player('Phil Foden', 'Inglaterra', 'Centrocampista', 0, 'Manchester City'),
    _Player('Victor Osimhen', 'Nigeria', 'Delantero', 0, 'Lille/Napoli/Galatasaray'),
    _Player('Lautaro Martínez', 'Argentina', 'Delantero', 0, 'Racing Club/Inter Milan'),
    _Player('Jamal Musiala', 'Alemania', 'Centrocampista', 0, 'Chelsea/Bayern Munich'),
    _Player('Pedri', 'España', 'Centrocampista', 0, 'Las Palmas/FC Barcelona'),
    _Player('Gavi', 'España', 'Centrocampista', 0, 'FC Barcelona'),
  ];

  static final List<_Competition> competitions = [
    _Competition('FIFA World Cup', 'Selecciones', 1930, 'Cada 4 años', 8),
    _Competition('UEFA Champions League', 'Clubes', 1955, 'Anual', 15),
    _Competition('UEFA Euro', 'Selecciones', 1960, 'Cada 4 años', 4),
    _Competition('Copa América', 'Selecciones', 1916, 'Cada 4 años', 1),
    _Competition('Premier League', 'Clubes', 1992, 'Anual', 0),
    _Competition('La Liga', 'Clubes', 1929, 'Anual', 0),
    _Competition('Bundesliga', 'Clubes', 1963, 'Anual', 0),
    _Competition('Serie A', 'Clubes', 1929, 'Anual', 0),
    _Competition('Ligue 1', 'Clubes', 1932, 'Anual', 0),
    _Competition('Copa del Rey', 'Clubes', 1903, 'Anual', 0),
    _Competition('FA Cup', 'Clubes', 1871, 'Anual', 0),
    _Competition('Africa Cup of Nations', 'Selecciones', 1957, 'Cada 2 años', 1),
    _Competition('AFC Asian Cup', 'Selecciones', 1956, 'Cada 4 años', 1),
    _Competition('CONCACAF Gold Cup', 'Selecciones', 1963, 'Cada 2 años', 1),
    _Competition('Copa Libertadores', 'Clubes', 1960, 'Anual', 3),
    _Competition('UEFA Europa League', 'Clubes', 1971, 'Anual', 3),
    _Competition('FIFA Club World Cup', 'Clubes', 2000, 'Anual', 3),
    _Competition('Olympic Football Tournament', 'Selecciones', 1900, 'Cada 4 años', 0),
    _Competition('UEFA Nations League', 'Selecciones', 2018, 'Cada 2 años', 0),
    _Competition('Copa Sudamericana', 'Clubes', 2002, 'Anual', 2),
  ];

  static final List<_Stadium> stadiums = [
    _Stadium('Santiago Bernabéu', 'Madrid', 'Real Madrid', 81044),
    _Stadium('Camp Nou', 'Barcelona', 'FC Barcelona', 99354),
    _Stadium('Old Trafford', 'Mánchester', 'Manchester United', 74310),
    _Stadium('Anfield', 'Liverpool', 'Liverpool FC', 53394),
    _Stadium('Allianz Arena', 'Múnich', 'Bayern Munich', 75024),
    _Stadium('San Siro', 'Milán', 'AC Milan / Inter Milan', 75923),
    _Stadium('Parc des Princes', 'París', 'Paris Saint-Germain', 47929),
    _Stadium('Emirates Stadium', 'Londres', 'Arsenal', 60704),
    _Stadium('Stamford Bridge', 'Londres', 'Chelsea FC', 40341),
    _Stadium('Etihad Stadium', 'Mánchester', 'Manchester City', 53400),
    _Stadium('Signal Iduna Park', 'Dortmund', 'Borussia Dortmund', 81365),
    _Stadium('Johan Cruyff Arena', 'Ámsterdam', 'Ajax', 55985),
    _Stadium('Wembley Stadium', 'Londres', 'Selección Inglesa', 90000),
    _Stadium('Maracanã', 'Río de Janeiro', 'Flamengo/Fluminense', 78838),
    _Stadium('La Bombonera', 'Buenos Aires', 'Boca Juniors', 54000),
    _Stadium('El Monumental', 'Buenos Aires', 'River Plate', 84000),
    _Stadium('Estádio da Luz', 'Lisboa', 'Benfica', 64642),
    _Stadium('Estádio do Dragão', 'Oporto', 'FC Porto', 50033),
    _Stadium('Estadio Azteca', 'Ciudad de México', 'América/Cruz Azul', 87523),
    _Stadium('Metropolitano', 'Madrid', 'Atlético Madrid', 70460),
    _Stadium('Mestalla', 'Valencia', 'Valencia CF', 49430),
    _Stadium('Ramón Sánchez Pizjuán', 'Sevilla', 'Sevilla FC', 43883),
    _Stadium('San Mamés', 'Bilbao', 'Athletic Bilbao', 53289),
    _Stadium('Allianz Parque', 'São Paulo', 'Palmeiras', 43713),
    _Stadium('Celtic Park', 'Glasgow', 'Celtic FC', 60832),
    _Stadium('Ibrox Stadium', 'Glasgow', 'Rangers FC', 51082),
    _Stadium('Estadio Olímpico', 'Roma', 'Lazio/AS Roma', 72698),
    _Stadium('Groupama Stadium', 'Lyon', 'Olympique Lyonnais', 59186),
    _Stadium('Stade Vélodrome', 'Marsella', 'Olympique Marseille', 67394),
    _Stadium('Tottenham Hotspur Stadium', 'Londres', 'Tottenham Hotspur', 62850),
    _Stadium('Villa Park', 'Birmingham', 'Aston Villa', 42682),
    _Stadium('Goodison Park', 'Liverpool', 'Everton FC', 39572),
    _Stadium("St James' Park", 'Newcastle', 'Newcastle United', 52305),
    _Stadium('London Stadium', 'Londres', 'West Ham United', 62500),
    _Stadium('De Kuip', 'Róterdam', 'Feyenoord', 51177),
    _Stadium('Philips Stadion', 'Eindhoven', 'PSV Eindhoven', 35000),
    _Stadium('Estadio Akron', 'Guadalajara', 'Chivas Guadalajara', 49145),
    _Stadium('Morumbis', 'São Paulo', 'São Paulo FC', 72039),
    _Stadium('Vila Belmiro', 'Santos', 'Santos FC', 16068),
    _Stadium('Cairo International Stadium', 'El Cairo', 'Al Ahly/Zamalek', 75000),
    _Stadium('Rams Park', 'Estambul', 'Galatasaray', 53062),
    _Stadium('Stade Mohamed V', 'Casablanca', 'Raja Casablanca/Wydad', 67000),
    _Stadium('BayArena', 'Leverkusen', 'Bayer Leverkusen', 30210),
    _Stadium('Borussia-Park', 'Mönchengladbach', 'Borussia Mönchengladbach', 54057),
  ];

  static final List<_HistoryFact> historyFacts = [
    _HistoryFact('Brasil ganó su primer Mundial en 1958 en Suecia', '1958', 'Brasil'),
    _HistoryFact('El Mundial de 1970 fue el primero transmitido en color', '1970', 'México'),
    _HistoryFact('La Eurocopa de 1992 la ganó Dinamarca sin haberse clasificado', '1992', 'Dinamarca'),
    _HistoryFact('El Real Madrid ganó las 5 primeras Copas de Europa', '1956-1960', 'Real Madrid'),
    _HistoryFact('Hungría llegó a la final del Mundial de 1954 y perdió contra Alemania', '1954', 'Hungría'),
    _HistoryFact('El Milán de Arrigo Sacchi ganó 3 Copas de Europa en los 90', '1989-1994', 'AC Milan'),
    _HistoryFact('La Copa del Mundo de 2014 fue la primera con tecnología goal-line', '2014', 'Brasil'),
    _HistoryFact('El FC Barcelona ganó el sextete en 2009', '2009', 'FC Barcelona'),
    _HistoryFact('Alemania ganó su primer Mundial como unificada en 1990', '1990', 'Alemania'),
    _HistoryFact('La FA Cup es el torneo de fútbol más antiguo del mundo', '1871', 'Inglaterra'),
    _HistoryFact('Uruguay ganó el primer Mundial de la historia en 1930', '1930', 'Uruguay'),
    _HistoryFact('La UEFA Champions League originalmente se llamaba Copa de Europa', '1955', 'Europa'),
    _HistoryFact('Italia ganó el Mundial de 1934 y 1938 de forma consecutiva', '1934-1938', 'Italia'),
    _HistoryFact('El Leeds United ganó la última First Division antes de la Premier League', '1992', 'Leeds United'),
    _HistoryFact('La final de la Champions 2005 es conocida como el Milagro de Estambul', '2005', 'Liverpool'),
    _HistoryFact('Argentina no ganó un título oficial entre 1993 y 2021', '1993-2021', 'Argentina'),
    _HistoryFact('El Bayern Munich ganó 6 títulos en 2020 (sextete)', '2020', 'Bayern Munich'),
    _HistoryFact('La Copa América de 2016 se llamó Copa América Centenario', '2016', 'Estados Unidos'),
  ];

  static final List<_Rule> rules = [
    _Rule('Un partido dura 90 minutos en dos tiempos de 45', '90'),
    _Rule('Una tarjeta roja directa significa expulsión inmediata', 'Roja'),
    _Rule('El fuera de juego se sanciona cuando un jugador está más cerca del arco que el penúltimo defensor', 'Fuera de juego'),
    _Rule('Un penal se sanciona por falta dentro del área', 'Penal'),
    _Rule('El VAR se usa para revisar decisiones claras y manifiestas', 'VAR'),
    _Rule('Un partido puede tener un máximo de 5 cambios por equipo', '5'),
    _Rule('La regla del gol de visitante ya no aplica en competiciones UEFA', '2021'),
    _Rule('El saque de banda se realiza con ambas manos desde detrás de la cabeza', 'Saque de banda'),
    _Rule('Un arquero no puede tocar el balón con la mano fuera del área', 'Arquero'),
    _Rule('Si un partido termina empatado en eliminación directa, va a tiempo extra', 'Tiempo extra'),
    _Rule('El tiempo extra son dos periodos de 15 minutos', '30 minutos'),
    _Rule('Si persiste el empate tras tiempo extra, se define por penales', 'Penales'),
    _Rule('La pelota debe estar completamente cruzando la línea para ser gol', 'Gol'),
    _Rule('Un jugador puede ser amonestado con tarjeta amarilla por conducta antideportiva', 'Amarilla'),
    _Rule('Dos tarjetas amarillas en un partido resultan en tarjeta roja', 'Dos amarillas'),
    _Rule('El tiro de esquina se ejecuta desde el banderín de córner', 'Tiro de esquina'),
    _Rule('El tiro libre indirecto requiere que otro jugador toque el balón antes de gol', 'Indirecto'),
  ];

  static final List<_Statistic> statistics = [
    _Statistic('Cristiano Ronaldo', 'más goles en la historia del fútbol', '900+'),
    _Statistic('Lionel Messi', 'más Balones de Oro', '8'),
    _Statistic('Iker Casillas', 'más porterías a cero en Champions', '57'),
    _Statistic('Cristiano Ronaldo', 'más goles en Champions League', '140'),
    _Statistic('Lionel Messi', 'más goles en un año natural', '91'),
    _Statistic('Brasil', 'más Mundiales ganados', '5'),
    _Statistic('Real Madrid', 'más Champions League ganadas', '15'),
    _Statistic('Johan Cruyff', 'más Balones de Oro ganó en Países Bajos', '3'),
    _Statistic('Xavi Hernández', 'más pases completados en un Mundial', '2010'),
    _Statistic('Miroslav Klose', 'más goles en Mundiales', '16'),
    _Statistic('Lionel Messi', 'más goles en un club (FC Barcelona)', '672'),
    _Statistic('Pelé', 'más joven en ganar un Mundial', '17 años'),
    _Statistic('Roger Milla', 'más veterano en marcar en un Mundial', '42 años'),
    _Statistic('Antoine Griezmann', 'más partidos consecutivos jugados', '84'),
    _Statistic('Paolo Maldini', 'más finales de Champions jugadas', '8'),
    _Statistic('Lev Yashin', 'único arquero en ganar el Balón de Oro', '1963'),
    _Statistic('Lionel Messi', 'más asistencias en la historia', '350+'),
    _Statistic('Cristiano Ronaldo', 'más goles de cabeza en Champions', '28'),
    _Statistic('Gianluigi Buffon', 'más minutos sin recibir gol en Serie A', '973'),
  ];
}

class _Team {
  final String name;
  final String country;
  final String league;
  final int founded;
  final String stadium;
  const _Team(this.name, this.country, this.league, this.founded, this.stadium);
}

class _Player {
  final String name;
  final String nationality;
  final String position;
  final int ballonDor;
  final String knownFor;
  const _Player(this.name, this.nationality, this.position, this.ballonDor, this.knownFor);
}

class _Competition {
  final String name;
  final String type;
  final int firstEdition;
  final String frequency;
  final int trophyCount;
  const _Competition(this.name, this.type, this.firstEdition, this.frequency, this.trophyCount);
}

class _Stadium {
  final String name;
  final String city;
  final String homeTeam;
  final int capacity;
  const _Stadium(this.name, this.city, this.homeTeam, this.capacity);
}

class _HistoryFact {
  final String fact;
  final String year;
  final String subject;
  const _HistoryFact(this.fact, this.year, this.subject);
}

class _Rule {
  final String rule;
  final String keyword;
  const _Rule(this.rule, this.keyword);
}

class _Statistic {
  final String subject;
  final String record;
  final String value;
  const _Statistic(this.subject, this.record, this.value);
}
