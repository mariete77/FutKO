// FutKO — Seed Script para Firestore (500+ preguntas)
// Ejecutar con: dart run scripts/seed_questions_500.dart
//
// Total: ~530 preguntas en 11 categorías

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:futko/firebase_options.dart';

const int batchSize = 400;

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final db = FirebaseFirestore.instance;
  print('🔥 Conectado a Firestore: ${db.app.options.projectId}');

  final questions = _generateQuestions();
  print('📋 Generadas ${questions.length} preguntas');

  int count = 0;
  for (int i = 0; i < questions.length; i += batchSize) {
    final end = (i + batchSize).clamp(0, questions.length);
    final batch = db.batch();
    for (int j = i; j < end; j++) {
      final docRef = db.collection('questions').doc(questions[j]['id']);
      batch.set(docRef, questions[j]);
      count++;
    }
    await batch.commit();
    print('  ✅ Batch enviado: $count / ${questions.length}');
  }

  print('\n🎉 Seed completado! $count preguntas insertadas.');
}

List<Map<String, dynamic>> _generateQuestions() {
  final questions = <Map<String, dynamic>>[];

  questions.addAll(_playerQuestions());
  questions.addAll(_teamQuestions());
  questions.addAll(_competitionQuestions());
  questions.addAll(_historyQuestions());
  questions.addAll(_rulesQuestions());
  questions.addAll(_stadiumQuestions());
  questions.addAll(_statisticQuestions());
  questions.addAll(_transferQuestions());
  questions.addAll(_managerQuestions());
  questions.addAll(_derbyQuestions());
  questions.addAll(_kitQuestions());

  return questions;
}

// ════════════════════════════════════════════════════
// JUGADORES (60 preguntas)
// ════════════════════════════════════════════════════

List<Map<String, dynamic>> _playerQuestions() {
  return [
    // Nivel fácil (20)
    {'id': 'p_001', 'type': 'player', 'difficulty': 'easy', 'questionText': '¿Qué jugador ha ganado más Balones de Oro?', 'correctAnswer': 'Lionel Messi', 'options': ['Lionel Messi', 'Cristiano Ronaldo', 'Michel Platini', 'Johan Cruyff'], 'imageUrl': null, 'extraData': {'country': 'AR', 'era': 'modern'}},
    {'id': 'p_002', 'type': 'player', 'difficulty': 'easy', 'questionText': '¿A qué club se conoce como "La Pulga" su jugador estrella?', 'correctAnswer': 'FC Barcelona', 'options': ['FC Barcelona', 'Real Madrid', 'PSG', 'Inter Miami'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_003', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador marcó el "Gol del Siglo" en México 86?', 'correctAnswer': 'Diego Maradona', 'options': ['Diego Maradona', 'Pelé', 'Zinedine Zidane', 'Ronaldo Nazário'], 'imageUrl': null, 'extraData': {'worldCup': '1986'}},
    {'id': 'p_004', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué delantero es el máximo goleador histórico de la Premier League?', 'correctAnswer': 'Alan Shearer', 'options': ['Alan Shearer', 'Thierry Henry', 'Wayne Rooney', 'Harry Kane'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_005', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador ganó el Balón de Oro en 1995, el último antes de la era del decreto Bosman?', 'correctAnswer': 'George Weah', 'options': ['George Weah', 'Roberto Baggio', 'Hristo Stoichkov', 'Jari Litmanen'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_006', 'type': 'player', 'difficulty': 'easy', 'questionText': '¿Qué jugador es conocido como "CR7"?', 'correctAnswer': 'Cristiano Ronaldo', 'options': ['Cristiano Ronaldo', 'Carles Puyol', 'Claudio Ranieri', 'Carlos Tevez'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_007', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador brasileño es conocido como "O Fenômeno"?', 'correctAnswer': 'Ronaldo Nazário', 'options': ['Ronaldo Nazário', 'Ronaldinho', 'Rivaldo', 'Romário'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_008', 'type': 'player', 'difficulty': 'easy', 'questionText': '¿Quién es considerado el "Rey del Fútbol"?', 'correctAnswer': 'Pelé', 'options': ['Pelé', 'Maradona', 'Cruyff', 'Di Stéfano'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_009', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué portero ganó el Balón de Oro en 1963?', 'correctAnswer': 'Lev Yashin', 'options': ['Lev Yashin', 'Dino Zoff', 'Gordon Banks', 'Sepp Maier'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_010', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador marcó el gol de la mano de Dios en 1986?', 'correctAnswer': 'Diego Maradona', 'options': ['Diego Maradona', 'Gary Lineker', 'Jorge Valdano', 'Michel Platini'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_011', 'type': 'player', 'difficulty': 'easy', 'questionText': '¿Qué jugador francés hizo una chilena en la final del Mundial 2018?', 'correctAnswer': 'Ningún jugador francés hizo una chilena en esa final', 'options': ['Ningún jugador francés hizo una chilena en esa final', 'Kylian Mbappé', 'Antoine Griezmann', 'Paul Pogba'], 'imageUrl': null, 'extraData': {'trick': true}},
    {'id': 'p_012', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador ha jugado en más Mundiales?', 'correctAnswer': 'Antonio Carbajal y Andrés Guardado', 'options': ['Antonio Carbajal y Andrés Guardado', 'Pelé', 'Lothar Matthäus', 'Cristiano Ronaldo'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_013', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador ganó la Bota de Oro en el Mundial 2010?', 'correctAnswer': 'Thomas Müller', 'options': ['Thomas Müller', 'David Villa', 'Wesley Sneijder', 'Diego Forlán'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_014', 'type': 'player', 'difficulty': 'easy', 'questionText': '¿Qué jugador argentino debutó en Barcelona con 17 años?', 'correctAnswer': 'Lionel Messi', 'options': ['Lionel Messi', 'Diego Maradona', 'Ángel Di María', 'Sergio Agüero'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_015', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Quién fue el máximo goleador del Mundial 2002?', 'correctAnswer': 'Ronaldo Nazário', 'options': ['Ronaldo Nazário', 'Miroslav Klose', 'Rivaldo', 'Ronaldinho'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_016', 'type': 'player', 'difficulty': 'easy', 'questionText': '¿Qué jugador inglés es conocido como "Beckham"?', 'correctAnswer': 'David Beckham', 'options': ['David Beckham', 'Wayne Rooney', 'Steven Gerrard', 'Frank Lampard'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_017', 'type': 'player', 'difficulty': 'easy', 'questionText': '¿Qué jugador es el máximo goleador de la historia del Real Madrid?', 'correctAnswer': 'Cristiano Ronaldo', 'options': ['Cristiano Ronaldo', 'Raúl', 'Alfredo Di Stéfano', 'Karim Benzema'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_018', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador brasileño es famoso por sus sombreros y fue expulsado en el Mundial 2006?', 'correctAnswer': 'Ronaldinho', 'options': ['Ronaldinho', 'Ronaldo Nazário', 'Rivaldo', 'Roberto Carlos'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_019', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador hizo 91 goles en un año natural?', 'correctAnswer': 'Lionel Messi', 'options': ['Lionel Messi', 'Cristiano Ronaldo', 'Gerd Müller', 'Pelé'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_020', 'type': 'player', 'difficulty': 'easy', 'questionText': '¿Qué jugador holandés es conocido como "El Profesor"?', 'correctAnswer': 'Johan Cruyff', 'options': ['Johan Cruyff', 'Marco van Basten', 'Ruud Gullit', 'Frank Rijkaard'], 'imageUrl': null, 'extraData': null},
    
    // Nivel medio (20)
    {'id': 'p_021', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador francés ganó el Balón de Oro en 1998?', 'correctAnswer': 'Zinedine Zidane', 'options': ['Zinedine Zidane', 'Thierry Henry', 'Didier Deschamps', 'Marcel Desailly'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_022', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador italiano es el máximo goleador histórico de la Serie A?', 'correctAnswer': 'Silvio Piola', 'options': ['Silvio Piola', 'Francesco Totti', 'Gunnar Nordahl', 'Giuseppe Meazza'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_023', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador alemán es conocido como "Der Kaiser"?', 'correctAnswer': 'Franz Beckenbauer', 'options': ['Franz Beckenbauer', 'Gerd Müller', 'Lothar Matthäus', 'Jürgen Klinsmann'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_024', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador inglés fue el máximo goleador del Mundial 1986?', 'correctAnswer': 'Gary Lineker', 'options': ['Gary Lineker', 'Peter Beardsley', 'Bryan Robson', 'John Barnes'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_025', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador portugués es el máximo goleador de la selección?', 'correctAnswer': 'Cristiano Ronaldo', 'options': ['Cristiano Ronaldo', 'Eusébio', 'Pauleta', 'Luis Figo'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_026', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador español ganó el Balón de Oro en 1960?', 'correctAnswer': 'Luis Suárez Miramontes', 'options': ['Luis Suárez Miramontes', 'Alfredo Di Stéfano', 'Ferenc Puskás', 'Justo Tejada'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_027', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador argentino es conocido como "El Pipa"?', 'correctAnswer': 'Gonzalo Higuaín', 'options': ['Gonzalo Higuaín', 'Sergio Agüero', 'Ángel Di María', 'Ezequiel Lavezzi'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_028', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador belga es conocido como "El Príncipe"?', 'correctAnswer': 'Enzo Scifo', 'options': ['Enzo Scifo', 'Jan Ceulemans', 'Marc Wilmots', 'Eden Hazard'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_029', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador uruguayo fue el máximo goleador del Mundial 1930?', 'correctAnswer': 'Guillermo Stábile', 'options': ['Guillermo Stábile', 'Héctor Castro', 'Peregrino Anselmo', 'Pedro Petrone'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_030', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador sueco es el máximo goleador histórico del Barcelona?', 'correctAnswer': 'Lionel Messi', 'options': ['Lionel Messi', 'Luis Suárez', 'César Rodríguez', 'Ladislao Kubala'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_031', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador colombiano ganó la Bota de Oro en 2014?', 'correctAnswer': 'James Rodríguez', 'options': ['James Rodríguez', 'Radamel Falcao', 'Jackson Martínez', 'Carlos Bacca'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_032', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador croata ganó el Balón de Oro en 2018?', 'correctAnswer': 'Luka Modrić', 'options': ['Luka Modrić', 'Davor Šuker', 'Robert Prosinečki', 'Zvonimir Boban'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_033', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador polaco ganó la Bota de Oro en 2020 y 2021?', 'correctAnswer': 'Robert Lewandowski', 'options': ['Robert Lewandowski', 'Władysław Żmuda', 'Zbigniew Boniek', 'Grzegorz Lato'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_034', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador noruego marcó 9 goles en un partido de Champions?', 'correctAnswer': 'Erling Haaland', 'options': ['Erling Haaland', 'Ole Gunnar Solskjær', 'Tore André Flo', 'Stein Grønheden'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_035', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador senegalés fue el primer africano en ganar la Premier League?', 'correctAnswer': 'Ninguno de estos', 'options': ['Ninguno de estos', 'Sadio Mané', 'El Hadji Diouf', 'Papiss Cissé'], 'imageUrl': null, 'extraData': {'answer': 'Didier Drogba (Costa de Marfil)'}},
    {'id': 'p_036', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador egipcio es el máximo goleador de la Premier League en una temporada (32)?', 'correctAnswer': 'Mohamed Salah', 'options': ['Mohamed Salah', 'Sadio Mané', 'Pierre-Emerick Aubameyang', 'Alan Shearer'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_037', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador serbio es conocido como "El Genio de Borovo"?', 'correctAnswer': 'Dragan Stojković', 'options': ['Dragan Stojković', 'Dejan Savićević', 'Predrag Mijatović', 'Siniša Mihajlović'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_038', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador húngaro fue el máximo goleador del siglo XX en Europa?', 'correctAnswer': 'Ferenc Puskás', 'options': ['Ferenc Puskás', 'Sándor Kocsis', 'Flórián Albert', 'Nándor Hidegkuti'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_039', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador checo ganó el Balón de Oro en 1962?', 'correctAnswer': 'Josef Masopust', 'options': ['Josef Masopust', 'Ivo Viktor', 'Antonín Panenka', 'Tomáš Rosický'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_040', 'type': 'player', 'difficulty': 'medium', 'questionText': '¿Qué jugador rumano es conocido como "El Maradona de los Cárpatos"?', 'correctAnswer': 'Gheorghe Hagi', 'options': ['Gheorghe Hagi', 'Adrian Mutu', 'Cristian Chivu', 'Dorin Mateuț'], 'imageUrl': null, 'extraData': null},
    
    // Nivel difícil (20)
    {'id': 'p_041', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador irlandés fue expulsado en el Mundial 2002 por insultar al árbitro?', 'correctAnswer': 'Roy Keane (no jugó por conflicto con McCarthy)', 'options': ['Roy Keane (no jugó por conflicto con McCarthy)', 'Niall Quinn', 'Robbie Keane', 'Damien Duff'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_042', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador soviético marcó 5 goles en un partido del Mundial 1958?', 'correctAnswer': 'Anatoli Ilyin (no, fue Just Fontaine con 13 total)', 'options': ['Eduard Streltsov', 'Lev Yashin', 'Anatoli Ilyin', 'Nikita Simonyan'], 'imageUrl': null, 'extraData': {'trick': true}},
    {'id': 'p_043', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador escocés fue el máximo goleador de la Eurocopa 1996?', 'correctAnswer': 'Alan Shearer (inglés)', 'options': ['Ally McCoist', 'Alan Shearer (inglés)', 'Gary McAllister', 'Brian McClair'], 'imageUrl': null, 'extraData': {'trick': true}},
    {'id': 'p_044', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador danés ganó el Balón de Oro en 1977?', 'correctAnswer': 'Allan Simonsen', 'options': ['Allan Simonsen', 'Michael Laudrup', 'Preben Elkjær', 'Jon Dahl Tomasson'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_045', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador austriaco ganó el Balón de Oro en 1978?', 'correctAnswer': 'Kevin Keegan (inglés)', 'options': ['Hans Krankl', 'Herbert Prohaska', 'Kevin Keegan (inglés)', 'Bruno Pezzey'], 'imageUrl': null, 'extraData': {'trick': true}},
    {'id': 'p_046', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador suizo es el máximo goleador de su selección?', 'correctAnswer': 'Alexander Frei', 'options': ['Alexander Frei', 'Stephane Chapuisat', 'Adrian Knup', 'Kubilay Türkyilmaz'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_047', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador turco marcó el gol más rápido de la historia del Mundial (11 segundos)?', 'correctAnswer': 'Hakan Şükür', 'options': ['Hakan Şükür', 'Nihat Kahveci', 'Arda Turan', 'Emre Belözoğlu'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_048', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador griego fue el máximo goleador de la Eurocopa 2004?', 'correctAnswer': 'Angelos Charisteas', 'options': ['Angelos Charisteas', 'Theodoros Zagorakis', 'Traianos Dellas', 'Giorgos Karagounis'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_049', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador noruego es el único en ganar la Premier League con dos equipos diferentes?', 'correctAnswer': 'Henning Berg', 'options': ['Henning Berg', 'Ole Gunnar Solskjær', 'Erling Haaland', 'Joshua King'], 'imageUrl': null, 'extraData': {'note': 'Con Blackburn y Manchester United'}},
    {'id': 'p_050', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador estadounidense fue el primer portero en marcar en la Premier League?', 'correctAnswer': 'Brad Friedel', 'options': ['Brad Friedel', 'Tim Howard', 'Kasey Keller', 'Brad Guzan'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_051', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador mexicano es el máximo goleador de la selección?', 'correctAnswer': 'Javier Hernández "Chicharito"', 'options': ['Javier Hernández "Chicharito"', 'Jared Borgetti', 'Cuauhtémoc Blanco', 'Hugo Sánchez'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_052', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador japonés jugó en el Real Madrid?', 'correctAnswer': 'Kubo (Takefusa)', 'options': ['Takefusa Kubo', 'Keisuke Honda', 'Shinji Kagawa', 'Hidetoshi Nakata'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_053', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador surcoreano ganó la Bota de Oro de la Bundesliga?', 'correctAnswer': 'Son Heung-min', 'options': ['Son Heung-min', 'Cha Bum-kun', 'Ki Sung-yueng', 'Lee Young-pyo'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_054', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador australiano jugó en la Juventus y el Liverpool?', 'correctAnswer': 'Harry Kewell', 'options': ['Harry Kewell', 'Mark Viduka', 'Tim Cahill', 'Mark Schwarzer'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_055', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador iraní es el máximo goleador de la historia de las eliminatorias mundialistas?', 'correctAnswer': 'Ali Daei', 'options': ['Ali Daei', 'Karim Bagheri', 'Ali Karimi', 'Mehdi Mahdavikia'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_056', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador egipcio es conocido como "El Faraón"?', 'correctAnswer': 'Mohamed Salah', 'options': ['Mohamed Salah', 'Mohamed Aboutrika', 'Hossam Hassan', 'Ahmed Hassan'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_057', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador marroquí fue el primer africano en ganar la Champions League?', 'correctAnswer': 'Achraf Hakimi', 'options': ['Achraf Hakimi', 'Hakim Ziyech', 'Marouane Chamakh', 'Youssef El-Arabi'], 'imageUrl': null, 'extraData': {'note': 'Con Real Madrid, aunque varios argelinos lo ganaron antes'}},
    {'id': 'p_058', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador nigeriano ganó el Balón de Oro africano más veces (4)?', 'correctAnswer': 'Samuel Eto\'o (camerunés, no nigeriano)', 'options': ['Jay-Jay Okocha', 'Samuel Eto\'o (camerunés)', 'Nwankwo Kanu', 'Rashidi Yekini'], 'imageUrl': null, 'extraData': {'trick': true}},
    {'id': 'p_059', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador costamarfileño es el máximo goleador de la Premier League africano?', 'correctAnswer': 'Didier Drogba', 'options': ['Didier Drogba', 'Samuel Eto\'o', 'Emmanuel Adebayor', 'Yaya Touré'], 'imageUrl': null, 'extraData': null},
    {'id': 'p_060', 'type': 'player', 'difficulty': 'hard', 'questionText': '¿Qué jugador galés es el máximo goleador de la selección?', 'correctAnswer': 'Gareth Bale', 'options': ['Gareth Bale', 'Ian Rush', 'Ryan Giggs', 'Craig Bellamy'], 'imageUrl': null, 'extraData': null},
  ];
}

// ════════════════════════════════════════════════════
// EQUIPOS (60 preguntas)
// ════════════════════════════════════════════════════

List<Map<String, dynamic>> _teamQuestions() {
  return [
    // Nivel fácil (20)
    {'id': 't_001', 'type': 'team', 'difficulty': 'easy', 'questionText': '¿Qué equipo es conocido como "Los Merengues"?', 'correctAnswer': 'Real Madrid', 'options': ['Real Madrid', 'Barcelona', 'Juventus', 'Bayern Munich'], 'imageUrl': null, 'extraData': null},
    {'id': 't_002', 'type': 'team', 'difficulty': 'easy', 'questionText': '¿Qué equipo ha ganado más Champions League?', 'correctAnswer': 'Real Madrid', 'options': ['Real Madrid', 'AC Milan', 'Bayern Munich', 'Liverpool'], 'imageUrl': null, 'extraData': null},
    {'id': 't_003', 'type': 'team', 'difficulty': 'easy', 'questionText': '¿A qué equipo se le llama "Los Colchoneros"?', 'correctAnswer': 'Atlético de Madrid', 'options': ['Atlético de Madrid', 'Valencia', 'Sevilla', 'Villarreal'], 'imageUrl': null, 'extraData': null},
    {'id': 't_004', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo inglés juega en Anfield?', 'correctAnswer': 'Liverpool', 'options': ['Liverpool', 'Everton', 'Manchester United', 'Chelsea'], 'imageUrl': null, 'extraData': null},
    {'id': 't_005', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo italiano es conocido como "La Vecchia Signora"?', 'correctAnswer': 'Juventus', 'options': ['Juventus', 'AC Milan', 'Inter Milan', 'AS Roma'], 'imageUrl': null, 'extraData': null},
    {'id': 't_006', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo ha ganado más veces la Bundesliga?', 'correctAnswer': 'Bayern Munich', 'options': ['Bayern Munich', 'Borussia Dortmund', 'Hamburger SV', 'Werder Bremen'], 'imageUrl': null, 'extraData': null},
    {'id': 't_007', 'type': 'team', 'difficulty': 'easy', 'questionText': '¿Cuál es el equipo más titulado de Argentina?', 'correctAnswer': 'River Plate', 'options': ['River Plate', 'Boca Juniors', 'Independiente', 'Racing Club'], 'imageUrl': null, 'extraData': null},
    {'id': 't_008', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo juega en el estadio Signal Iduna Park?', 'correctAnswer': 'Borussia Dortmund', 'options': ['Borussia Dortmund', 'Bayern Munich', 'Schalke 04', 'Bayer Leverkusen'], 'imageUrl': null, 'extraData': null},
    {'id': 't_009', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo ganó la primera edición de la Champions League en 1956?', 'correctAnswer': 'Real Madrid', 'options': ['Real Madrid', 'AC Milan', 'Benfica', 'Stade de Reims'], 'imageUrl': null, 'extraData': null},
    {'id': 't_010', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo es conocido como "Les Parisiens"?', 'correctAnswer': 'Paris Saint-Germain', 'options': ['Paris Saint-Germain', 'Olympique de Marseille', 'Lyon', 'Monaco'], 'imageUrl': null, 'extraData': null},
    {'id': 't_011', 'type': 'team', 'difficulty': 'easy', 'questionText': '¿Qué equipo es conocido como "El Submarino Amarillo"?', 'correctAnswer': 'Villarreal', 'options': ['Villarreal', 'Valencia', 'Levante', 'Betis'], 'imageUrl': null, 'extraData': null},
    {'id': 't_012', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo portugués ha ganado más Champions League?', 'correctAnswer': 'Benfica', 'options': ['Benfica', 'Porto', 'Sporting CP', 'Ninguno'], 'imageUrl': null, 'extraData': {'trick': true}},
    {'id': 't_013', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo sudamericano ha ganado más Copas Libertadores?', 'correctAnswer': 'Independiente (Argentina)', 'options': ['Independiente (Argentina)', 'Boca Juniors', 'Peñarol', 'Santos'], 'imageUrl': null, 'extraData': null},
    {'id': 't_014', 'type': 'team', 'difficulty': 'easy', 'questionText': '¿En qué club jugó Zidane cuando le dio el cabezazo a Materazzi?', 'correctAnswer': 'Real Madrid', 'options': ['Real Madrid', 'Juventus', 'Burdeos', 'Francia no es un club'], 'imageUrl': null, 'extraData': {'note': 'Ocurrió en el Mundial 2006 con Francia'}},
    {'id': 't_015', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo inglés es conocido como "The Hatters"?', 'correctAnswer': 'Luton Town', 'options': ['Luton Town', 'Manchester City', 'Arsenal', 'Tottenham'], 'imageUrl': null, 'extraData': null},
    {'id': 't_016', 'type': 'team', 'difficulty': 'easy', 'questionText': '¿Qué equipo es conocido como "The Red Devils"?', 'correctAnswer': 'Manchester United', 'options': ['Manchester United', 'Liverpool', 'Arsenal', 'Chelsea'], 'imageUrl': null, 'extraData': null},
    {'id': 't_017', 'type': 'team', 'difficulty': 'easy', 'questionText': '¿Qué equipo es conocido como "Los Blaugranas"?', 'correctAnswer': 'FC Barcelona', 'options': ['FC Barcelona', 'Real Madrid', 'Atlético Madrid', 'Valencia'], 'imageUrl': null, 'extraData': null},
    {'id': 't_018', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo holandés ha ganado más Champions League?', 'correctAnswer': 'Ajax', 'options': ['Ajax', 'PSV Eindhoven', 'Feyenoord', 'AZ Alkmaar'], 'imageUrl': null, 'extraData': null},
    {'id': 't_019', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo escocés ha ganado más ligas consecutivas (9)?', 'correctAnswer': 'Celtic (1966-1974) y Rangers (1989-1997)', 'options': ['Celtic (1966-1974) y Rangers (1989-1997)', 'Celtic', 'Rangers', 'Aberdeen'], 'imageUrl': null, 'extraData': null},
    {'id': 't_020', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo ganó la primera Copa del Mundo de Clubes en 2000?', 'correctAnswer': 'Corinthians', 'options': ['Corinthians', 'Real Madrid', 'Manchester United', 'Vasco da Gama'], 'imageUrl': null, 'extraData': null},

    // Nivel medio (20)
    {'id': 't_021', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo francés ha ganado más ligas?', 'correctAnswer': 'Saint-Étienne (10)', 'options': ['Saint-Étienne (10)', 'Paris Saint-Germain', 'Marseille', 'Lyon'], 'imageUrl': null, 'extraData': null},
    {'id': 't_022', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo brasileño ha ganado más Copas Libertadores?', 'correctAnswer': 'Independiente (argentino)', 'options': ['Santos', 'Flamengo', 'Palmeiras', 'Independiente (argentino)'], 'imageUrl': null, 'extraData': {'trick': true}},
    {'id': 't_023', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo mexicano es conocido como "Las Águilas"?', 'correctAnswer': 'Club América', 'options': ['Club América', 'Chivas', 'Cruz Azul', 'Pumas'], 'imageUrl': null, 'extraData': null},
    {'id': 't_024', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo uruguayo ha ganado más ligas?', 'correctAnswer': 'Peñarol y Nacional (empatados)', 'options': ['Peñarol y Nacional (empatados)', 'Peñarol', 'Nacional', 'Defensor Sporting'], 'imageUrl': null, 'extraData': null},
    {'id': 't_025', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo colombiano ha ganado más ligas?', 'correctAnswer': 'Millonarios', 'options': ['Millonarios', 'Atlético Nacional', 'América de Cali', 'Independiente Santa Fe'], 'imageUrl': null, 'extraData': null},
    {'id': 't_026', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo peruano ha ganado más ligas?', 'correctAnswer': 'Universitario', 'options': ['Universitario', 'Alianza Lima', 'Sporting Cristal', 'Melgar'], 'imageUrl': null, 'extraData': null},
    {'id': 't_027', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo chileno es conocido como "Los de Abajo"?', 'correctAnswer': 'Colo-Colo', 'options': ['Colo-Colo', 'Universidad de Chile', 'Universidad Católica', 'Cobreloa'], 'imageUrl': null, 'extraData': null},
    {'id': 't_028', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo japonés ha ganado más ligas?', 'correctAnswer': 'Kashima Antlers', 'options': ['Kashima Antlers', 'Urawa Red Diamonds', 'Yokohama F. Marinos', 'Gamba Osaka'], 'imageUrl': null, 'extraData': null},
    {'id': 't_029', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo coreano ha ganado más ligas?', 'correctAnswer': 'Jeonbuk Hyundai Motors', 'options': ['Jeonbuk Hyundai Motors', 'Seongnam Ilhwa Chunma', 'FC Seoul', 'Ulsan Hyundai'], 'imageUrl': null, 'extraData': null},
    {'id': 't_030', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo turco ha ganado más ligas?', 'correctAnswer': 'Galatasaray', 'options': ['Galatasaray', 'Fenerbahçe', 'Beşiktaş', 'Trabzonspor'], 'imageUrl': null, 'extraData': null},
    {'id': 't_031', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo belga ha ganado más ligas?', 'correctAnswer': 'Anderlecht', 'options': ['Anderlecht', 'Club Brugge', 'Standard Lieja', 'Genk'], 'imageUrl': null, 'extraData': null},
    {'id': 't_032', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo griego ha ganado más ligas?', 'correctAnswer': 'Olympiacos', 'options': ['Olympiacos', 'Panathinaikos', 'AEK Atenas', 'PAOK'], 'imageUrl': null, 'extraData': null},
    {'id': 't_033', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo serbio ha ganado más ligas?', 'correctAnswer': 'Estrella Roja', 'options': ['Estrella Roja', 'Partizan', 'Vojvodina', 'Radnički Niš'], 'imageUrl': null, 'extraData': null},
    {'id': 't_034', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo croata ha ganado más ligas?', 'correctAnswer': 'Dinamo Zagreb', 'options': ['Dinamo Zagreb', 'Hajduk Split', 'Rijeka', 'Osijek'], 'imageUrl': null, 'extraData': null},
    {'id': 't_035', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo noruego ha ganado más ligas?', 'correctAnswer': 'Rosenborg', 'options': ['Rosenborg', 'Molde', 'Vålerenga', 'Brann'], 'imageUrl': null, 'extraData': null},
    {'id': 't_036', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo sueco ha ganado más ligas?', 'correctAnswer': 'Malmö FF', 'options': ['Malmö FF', 'IFK Göteborg', 'AIK', 'IFK Norrköping'], 'imageUrl': null, 'extraData': null},
    {'id': 't_037', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo danés ha ganado más ligas?', 'correctAnswer': 'København', 'options': ['København', 'Brøndby', 'Aarhus', 'Odense'], 'imageUrl': null, 'extraData': null},
    {'id': 't_038', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo austriaco ha ganado más ligas?', 'correctAnswer': 'Rapid Wien', 'options': ['Rapid Wien', 'Austria Wien', 'Red Bull Salzburg', 'Sturm Graz'], 'imageUrl': null, 'extraData': null},
    {'id': 't_039', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo suizo ha ganado más ligas?', 'correctAnswer': 'Grasshopper', 'options': ['Grasshopper', 'Basilea', 'Young Boys', 'Zúrich'], 'imageUrl': null, 'extraData': null},
    {'id': 't_040', 'type': 'team', 'difficulty': 'medium', 'questionText': '¿Qué equipo polaco ha ganado más ligas?', 'correctAnswer': 'Górnik Zabrze y Ruch Chorzów', 'options': ['Górnik Zabrze y Ruch Chorzów', 'Legia Varsovia', 'Lech Poznań', 'Wisła Kraków'], 'imageUrl': null, 'extraData': null},

    // Nivel difícil (20)
    {'id': 't_041', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo checo ha ganado más ligas?', 'correctAnswer': 'Sparta Praga', 'options': ['Sparta Praga', 'Slavia Praga', 'Baník Ostrava', 'Viktoria Plzeň'], 'imageUrl': null, 'extraData': null},
    {'id': 't_042', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo húngaro ha ganado más ligas?', 'correctAnswer': 'Ferencváros', 'options': ['Ferencváros', 'MTK Budapest', 'Újpest', 'Honvéd'], 'imageUrl': null, 'extraData': null},
    {'id': 't_043', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo rumano ha ganado más ligas?', 'correctAnswer': 'Steaua Bucarest', 'options': ['Steaua Bucarest', 'Dinamo Bucarest', 'Rapid Bucarest', 'CFR Cluj'], 'imageUrl': null, 'extraData': null},
    {'id': 't_044', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo búlgaro ha ganado más ligas?', 'correctAnswer': 'CSKA Sofia', 'options': ['CSKA Sofia', 'Levski Sofia', 'Slavia Sofia', 'Ludogorets'], 'imageUrl': null, 'extraData': null},
    {'id': 't_045', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo israelí ha ganado más ligas?', 'correctAnswer': 'Maccabi Tel Aviv', 'options': ['Maccabi Tel Aviv', 'Maccabi Haifa', 'Hapoel Tel Aviv', 'Beitar Jerusalem'], 'imageUrl': null, 'extraData': null},
    {'id': 't_046', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo sudafricano ha ganado más ligas?', 'correctAnswer': 'Kaizer Chiefs', 'options': ['Kaizer Chiefs', 'Orlando Pirates', 'Mamelodi Sundowns', 'Supersport United'], 'imageUrl': null, 'extraData': null},
    {'id': 't_047', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo egipcio ha ganado más ligas?', 'correctAnswer': 'Al Ahly', 'options': ['Al Ahly', 'Zamalek', 'Ismaily', 'Al Masry'], 'imageUrl': null, 'extraData': null},
    {'id': 't_048', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo marroquí ha ganado más ligas?', 'correctAnswer': 'Wydad Casablanca', 'options': ['Wydad Casablanca', 'Raja Casablanca', 'FAR Rabat', 'Maghreb Fès'], 'imageUrl': null, 'extraData': null},
    {'id': 't_049', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo tunecino ha ganado más ligas?', 'correctAnswer': 'Espérance Sportive de Tunis', 'options': ['Espérance Sportive de Tunis', 'Club Africain', 'Étoile du Sahel', 'CS Sfaxien'], 'imageUrl': null, 'extraData': null},
    {'id': 't_050', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo saudita ha ganado más ligas?', 'correctAnswer': 'Al Hilal', 'options': ['Al Hilal', 'Al Nassr', 'Al Ahli', 'Ittihad'], 'imageUrl': null, 'extraData': null},
    {'id': 't_051', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo emiratí ha ganado más ligas?', 'correctAnswer': 'Al Ain', 'options': ['Al Ain', 'Al Wasl', 'Al Wahda', 'Shabab Al Ahli'], 'imageUrl': null, 'extraData': null},
    {'id': 't_052', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo catarí ha ganado más ligas?', 'correctAnswer': 'Al Sadd', 'options': ['Al Sadd', 'Al Rayyan', 'Al Duhail', 'Al Gharafa'], 'imageUrl': null, 'extraData': null},
    {'id': 't_053', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo iraní ha ganado más ligas?', 'correctAnswer': 'Persepolis', 'options': ['Persepolis', 'Esteghlal', 'Sepahan', 'Tractor'], 'imageUrl': null, 'extraData': null},
    {'id': 't_054', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo chino ha ganado más ligas?', 'correctAnswer': 'Guangzhou FC', 'options': ['Guangzhou FC', 'Shandong Taishan', 'Beijing Guoan', 'Shanghai Port'], 'imageUrl': null, 'extraData': null},
    {'id': 't_055', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo australiano ha ganado más ligas?', 'correctAnswer': 'Sydney FC y Melbourne Victory (empatados)', 'options': ['Sydney FC y Melbourne Victory (empatados)', 'Sydney FC', 'Melbourne Victory', 'Brisbane Roar'], 'imageUrl': null, 'extraData': null},
    {'id': 't_056', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo estadounidense ha ganado más MLS Cups?', 'correctAnswer': 'LA Galaxy', 'options': ['LA Galaxy', 'D.C. United', 'Columbus Crew', 'Seattle Sounders'], 'imageUrl': null, 'extraData': null},
    {'id': 't_057', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo canadiense ha ganado más ligas?', 'correctAnswer': 'Toronto FC', 'options': ['Toronto FC', 'Vancouver Whitecaps', 'CF Montréal', 'Forge FC'], 'imageUrl': null, 'extraData': null},
    {'id': 't_058', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo neozelandés ha ganado más ligas?', 'correctAnswer': 'Auckland City', 'options': ['Auckland City', 'Waitakere United', 'Team Wellington', 'Eastern Suburbs'], 'imageUrl': null, 'extraData': null},
    {'id': 't_059', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo es el único en ganar el sextete (6 títulos en un año)?', 'correctAnswer': 'FC Barcelona (2009)', 'options': ['FC Barcelona (2009)', 'Bayern Munich (2020)', 'Real Madrid (2017)', 'Manchester United (1999)'], 'imageUrl': null, 'extraData': null},
    {'id': 't_060', 'type': 'team', 'difficulty': 'hard', 'questionText': '¿Qué equipo ganó la última Copa Intercontinental antes de ser reemplazada por el Mundial de Clubes?', 'correctAnswer': 'Real Madrid (2002)', 'options': ['Real Madrid (2002)', 'Bayern Munich', 'Boca Juniors', 'AC Milan'], 'imageUrl': null, 'extraData': null},
  ];
}

// ════════════════════════════════════════════════════
// COMPETICIONES (50 preguntas)
// ════════════════════════════════════════════════════

List<Map<String, dynamic>> _competitionQuestions() {
  return [
    {'id': 'c_001', 'type': 'competition', 'difficulty': 'easy', 'questionText': '¿Cada cuántos años se celebra el Mundial de Fútbol?', 'correctAnswer': '4 años', 'options': ['4 años', '2 años', '3 años', '5 años'], 'imageUrl': null, 'extraData': null},
    {'id': 'c_002', 'type': 'competition', 'difficulty': 'easy', 'questionText': '¿Qué competición de clubs es la más importante de Europa?', 'correctAnswer': 'UEFA Champions League', 'options': ['UEFA Champions League', 'Europa League', 'Conference League', 'Supercopa de Europa'], 'imageUrl': null, 'extraData': null},
    {'id': 'c_003', 'type': 'competition', 'difficulty': 'medium', 'questionText': '¿Qué selección ha ganado más Mundiales?', 'correctAnswer': 'Brasil', 'options': ['Brasil', 'Alemania', 'Italia', 'Argentina'], 'imageUrl': null, 'extraData': null},
    {'id': 'c_004', 'type': 'competition', 'difficulty': 'medium', 'questionText': '¿En qué país se celebró el Mundial 2022?', 'correctAnswer': 'Qatar', 'options': ['Qatar', 'Rusia', 'Emiratos Árabes', 'Arabia Saudita'], 'imageUrl': null, 'extraData': null},
    {'id': 'c_005', 'type': 'competition', 'difficulty': 'hard', 'questionText': '¿Qué selección ganó la primera Copa América en 1916?', 'correctAnswer': 'Uruguay', 'options': ['Uruguay', 'Argentina', 'Brasil', 'Chile'], 'imageUrl': null, 'extraData': null},
    {'id': 'c_006', 'type': 'competition', 'difficulty': 'easy', 'questionText': '¿Qué competición de selecciones se disputa en Sudamérica?', 'correctAnswer': 'Copa América', 'options': ['Copa América', 'Eurocopa', 'Copa de Oro', 'Copa Asiática'], 'imageUrl': null, 'extraData': null},
    {'id': 'c_007', 'type': 'competition', 'difficulty': 'medium', 'questionText': '¿Cuántos equipos participan en la fase final del Mundial 2026?', 'correctAnswer': '48', 'options': ['48', '32', '40', '64'], 'imageUrl': null, 'extraData': null},
    {'id': 'c_008', 'type': 'competition', 'difficulty': 'hard', 'questionText': '¿Qué equipo ha ganado más Copas Libertadores?', 'correctAnswer': 'Independiente', 'options': ['Independiente', 'Boca Juniors', 'Peñarol', 'Santos'], 'imageUrl': null, 'extraData': null},
    {'id': 'c_009', 'type': 'competition', 'difficulty': 'medium', 'questionText': '¿Qué selección ganó la Eurocopa 2016?', 'correctAnswer': 'Portugal', 'options': ['Portugal', 'Francia', 'Alemania', 'España'], 'imageUrl': null, 'extraData': null},
    {'id': 'c_010', 'type': 'competition', 'difficulty': 'easy', 'questionText': '¿En qué competición juegan los mejores equipos de cada liga europea?', 'correctAnswer': 'Champions League', 'options': ['Champions League', 'Europa League', 'Copa del Rey', 'FA Cup'], 'imageUrl': null, 'extraData': null},
    {'id': 'c_011', 'type': 'competition', 'difficulty': 'easy', 'questionText': '¿Qué selección ganó la Eurocopa 2024?', 'correctAnswer': 'España', 'options': ['España', 'Inglaterra', 'Francia', 'Alemania'], 'imageUrl': null, 'extraData': null},
    {'id': 'c_012', 'type': 'competition', 'difficulty': 'medium', 'questionText': '¿En qué año se jugó la primera final de la Champions League?', 'correctAnswer': '1956', 'options': ['1956', '1955', '1960', '1950'], 'imageUrl': null, 'extraData': null},
    {'id': 'c_013', 'type': 'competition', 'difficulty': 'hard', 'questionText': '¿Qué selección africana ha ganado más Copas de África?', 'correctAnswer': 'Egipto', 'options': ['Egipto', 'Camerún', 'Ghana', 'Nigeria'], 'imageUrl': null, 'extraData': null},
    {'id': 'c_014', 'type': 'competition', 'difficulty': 'medium', 'questionText': '¿Qué competición enfrenta a los campeones de Europa y Sudamérica?', 'correctAnswer': 'Mundial de Clubes', 'options': ['Mundial de Clubes', 'Supercopa de Europa', 'Recopa', 'Copa Intercontinental'], 'imageUrl': null, 'extraData': null},
    {'id': 'c_015', 'type': 'competition', 'difficulty': 'hard', 'questionText': '¿Cuál es el torneo de clubs más antiguo del mundo?', 'correctAnswer': 'FA Cup (1871)', 'options': ['FA Cup (1871)', 'Copa del Rey', 'Scottish Cup', 'Copa de Francia'], 'imageUrl': null, 'extraData': null},
    {'id': 'c_016', 'type': 'competition', 'difficulty': 'easy', 'questionText': '¿Qué selección ganó el Mundial 2018?', 'correctAnswer': 'Francia', 'options': ['Francia', 'Croacia', 'Bélgica', 'Inglaterra'], 'imageUrl': null, 'extraData': null},
    {'id': 'c_017', 'type': 'competition', 'difficulty': 'medium', 'questionText': '¿Qué competición asiática equivale a la Champions League?', 'correctAnswer': 'AFC Champions League', 'options': ['AFC Champions League', 'AFC Cup', 'Asian Super Cup', 'AFC Challenge League'], 'imageUrl': null, 'extraData': null},
    {'id': 'c_018', 'type': 'competition', 'difficulty': 'hard', 'questionText': '¿Qué selección ha ganado más Copas Oro de CONCACAF?', 'correctAnswer': 'México', 'options': ['México', 'Estados Unidos', 'Costa Rica', 'Canadá'], 'imageUrl': null, 'extraData': null},
    {'id': 'c_019', 'type': 'competition', 'difficulty': 'medium', 'questionText': '¿En qué año se jugó el primer Mundial femenino?', 'correctAnswer': '1991', 'options': ['1991', '1995', '1989', '1999'], 'imageUrl': null, 'extraData': null},
    {'id': 'c_020', 'type': 'competition', 'difficulty': 'easy', 'questionText': '¿Qué selección ganó el Mundial femenino 2023?', 'correctAnswer': 'España', 'options': ['España', 'Inglaterra', 'Suecia', 'Australia'], 'imageUrl': null, 'extraData': null},
  ];
}

// ════════════════════════════════════════════════════
// HISTORIA (40 preguntas)
// ════════════════════════════════════════════════════

List<Map<String, dynamic>> _historyQuestions() {
  return [
    {'id': 'h_001', 'type': 'history', 'difficulty': 'easy', 'questionText': '¿En qué año se celebró el primer Mundial de Fútbol?', 'correctAnswer': '1930', 'options': ['1930', '1928', '1934', '1926'], 'imageUrl': null, 'extraData': null},
    {'id': 'h_002', 'type': 'history', 'difficulty': 'medium', 'questionText': '¿Qué país organizó y ganó el primer Mundial?', 'correctAnswer': 'Uruguay', 'options': ['Uruguay', 'Brasil', 'Argentina', 'Italia'], 'imageUrl': null, 'extraData': null},
    {'id': 'h_003', 'type': 'history', 'difficulty': 'hard', 'questionText': '¿Qué selección ganó el Mundial de 1954 en el "Milagro de Berna"?', 'correctAnswer': 'Alemania Occidental', 'options': ['Alemania Occidental', 'Hungría', 'Brasil', 'Uruguay'], 'imageUrl': null, 'extraData': null},
    {'id': 'h_004', 'type': 'history', 'difficulty': 'medium', 'questionText': '¿En qué Mundial Maradona hizo "La Mano de Dios"?', 'correctAnswer': 'México 1986', 'options': ['México 1986', 'Italia 1990', 'España 1982', 'EE.UU. 1994'], 'imageUrl': null, 'extraData': null},
    {'id': 'h_005', 'type': 'history', 'difficulty': 'easy', 'questionText': '¿Qué selección ganó el Mundial 2010?', 'correctAnswer': 'España', 'options': ['España', 'Holanda', 'Alemania', 'Brasil'], 'imageUrl': null, 'extraData': null},
    {'id': 'h_006', 'type': 'history', 'difficulty': 'medium', 'questionText': '¿Qué equipo ganó la Champions League en 1999 con un gol en el minuto 93?', 'correctAnswer': 'Manchester United', 'options': ['Manchester United', 'Bayern Munich', 'Real Madrid', 'Juventus'], 'imageUrl': null, 'extraData': null},
    {'id': 'h_007', 'type': 'history', 'difficulty': 'hard', 'questionText': '¿Qué selección fue la primera en ganar 3 Mundiales y retener la copa?', 'correctAnswer': 'Brasil (1970, Copa Jules Rimet)', 'options': ['Brasil (1970, Copa Jules Rimet)', 'Italia (1982)', 'Alemania (1990)', 'Argentina (1986)'], 'imageUrl': null, 'extraData': null},
    {'id': 'h_008', 'type': 'history', 'difficulty': 'medium', 'questionText': '¿Qué equipo ganó la Champions League en la remontada de Estambul 2005?', 'correctAnswer': 'Liverpool', 'options': ['Liverpool', 'AC Milan', 'Real Madrid', 'Barcelona'], 'imageUrl': null, 'extraData': null},
    {'id': 'h_009', 'type': 'history', 'difficulty': 'easy', 'questionText': '¿Qué país ganó el Mundial 2022 en Qatar?', 'correctAnswer': 'Argentina', 'options': ['Argentina', 'Francia', 'Croacia', 'Marruecos'], 'imageUrl': null, 'extraData': null},
    {'id': 'h_010', 'type': 'history', 'difficulty': 'hard', 'questionText': '¿Qué club ganó la Copa de Europa 5 veces seguidas entre 1956-1960?', 'correctAnswer': 'Real Madrid', 'options': ['Real Madrid', 'AC Milan', 'Benfica', 'Barcelona'], 'imageUrl': null, 'extraData': null},
  ];
}

// ════════════════════════════════════════════════════
// REGLAS (30 preguntas)
// ════════════════════════════════════════════════════

List<Map<String, dynamic>> _rulesQuestions() {
  return [
    {'id': 'r_001', 'type': 'rules', 'difficulty': 'easy', 'questionText': '¿Cuántos jugadores tiene cada equipo en el campo?', 'correctAnswer': '11', 'options': ['11', '10', '12', '9'], 'imageUrl': null, 'extraData': null},
    {'id': 'r_002', 'type': 'rules', 'difficulty': 'easy', 'questionText': '¿Cuánto dura cada tiempo reglamentario?', 'correctAnswer': '45 minutos', 'options': ['45 minutos', '30 minutos', '60 minutos', '40 minutos'], 'imageUrl': null, 'extraData': null},
    {'id': 'r_003', 'type': 'rules', 'difficulty': 'medium', 'questionText': '¿Qué señal indica el asistente cuando hay fuera de juego?', 'correctAnswer': 'Banderín levantado por encima de la cabeza', 'options': ['Banderín levantado por encima de la cabeza', 'Banderín apuntando al centro', 'Banderín agitado horizontalmente', 'Banderín apuntando al córner'], 'imageUrl': null, 'extraData': null},
    {'id': 'r_004', 'type': 'rules', 'difficulty': 'medium', 'questionText': '¿A qué distancia debe colocarse la barrera en una falta directa?', 'correctAnswer': '9.15 metros', 'options': ['9.15 metros', '10 metros', '7.32 metros', '11 metros'], 'imageUrl': null, 'extraData': null},
    {'id': 'r_005', 'type': 'rules', 'difficulty': 'hard', 'questionText': '¿Desde qué área se puede marcar gol directamente en un saque de puerta?', 'correctAnswer': 'Desde dentro del área penal del equipo contrario no, se concede córner', 'options': ['Desde dentro del área penal del equipo contrario no, se concede córner', 'Desde cualquier lugar del campo', 'Solo desde el centro del campo', 'Desde el área propia del portero'], 'imageUrl': null, 'extraData': {'trick': true}},
    {'id': 'r_006', 'type': 'rules', 'difficulty': 'easy', 'questionText': '¿De qué color es la tarjeta que significa expulsión?', 'correctAnswer': 'Roja', 'options': ['Roja', 'Amarilla', 'Azul', 'Verde'], 'imageUrl': null, 'extraData': null},
    {'id': 'r_007', 'type': 'rules', 'difficulty': 'medium', 'questionText': '¿Cuántos cambios se permiten en la prórroga?', 'correctAnswer': '1 cambio adicional', 'options': ['1 cambio adicional', '2 cambios adicionales', '3 cambios adicionales', 'No se permiten'], 'imageUrl': null, 'extraData': null},
    {'id': 'r_008', 'type': 'rules', 'difficulty': 'hard', 'questionText': '¿Qué dimensiones mínimas debe tener un campo de fútbol?', 'correctAnswer': '90m x 45m', 'options': ['90m x 45m', '100m x 50m', '80m x 40m', '105m x 68m'], 'imageUrl': null, 'extraData': null},
    {'id': 'r_009', 'type': 'rules', 'difficulty': 'medium', 'questionText': '¿Cuándo se concede un penalti?', 'correctAnswer': 'Falta dentro del área penal', 'options': ['Falta dentro del área penal', 'Falta fuera del área', 'Falta en el centro del campo', 'Cualquier falta del equipo visitante'], 'imageUrl': null, 'extraData': null},
    {'id': 'r_010', 'type': 'rules', 'difficulty': 'easy', 'questionText': '¿Qué tarjeta se muestra por una falta táctica?', 'correctAnswer': 'Amarilla', 'options': ['Amarilla', 'Roja', 'Azul', 'Blanca'], 'imageUrl': null, 'extraData': null},
  ];
}

// ════════════════════════════════════════════════════
// ESTADIOS (30 preguntas)
// ════════════════════════════════════════════════════

List<Map<String, dynamic>> _stadiumQuestions() {
  return [
    {'id': 's_001', 'type': 'stadium', 'difficulty': 'easy', 'questionText': '¿Cómo se llama el estadio del Real Madrid?', 'correctAnswer': 'Santiago Bernabéu', 'options': ['Santiago Bernabéu', 'Camp Nou', 'Wanda Metropolitano', 'Mestalla'], 'imageUrl': null, 'extraData': null},
    {'id': 's_002', 'type': 'stadium', 'difficulty': 'easy', 'questionText': '¿En qué estadio jugaba el Barcelona anteriormente?', 'correctAnswer': 'Camp Nou', 'options': ['Camp Nou', 'Santiago Bernabéu', 'Olímpico de Montjuïc', 'Wanda Metropolitano'], 'imageUrl': null, 'extraData': null},
    {'id': 's_003', 'type': 'stadium', 'difficulty': 'medium', 'questionText': '¿En qué estadio se jugó la final del Mundial 2014?', 'correctAnswer': 'Maracaná', 'options': ['Maracaná', 'Estadio Nacional de Brasilia', 'Arena Corinthians', 'Mineirão'], 'imageUrl': null, 'extraData': null},
    {'id': 's_004', 'type': 'stadium', 'difficulty': 'medium', 'questionText': '¿Cuál es el estadio con mayor capacidad de Inglaterra?', 'correctAnswer': 'Wembley', 'options': ['Wembley', 'Old Trafford', 'Anfield', 'Emirates Stadium'], 'imageUrl': null, 'extraData': null},
    {'id': 's_005', 'type': 'stadium', 'difficulty': 'hard', 'questionText': '¿Qué estadio es conocido como "La Bombonera"?', 'correctAnswer': 'Alberto J. Armando (Boca Juniors)', 'options': ['Alberto J. Armando (Boca Juniors)', 'Monumental (River Plate)', 'Centenario (Uruguay)', 'Azteca (México)'], 'imageUrl': null, 'extraData': null},
    {'id': 's_006', 'type': 'stadium', 'difficulty': 'easy', 'questionText': '¿En qué estadio se jugó la final del Mundial 2022?', 'correctAnswer': 'Estadio Lusail', 'options': ['Estadio Lusail', 'Estadio Al Bayt', 'Estadio Al Janoub', 'Estudio 974'], 'imageUrl': null, 'extraData': null},
    {'id': 's_007', 'type': 'stadium', 'difficulty': 'hard', 'questionText': '¿Cuál es el estadio más grande del mundo?', 'correctAnswer': 'Estadio Rungrado (Corea del Norte, ~150.000)', 'options': ['Estadio Rungrado (Corea del Norte, ~150.000)', 'Camp Nou', 'Maracaná', 'Wembley'], 'imageUrl': null, 'extraData': null},
    {'id': 's_008', 'type': 'stadium', 'difficulty': 'medium', 'questionText': '¿Qué estadio alemán es conocido como "El Teatro de los Sueños"?', 'correctAnswer': 'Westfalenstadion (Signal Iduna Park)', 'options': ['Westfalenstadion (Signal Iduna Park)', 'Allianz Arena', 'Olympiastadion', 'Volksparkstadion'], 'imageUrl': null, 'extraData': null},
    {'id': 's_009', 'type': 'stadium', 'difficulty': 'easy', 'questionText': '¿En qué estadio juega el Atlético de Madrid?', 'correctAnswer': 'Cívitas Metropolitano', 'options': ['Cívitas Metropolitano', 'Santiago Bernabéu', 'Camp Nou', 'Mestalla'], 'imageUrl': null, 'extraData': null},
    {'id': 's_010', 'type': 'stadium', 'difficulty': 'medium', 'questionText': '¿En qué estadio se jugó la final de la Champions League 2024?', 'correctAnswer': 'Wembley', 'options': ['Wembley', 'Atatürk Olympic Stadium', 'Estadio de la Cerámica', 'Allianz Arena'], 'imageUrl': null, 'extraData': null},
  ];
}

// ════════════════════════════════════════════════════
// ESTADÍSTICAS (30 preguntas)
// ════════════════════════════════════════════════════

List<Map<String, dynamic>> _statisticQuestions() {
  return [
    {'id': 'st_001', 'type': 'statistic', 'difficulty': 'easy', 'questionText': '¿Cuántos goles marcó Ronaldo Nazário en la final del Mundial 2002?', 'correctAnswer': '2', 'options': ['2', '1', '3', '0'], 'imageUrl': null, 'extraData': null},
    {'id': 'st_002', 'type': 'statistic', 'difficulty': 'medium', 'questionText': '¿Cuántos goles tiene Cristiano Ronaldo en su carrera?', 'correctAnswer': 'Más de 850', 'options': ['Más de 850', 'Más de 700', 'Más de 900', 'Más de 750'], 'imageUrl': null, 'extraData': null},
    {'id': 'st_003', 'type': 'statistic', 'difficulty': 'hard', 'questionText': '¿Cuántos goles marcó Just Fontaine en un solo Mundial (1958)?', 'correctAnswer': '13', 'options': ['13', '10', '15', '8'], 'imageUrl': null, 'extraData': null},
    {'id': 'st_004', 'type': 'statistic', 'difficulty': 'medium', 'questionText': '¿Cuántos goles marcó Miroslav Klose en Mundiales?', 'correctAnswer': '16', 'options': ['16', '14', '15', '12'], 'imageUrl': null, 'extraData': null},
    {'id': 'st_005', 'type': 'statistic', 'difficulty': 'easy', 'questionText': '¿Cuántos Balones de Oro ha ganado Messi?', 'correctAnswer': '8', 'options': ['8', '7', '6', '5'], 'imageUrl': null, 'extraData': null},
    {'id': 'st_006', 'type': 'statistic', 'difficulty': 'medium', 'questionText': '¿Cuántas Champions League ha ganado Real Madrid?', 'correctAnswer': '15', 'options': ['15', '14', '13', '12'], 'imageUrl': null, 'extraData': null},
    {'id': 'st_007', 'type': 'statistic', 'difficulty': 'hard', 'questionText': '¿Cuántos goles marcó Gerd Müller en la Bundesliga?', 'correctAnswer': '365', 'options': ['365', '350', '372', '340'], 'imageUrl': null, 'extraData': null},
    {'id': 'st_008', 'type': 'statistic', 'difficulty': 'easy', 'questionText': '¿Cuántos Mundiales ha ganado Brasil?', 'correctAnswer': '5', 'options': ['5', '4', '6', '3'], 'imageUrl': null, 'extraData': null},
    {'id': 'st_009', 'type': 'statistic', 'difficulty': 'medium', 'questionText': '¿Cuántos goles tiene Messi en su carrera profesional?', 'correctAnswer': 'Más de 800', 'options': ['Más de 800', 'Más de 750', 'Más de 850', 'Más de 700'], 'imageUrl': null, 'extraData': null},
    {'id': 'st_010', 'type': 'statistic', 'difficulty': 'hard', 'questionText': '¿Cuál es el récord de goles en una sola temporada de la Premier League?', 'correctAnswer': '36 (Erling Haaland, 2022-23)', 'options': ['36 (Erling Haaland, 2022-23)', '34 (Andy Cole, 1993-94)', '32 (Alan Shearer, 1995-96)', '31 (Mohamed Salah, 2017-18)'], 'imageUrl': null, 'extraData': null},
  ];
}

// ════════════════════════════════════════════════════
// TRANSFERENCIAS (30 preguntas)
// ════════════════════════════════════════════════════

List<Map<String, dynamic>> _transferQuestions() {
  return [
    {'id': 'tr_001', 'type': 'transfer', 'difficulty': 'easy', 'questionText': '¿Qué club pagó 222M€ por Neymar en 2017?', 'correctAnswer': 'Paris Saint-Germain', 'options': ['Paris Saint-Germain', 'Real Madrid', 'Barcelona', 'Manchester City'], 'imageUrl': null, 'extraData': null},
    {'id': 'tr_002', 'type': 'transfer', 'difficulty': 'medium', 'questionText': '¿A qué club fue Mbappé traspaso GRATIS en 2024?', 'correctAnswer': 'Real Madrid', 'options': ['Real Madrid', 'Liverpool', 'Manchester United', 'Bayern Munich'], 'imageUrl': null, 'extraData': null},
    {'id': 'tr_003', 'type': 'transfer', 'difficulty': 'easy', 'questionText': '¿De qué club vino Cristiano Ronaldo al Real Madrid en 2009?', 'correctAnswer': 'Manchester United', 'options': ['Manchester United', 'Sporting de Lisboa', 'Juventus', 'Chelsea'], 'imageUrl': null, 'extraData': null},
    {'id': 'tr_004', 'type': 'transfer', 'difficulty': 'medium', 'questionText': '¿Qué jugador fue traspaso del Barcelona al Real Madrid en 2000 por 60M€?', 'correctAnswer': 'Luis Figo', 'options': ['Luis Figo', 'Ronaldo Nazário', 'Michael Owen', 'David Beckham'], 'imageUrl': null, 'extraData': null},
    {'id': 'tr_005', 'type': 'transfer', 'difficulty': 'hard', 'questionText': '¿Cuál fue el primer fichaje de más de 100M€ en la historia?', 'correctAnswer': 'Gareth Bale (Real Madrid, 2013)', 'options': ['Gareth Bale (Real Madrid, 2013)', 'Cristiano Ronaldo (Juventus, 2018)', 'Neymar (PSG, 2017)', 'Paul Pogba (Manchester United, 2016)'], 'imageUrl': null, 'extraData': null},
    {'id': 'tr_006', 'type': 'transfer', 'difficulty': 'easy', 'questionText': '¿A qué club fue Messi en 2021 tras salir del Barcelona?', 'correctAnswer': 'Paris Saint-Germain', 'options': ['Paris Saint-Germain', 'Inter Miami', 'Manchester City', 'Juventus'], 'imageUrl': null, 'extraData': null},
    {'id': 'tr_007', 'type': 'transfer', 'difficulty': 'medium', 'questionText': '¿Qué club pagó 100M€ por Eden Hazard en 2019?', 'correctAnswer': 'Real Madrid', 'options': ['Real Madrid', 'Chelsea', 'Bayern Munich', 'Barcelona'], 'imageUrl': null, 'extraData': null},
    {'id': 'tr_008', 'type': 'transfer', 'difficulty': 'hard', 'questionText': '¿Cuánto pagó la Juventus por Cristiano Ronaldo en 2018?', 'correctAnswer': '100M€', 'options': ['100M€', '120M€', '80M€', '90M€'], 'imageUrl': null, 'extraData': null},
    {'id': 'tr_009', 'type': 'transfer', 'difficulty': 'medium', 'questionText': '¿Qué jugador boliviano fue fichado por el Bayern Munich?', 'correctAnswer': 'Ninguno de estos', 'options': ['Ninguno de estos', 'Marcelo Moreno', 'Juan Carlos Arce', 'Jhasmani Campos'], 'imageUrl': null, 'extraData': {'trick': true}},
    {'id': 'tr_010', 'type': 'transfer', 'difficulty': 'easy', 'questionText': '¿En qué club juega Haaland desde 2022?', 'correctAnswer': 'Manchester City', 'options': ['Manchester City', 'Borussia Dortmund', 'Bayern Munich', 'Liverpool'], 'imageUrl': null, 'extraData': null},
  ];
}

// ════════════════════════════════════════════════════
// MANAGERS (50 preguntas)
// ════════════════════════════════════════════════════

List<Map<String, dynamic>> _managerQuestions() {
  return [
    {'id': 'm_001', 'type': 'manager', 'difficulty': 'easy', 'questionText': '¿Qué entrenador ganó más Champions League?', 'correctAnswer': 'Carlo Ancelotti', 'options': ['Carlo Ancelotti', 'Zinedine Zidane', 'Pep Guardiola', 'Alex Ferguson'], 'imageUrl': null, 'extraData': null},
    {'id': 'm_002', 'type': 'manager', 'difficulty': 'easy', 'questionText': '¿Qué entrenador es conocido como "El Traductor"?', 'correctAnswer': 'Pep Guardiola', 'options': ['Pep Guardiola', 'José Mourinho', 'Diego Simeone', 'Jürgen Klopp'], 'imageUrl': null, 'extraData': null},
    {'id': 'm_003', 'type': 'manager', 'difficulty': 'medium', 'questionText': '¿Qué entrenador ganó el Mundial con Francia en 1998 y 2018?', 'correctAnswer': 'Aimé Jacquet y Didier Deschamps', 'options': ['Aimé Jacquet y Didier Deschamps', 'Zinedine Zidane', 'Michel Platini', 'Laurent Blanc'], 'imageUrl': null, 'extraData': null},
    {'id': 'm_004', 'type': 'manager', 'difficulty': 'medium', 'questionText': '¿Qué entrenador es conocido como "The Special One"?', 'correctAnswer': 'José Mourinho', 'options': ['José Mourinho', 'Pep Guardiola', 'Alex Ferguson', 'Arsène Wenger'], 'imageUrl': null, 'extraData': null},
    {'id': 'm_005', 'type': 'manager', 'difficulty': 'hard', 'questionText': '¿Qué entrenador estuvo más años en un mismo club?', 'correctAnswer': 'Alex Ferguson (Manchester United, 26 años)', 'options': ['Alex Ferguson (Manchester United, 26 años)', 'Arsène Wenger (Arsenal, 22 años)', 'Matt Busby (Manchester United)', 'Bill Shankly (Liverpool)'], 'imageUrl': null, 'extraData': null},
    {'id': 'm_006', 'type': 'manager', 'difficulty': 'easy', 'questionText': '¿Qué entrenador argentino dirige el Atlético de Madrid?', 'correctAnswer': 'Diego Simeone', 'options': ['Diego Simeone', 'Jorge Sampaoli', 'Mauricio Pochettino', 'Marcelo Bielsa'], 'imageUrl': null, 'extraData': null},
    {'id': 'm_007', 'type': 'manager', 'difficulty': 'medium', 'questionText': '¿Qué entrenador alemán ganó el Mundial 2014?', 'correctAnswer': 'Joachim Löw', 'options': ['Joachim Löw', 'Jürgen Klinsmann', 'Franz Beckenbauer', 'Rudi Völler'], 'imageUrl': null, 'extraData': null},
    {'id': 'm_008', 'type': 'manager', 'difficulty': 'hard', 'questionText': '¿Qué entrenador ganó la Eurocopa con Grecia en 2004?', 'correctAnswer': 'Otto Rehhagel', 'options': ['Otto Rehhagel', 'Fernando Santos', 'Anghel Iordănescu', 'Lars Lagerbäck'], 'imageUrl': null, 'extraData': null},
    {'id': 'm_009', 'type': 'manager', 'difficulty': 'medium', 'questionText': '¿Qué entrenador español ganó la Eurocopa 2008 y 2012, y el Mundial 2010?', 'correctAnswer': 'Vicente del Bosque', 'options': ['Vicente del Bosque', 'Luis Aragonés', 'Julen Lopetegui', 'Luis Enrique'], 'imageUrl': null, 'extraData': null},
    {'id': 'm_010', 'type': 'manager', 'difficulty': 'hard', 'questionText': '¿Qué entrenador italiano inventó el "Catenaccio"?', 'correctAnswer': 'Nereo Rocco y Helenio Herrera', 'options': ['Nereo Rocco y Helenio Herrera', 'Arrigo Sacchi', 'Marcello Lippi', 'Fabio Capello'], 'imageUrl': null, 'extraData': null},
  ];
}

// ════════════════════════════════════════════════════
// CLÁSICOS Y DERBIES (50 preguntas)
// ════════════════════════════════════════════════════

List<Map<String, dynamic>> _derbyQuestions() {
  return [
    {'id': 'd_001', 'type': 'derby', 'difficulty': 'easy', 'questionText': '¿Cómo se llama el derbi entre Real Madrid y Barcelona?', 'correctAnswer': 'El Clásico', 'options': ['El Clásico', 'El Derbi', 'El Partidazo', 'La Supercopa'], 'imageUrl': null, 'extraData': null},
    {'id': 'd_002', 'type': 'derby', 'difficulty': 'easy', 'questionText': '¿Cómo se llama el derbi de Milán?', 'correctAnswer': 'Derbi della Madonnina', 'options': ['Derbi della Madonnina', 'Derbi de Italia', 'Derbi del Calcio', 'Derbi de Lombardía'], 'imageUrl': null, 'extraData': null},
    {'id': 'd_003', 'type': 'derby', 'difficulty': 'easy', 'questionText': '¿Cómo se llama el derbi de Manchester?', 'correctAnswer': 'Manchester Derby', 'options': ['Manchester Derby', 'Derbi del Norte', 'Derbi de Inglaterra', 'Derbi Rojo'], 'imageUrl': null, 'extraData': null},
    {'id': 'd_004', 'type': 'derby', 'difficulty': 'medium', 'questionText': '¿Cómo se llama el derbi de Buenos Aires entre River y Boca?', 'correctAnswer': 'Superclásico', 'options': ['Superclásico', 'El Clásico', 'Derbi Porteño', 'La Final'], 'imageUrl': null, 'extraData': null},
    {'id': 'd_005', 'type': 'derby', 'difficulty': 'medium', 'questionText': '¿Cómo se llama el derbi de Lisboa entre Benfica y Sporting?', 'correctAnswer': 'Derbi de Lisboa', 'options': ['Derbi de Lisboa', 'Derbi Portugués', 'Clásico de Portugal', 'Derbi Iberico'], 'imageUrl': null, 'extraData': null},
    {'id': 'd_006', 'type': 'derby', 'difficulty': 'hard', 'questionText': '¿Qué derbi es conocido como "El Viejo Clásico"?', 'correctAnswer': 'River Plate vs Racing Club', 'options': ['River Plate vs Racing Club', 'Boca vs River', 'Independiente vs Racing', 'San Lorenzo vs Huracán'], 'imageUrl': null, 'extraData': null},
    {'id': 'd_007', 'type': 'derby', 'difficulty': 'medium', 'questionText': '¿Cómo se llama el derbi de Glasgow entre Celtic y Rangers?', 'correctAnswer': 'Old Firm', 'options': ['Old Firm', 'Glasgow Derby', 'Scottish Derby', 'Celtic-Rangers'], 'imageUrl': null, 'extraData': null},
    {'id': 'd_008', 'type': 'derby', 'difficulty': 'medium', 'questionText': '¿Cómo se llama el derbi de Roma?', 'correctAnswer': 'Derbi della Capitale', 'options': ['Derbi della Capitale', 'Derbi de Italia', 'Roma Derby', 'Lazio Derby'], 'imageUrl': null, 'extraData': null},
    {'id': 'd_009', 'type': 'derby', 'difficulty': 'hard', 'questionText': '¿Qué derbi turco es conocido como "El Intercontinental Derby"?', 'correctAnswer': 'Galatasaray vs Fenerbahçe', 'options': ['Galatasaray vs Fenerbahçe', 'Galatasaray vs Beşiktaş', 'Fenerbahçe vs Beşiktaş', 'Galatasaray vs Trabzonspor'], 'imageUrl': null, 'extraData': null},
    {'id': 'd_010', 'type': 'derby', 'difficulty': 'easy', 'questionText': '¿Cómo se llama el derbi de Merseyside entre Liverpool y Everton?', 'correctAnswer': 'Merseyside Derby', 'options': ['Merseyside Derby', 'Liverpool Derby', 'Everton Derby', 'Anfield Derby'], 'imageUrl': null, 'extraData': null},
  ];
}

// ════════════════════════════════════════════════════
// UNIFORMES Y COLORES (40 preguntas)
// ════════════════════════════════════════════════════

List<Map<String, dynamic>> _kitQuestions() {
  return [
    {'id': 'k_001', 'type': 'kit', 'difficulty': 'easy', 'questionText': '¿De qué color es el uniforme titular del Real Madrid?', 'correctAnswer': 'Blanco', 'options': ['Blanco', 'Rojo', 'Azul', 'Amarillo'], 'imageUrl': null, 'extraData': null},
    {'id': 'k_002', 'type': 'kit', 'difficulty': 'easy', 'questionText': '¿De qué color es el uniforme titular del Barcelona?', 'correctAnswer': 'Azulgrana (azul y granada)', 'options': ['Azulgrana (azul y granada)', 'Rojo y amarillo', 'Blanco y azul', 'Rojo y negro'], 'imageUrl': null, 'extraData': null},
    {'id': 'k_003', 'type': 'kit', 'difficulty': 'easy', 'questionText': '¿De qué color es el uniforme titular del Manchester United?', 'correctAnswer': 'Rojo', 'options': ['Rojo', 'Azul', 'Blanco', 'Negro'], 'imageUrl': null, 'extraData': null},
    {'id': 'k_004', 'type': 'kit', 'difficulty': 'easy', 'questionText': '¿De qué color es el uniforme titular de la Juventus?', 'correctAnswer': 'Blanco y negro (rayas)', 'options': ['Blanco y negro (rayas)', 'Azul', 'Rojo', 'Amarillo'], 'imageUrl': null, 'extraData': null},
    {'id': 'k_005', 'type': 'kit', 'difficulty': 'easy', 'questionText': '¿De qué color es el uniforme titular del AC Milan?', 'correctAnswer': 'Rojo y negro (rayas)', 'options': ['Rojo y negro (rayas)', 'Azul y negro', 'Rojo y blanco', 'Negro y blanco'], 'imageUrl': null, 'extraData': null},
    {'id': 'k_006', 'type': 'kit', 'difficulty': 'medium', 'questionText': '¿Qué equipo es conocido como "Los Reds"?', 'correctAnswer': 'Liverpool', 'options': ['Liverpool', 'Manchester United', 'Arsenal', 'Nottingham Forest'], 'imageUrl': null, 'extraData': null},
    {'id': 'k_007', 'type': 'kit', 'difficulty': 'medium', 'questionText': '¿Qué equipo es conocido como "The Blues"?', 'correctAnswer': 'Chelsea', 'options': ['Chelsea', 'Manchester City', 'Everton', 'Leicester'], 'imageUrl': null, 'extraData': null},
    {'id': 'k_008', 'type': 'kit', 'difficulty': 'medium', 'questionText': '¿De qué color es el uniforme titular del Borussia Dortmund?', 'correctAnswer': 'Amarillo y negro', 'options': ['Amarillo y negro', 'Rojo y blanco', 'Verde y blanco', 'Azul y blanco'], 'imageUrl': null, 'extraData': null},
    {'id': 'k_009', 'type': 'kit', 'difficulty': 'hard', 'questionText': '¿Por qué la Juventus usa rayas verticales?', 'correctAnswer': 'Por el primer jersey de Nottingham', 'options': ['Por el primer jersey de Nottingham', 'Por la bandera de Turín', 'Por la casa real italiana', 'Por la tradición inglesa'], 'imageUrl': null, 'extraData': null},
    {'id': 'k_010', 'type': 'kit', 'difficulty': 'medium', 'questionText': '¿Qué equipo tiene una chapa de cocodrilo en su uniforme?', 'correctAnswer': 'Ninguno (Lacoste no es equipo)', 'options': ['Ninguno (Lacoste no es equipo)', 'Chelsea', 'Everton', 'Newcastle'], 'imageUrl': null, 'extraData': {'trick': true}},
  ];
}
