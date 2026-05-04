// FutKO — Seed Script para Firestore (Node.js)
// Ejecutar con: node scripts/seed_questions.js
//
// Requiere: npm install firebase-admin

const admin = require('firebase-admin');

// Usar credenciales por defecto (gcloud auth application-default login)
// O descargar service account key de Firebase Console
admin.initializeApp({
  projectId: 'futko-battle',
});

const db = admin.firestore();

const BATCH_SIZE = 400;

async function seed() {
  console.log('🔥 Conectado a Firestore: futko-battle');

  const questions = generateQuestions();
  console.log(`📋 Generadas ${questions.length} preguntas`);

  let count = 0;
  for (let i = 0; i < questions.length; i += BATCH_SIZE) {
    const end = Math.min(i + BATCH_SIZE, questions.length);
    const batch = db.batch();
    for (let j = i; j < end; j++) {
      const docRef = db.collection('questions').doc(questions[j].id);
      batch.set(docRef, questions[j]);
      count++;
    }
    await batch.commit();
    console.log(`  ✅ Batch enviado: ${count} / ${questions.length}`);
  }

  console.log(`\n🎉 Seed completado! ${count} preguntas insertadas.`);
  process.exit(0);
}

seed().catch(err => {
  console.error('❌ Error:', err);
  process.exit(1);
});

function generateQuestions() {
  return [
    ...playerQuestions(),
    ...teamQuestions(),
    ...competitionQuestions(),
    ...historyQuestions(),
    ...rulesQuestions(),
    ...stadiumQuestions(),
    ...statisticQuestions(),
    ...transferQuestions(),
  ];
}

// ════════════════════════════════════════════════════
// JUGADORES
// ════════════════════════════════════════════════════

function playerQuestions() {
  return [
    {
      id: 'p_001',
      type: 'player',
      difficulty: 'easy',
      questionText: '¿Qué jugador ha ganado más Balones de Oro?',
      correctAnswer: 'Lionel Messi',
      options: ['Lionel Messi', 'Cristiano Ronaldo', 'Michel Platini', 'Johan Cruyff'],
      imageUrl: null,
      extraData: { country: 'AR', era: 'modern' },
    },
    {
      id: 'p_002',
      type: 'player',
      difficulty: 'easy',
      questionText: '¿A qué club se conoce como "La Pulga" su jugador estrella?',
      correctAnswer: 'FC Barcelona',
      options: ['FC Barcelona', 'Real Madrid', 'PSG', 'Inter Miami'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'p_003',
      type: 'player',
      difficulty: 'medium',
      questionText: '¿Qué jugador marcó el "Gol del Siglo" en México 86?',
      correctAnswer: 'Diego Maradona',
      options: ['Diego Maradona', 'Pelé', 'Zinedine Zidane', 'Ronaldo Nazário'],
      imageUrl: null,
      extraData: { worldCup: '1986' },
    },
    {
      id: 'p_004',
      type: 'player',
      difficulty: 'medium',
      questionText: '¿Qué delantero es el máximo goleador histórico de la Premier League?',
      correctAnswer: 'Alan Shearer',
      options: ['Alan Shearer', 'Thierry Henry', 'Wayne Rooney', 'Harry Kane'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'p_005',
      type: 'player',
      difficulty: 'hard',
      questionText: '¿Qué jugador ganó el Balón de Oro en 1995?',
      correctAnswer: 'George Weah',
      options: ['George Weah', 'Roberto Baggio', 'Hristo Stoichkov', 'Jari Litmanen'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'p_006',
      type: 'player',
      difficulty: 'easy',
      questionText: '¿Qué jugador es conocido como "CR7"?',
      correctAnswer: 'Cristiano Ronaldo',
      options: ['Cristiano Ronaldo', 'Carles Puyol', 'Claudio Ranieri', 'Carlos Tevez'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'p_007',
      type: 'player',
      difficulty: 'medium',
      questionText: '¿Qué jugador brasileño es conocido como "O Fenômeno"?',
      correctAnswer: 'Ronaldo Nazário',
      options: ['Ronaldo Nazário', 'Ronaldinho', 'Rivaldo', 'Romário'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'p_008',
      type: 'player',
      difficulty: 'easy',
      questionText: '¿Quién es considerado el "Rey del Fútbol"?',
      correctAnswer: 'Pelé',
      options: ['Pelé', 'Maradona', 'Cruyff', 'Di Stéfano'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'p_009',
      type: 'player',
      difficulty: 'hard',
      questionText: '¿Qué portero ganó el Balón de Oro en 1963?',
      correctAnswer: 'Lev Yashin',
      options: ['Lev Yashin', 'Dino Zoff', 'Gordon Banks', 'Sepp Maier'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'p_010',
      type: 'player',
      difficulty: 'medium',
      questionText: '¿Qué jugador marcó el gol de la mano de Dios en 1986?',
      correctAnswer: 'Diego Maradona',
      options: ['Diego Maradona', 'Gary Lineker', 'Jorge Valdano', 'Michel Platini'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'p_011',
      type: 'player',
      difficulty: 'easy',
      questionText: '¿Qué jugador francés hizo una chilena en la final del Mundial 2018?',
      correctAnswer: 'Ningún jugador francés hizo una chilena en esa final',
      options: ['Ningún jugador francés hizo una chilena en esa final', 'Kylian Mbappé', 'Antoine Griezmann', 'Paul Pogba'],
      imageUrl: null,
      extraData: { trick: true },
    },
    {
      id: 'p_012',
      type: 'player',
      difficulty: 'medium',
      questionText: '¿Qué jugador ha jugado en más Mundiales?',
      correctAnswer: 'Antonio Carbajal y Andrés Guardado',
      options: ['Antonio Carbajal y Andrés Guardado', 'Pelé', 'Lothar Matthäus', 'Cristiano Ronaldo'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'p_013',
      type: 'player',
      difficulty: 'hard',
      questionText: '¿Qué jugador ganó la Bota de Oro en el Mundial 2010?',
      correctAnswer: 'Thomas Müller',
      options: ['Thomas Müller', 'David Villa', 'Wesley Sneijder', 'Diego Forlán'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'p_014',
      type: 'player',
      difficulty: 'easy',
      questionText: '¿Qué jugador argentino debutó en Barcelona con 17 años?',
      correctAnswer: 'Lionel Messi',
      options: ['Lionel Messi', 'Diego Maradona', 'Ángel Di María', 'Sergio Agüero'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'p_015',
      type: 'player',
      difficulty: 'medium',
      questionText: '¿Quién fue el máximo goleador del Mundial 2002?',
      correctAnswer: 'Ronaldo Nazário',
      options: ['Ronaldo Nazário', 'Miroslav Klose', 'Rivaldo', 'Ronaldinho'],
      imageUrl: null,
      extraData: null,
    },
  ];
}

// ════════════════════════════════════════════════════
// EQUIPOS
// ════════════════════════════════════════════════════

function teamQuestions() {
  return [
    {
      id: 't_001',
      type: 'team',
      difficulty: 'easy',
      questionText: '¿Qué equipo es conocido como "Los Merengues"?',
      correctAnswer: 'Real Madrid',
      options: ['Real Madrid', 'Barcelona', 'Juventus', 'Bayern Munich'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 't_002',
      type: 'team',
      difficulty: 'easy',
      questionText: '¿Qué equipo ha ganado más Champions League?',
      correctAnswer: 'Real Madrid',
      options: ['Real Madrid', 'AC Milan', 'Bayern Munich', 'Liverpool'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 't_003',
      type: 'team',
      difficulty: 'easy',
      questionText: '¿A qué equipo se le llama "Los Colchoneros"?',
      correctAnswer: 'Atlético de Madrid',
      options: ['Atlético de Madrid', 'Valencia', 'Sevilla', 'Villarreal'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 't_004',
      type: 'team',
      difficulty: 'medium',
      questionText: '¿Qué equipo inglés juega en Anfield?',
      correctAnswer: 'Liverpool',
      options: ['Liverpool', 'Everton', 'Manchester United', 'Chelsea'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 't_005',
      type: 'team',
      difficulty: 'medium',
      questionText: '¿Qué equipo italiano es conocido como "La Vecchia Signora"?',
      correctAnswer: 'Juventus',
      options: ['Juventus', 'AC Milan', 'Inter Milan', 'AS Roma'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 't_006',
      type: 'team',
      difficulty: 'hard',
      questionText: '¿Qué equipo ha ganado más veces la Bundesliga?',
      correctAnswer: 'Bayern Munich',
      options: ['Bayern Munich', 'Borussia Dortmund', 'Hamburger SV', 'Werder Bremen'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 't_007',
      type: 'team',
      difficulty: 'easy',
      questionText: '¿Cuál es el equipo más titulado de Argentina?',
      correctAnswer: 'River Plate',
      options: ['River Plate', 'Boca Juniors', 'Independiente', 'Racing Club'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 't_008',
      type: 'team',
      difficulty: 'medium',
      questionText: '¿Qué equipo juega en el estadio Signal Iduna Park?',
      correctAnswer: 'Borussia Dortmund',
      options: ['Borussia Dortmund', 'Bayern Munich', 'Schalke 04', 'Bayer Leverkusen'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 't_009',
      type: 'team',
      difficulty: 'hard',
      questionText: '¿Qué equipo ganó la primera edición de la Champions League en 1956?',
      correctAnswer: 'Real Madrid',
      options: ['Real Madrid', 'AC Milan', 'Benfica', 'Stade de Reims'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 't_010',
      type: 'team',
      difficulty: 'medium',
      questionText: '¿Qué equipo es conocido como "Les Parisiens"?',
      correctAnswer: 'Paris Saint-Germain',
      options: ['Paris Saint-Germain', 'Olympique de Marseille', 'Lyon', 'Monaco'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 't_011',
      type: 'team',
      difficulty: 'easy',
      questionText: '¿Qué equipo es conocido como "El Submarino Amarillo"?',
      correctAnswer: 'Villarreal',
      options: ['Villarreal', 'Valencia', 'Levante', 'Betis'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 't_012',
      type: 'team',
      difficulty: 'medium',
      questionText: '¿Qué equipo portugués ha ganado más Champions League?',
      correctAnswer: 'Benfica',
      options: ['Benfica', 'Porto', 'Sporting CP', 'Ninguno'],
      imageUrl: null,
      extraData: { trick: true },
    },
    {
      id: 't_013',
      type: 'team',
      difficulty: 'hard',
      questionText: '¿Qué equipo sudamericano ha ganado más Copas Libertadores?',
      correctAnswer: 'Independiente (Argentina)',
      options: ['Independiente (Argentina)', 'Boca Juniors', 'Peñarol', 'Santos'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 't_014',
      type: 'team',
      difficulty: 'easy',
      questionText: '¿En qué club jugó Zidane cuando le dio el cabezazo a Materazzi?',
      correctAnswer: 'Real Madrid',
      options: ['Real Madrid', 'Juventus', 'Burdeos', 'Francia no es un club'],
      imageUrl: null,
      extraData: { note: 'Ocurrió en el Mundial 2006 con Francia' },
    },
    {
      id: 't_015',
      type: 'team',
      difficulty: 'medium',
      questionText: '¿Qué equipo inglés es conocido como "The Hatters"?',
      correctAnswer: 'Luton Town',
      options: ['Luton Town', 'Manchester City', 'Arsenal', 'Tottenham'],
      imageUrl: null,
      extraData: null,
    },
  ];
}

// ════════════════════════════════════════════════════
// COMPETICIONES
// ════════════════════════════════════════════════════

function competitionQuestions() {
  return [
    {
      id: 'c_001',
      type: 'competition',
      difficulty: 'easy',
      questionText: '¿Cada cuántos años se celebra el Mundial de Fútbol?',
      correctAnswer: '4 años',
      options: ['4 años', '2 años', '3 años', '5 años'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'c_002',
      type: 'competition',
      difficulty: 'easy',
      questionText: '¿Qué competición de clubs es la más importante de Europa?',
      correctAnswer: 'UEFA Champions League',
      options: ['UEFA Champions League', 'Europa League', 'Conference League', 'Supercopa de Europa'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'c_003',
      type: 'competition',
      difficulty: 'medium',
      questionText: '¿Qué selección ha ganado más Mundiales?',
      correctAnswer: 'Brasil',
      options: ['Brasil', 'Alemania', 'Italia', 'Argentina'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'c_004',
      type: 'competition',
      difficulty: 'medium',
      questionText: '¿En qué país se celebró el Mundial 2022?',
      correctAnswer: 'Qatar',
      options: ['Qatar', 'Rusia', 'Emiratos Árabes', 'Arabia Saudita'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'c_005',
      type: 'competition',
      difficulty: 'hard',
      questionText: '¿Qué selección ganó la primera Copa América en 1916?',
      correctAnswer: 'Uruguay',
      options: ['Uruguay', 'Argentina', 'Brasil', 'Chile'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'c_006',
      type: 'competition',
      difficulty: 'easy',
      questionText: '¿Qué competición de selecciones se disputa en Sudamérica?',
      correctAnswer: 'Copa América',
      options: ['Copa América', 'Eurocopa', 'Copa de Oro', 'Copa Asiática'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'c_007',
      type: 'competition',
      difficulty: 'medium',
      questionText: '¿Cuántos equipos participan en la fase final del Mundial 2026?',
      correctAnswer: '48',
      options: ['48', '32', '40', '64'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'c_008',
      type: 'competition',
      difficulty: 'hard',
      questionText: '¿Qué equipo ha ganado más Copas Libertadores?',
      correctAnswer: 'Independiente',
      options: ['Independiente', 'Boca Juniors', 'Peñarol', 'Santos'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'c_009',
      type: 'competition',
      difficulty: 'medium',
      questionText: '¿Qué selección ganó la Eurocopa 2016?',
      correctAnswer: 'Portugal',
      options: ['Portugal', 'Francia', 'Alemania', 'España'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'c_010',
      type: 'competition',
      difficulty: 'easy',
      questionText: '¿En qué competición juegan los mejores equipos de cada liga europea?',
      correctAnswer: 'Champions League',
      options: ['Champions League', 'Europa League', 'Copa del Rey', 'FA Cup'],
      imageUrl: null,
      extraData: null,
    },
  ];
}

// ════════════════════════════════════════════════════
// HISTORIA
// ════════════════════════════════════════════════════

function historyQuestions() {
  return [
    {
      id: 'h_001',
      type: 'history',
      difficulty: 'easy',
      questionText: '¿En qué año se celebró el primer Mundial de Fútbol?',
      correctAnswer: '1930',
      options: ['1930', '1928', '1934', '1926'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'h_002',
      type: 'history',
      difficulty: 'medium',
      questionText: '¿Qué país organizó y ganó el primer Mundial?',
      correctAnswer: 'Uruguay',
      options: ['Uruguay', 'Brasil', 'Argentina', 'Italia'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'h_003',
      type: 'history',
      difficulty: 'hard',
      questionText: '¿Qué selección ganó el Mundial de 1954 en el "Milagro de Berna"?',
      correctAnswer: 'Alemania Occidental',
      options: ['Alemania Occidental', 'Hungría', 'Brasil', 'Uruguay'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'h_004',
      type: 'history',
      difficulty: 'medium',
      questionText: '¿En qué Mundial Maradona hizo "La Mano de Dios"?',
      correctAnswer: 'México 1986',
      options: ['México 1986', 'Italia 1990', 'España 1982', 'EE.UU. 1994'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'h_005',
      type: 'history',
      difficulty: 'easy',
      questionText: '¿Qué selección ganó el Mundial 2010?',
      correctAnswer: 'España',
      options: ['España', 'Holanda', 'Alemania', 'Brasil'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'h_006',
      type: 'history',
      difficulty: 'medium',
      questionText: '¿Qué equipo ganó la Champions League en 1999 con un gol en el minuto 93?',
      correctAnswer: 'Manchester United',
      options: ['Manchester United', 'Bayern Munich', 'Real Madrid', 'Juventus'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'h_007',
      type: 'history',
      difficulty: 'hard',
      questionText: '¿Qué selección fue la primera en ganar 3 Mundiales y retener la copa?',
      correctAnswer: 'Brasil (1970, Copa Jules Rimet)',
      options: ['Brasil (1970, Copa Jules Rimet)', 'Italia (1982)', 'Alemania (1990)', 'Argentina (1986)'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'h_008',
      type: 'history',
      difficulty: 'medium',
      questionText: '¿Qué equipo ganó la Champions League en la remontada de Estambul 2005?',
      correctAnswer: 'Liverpool',
      options: ['Liverpool', 'AC Milan', 'Real Madrid', 'Barcelona'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'h_009',
      type: 'history',
      difficulty: 'easy',
      questionText: '¿Qué país ganó el Mundial 2022 en Qatar?',
      correctAnswer: 'Argentina',
      options: ['Argentina', 'Francia', 'Croacia', 'Marruecos'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'h_010',
      type: 'history',
      difficulty: 'hard',
      questionText: '¿Qué club ganó la Copa de Europa 5 veces seguidas entre 1956-1960?',
      correctAnswer: 'Real Madrid',
      options: ['Real Madrid', 'AC Milan', 'Benfica', 'Barcelona'],
      imageUrl: null,
      extraData: null,
    },
  ];
}

// ════════════════════════════════════════════════════
// REGLAS
// ════════════════════════════════════════════════════

function rulesQuestions() {
  return [
    {
      id: 'r_001',
      type: 'rules',
      difficulty: 'easy',
      questionText: '¿Cuántos jugadores tiene cada equipo en el campo?',
      correctAnswer: '11',
      options: ['11', '10', '12', '9'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'r_002',
      type: 'rules',
      difficulty: 'easy',
      questionText: '¿Cuánto dura cada tiempo reglamentario?',
      correctAnswer: '45 minutos',
      options: ['45 minutos', '30 minutos', '60 minutos', '40 minutos'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'r_003',
      type: 'rules',
      difficulty: 'medium',
      questionText: '¿Qué señal indica el asistente cuando hay fuera de juego?',
      correctAnswer: 'Banderín levantado por encima de la cabeza',
      options: ['Banderín levantado por encima de la cabeza', 'Banderín apuntando al centro', 'Banderín agitado horizontalmente', 'Banderín apuntando al córner'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'r_004',
      type: 'rules',
      difficulty: 'medium',
      questionText: '¿A qué distancia debe colocarse la barrera en una falta directa?',
      correctAnswer: '9.15 metros',
      options: ['9.15 metros', '10 metros', '7.32 metros', '11 metros'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'r_005',
      type: 'rules',
      difficulty: 'hard',
      questionText: '¿Desde qué área se puede marcar gol directamente en un saque de puerta?',
      correctAnswer: 'Desde dentro del área penal del equipo contrario no, se concede córner',
      options: ['Desde dentro del área penal del equipo contrario no, se concede córner', 'Desde cualquier lugar del campo', 'Solo desde el centro del campo', 'Desde el área propia del portero'],
      imageUrl: null,
      extraData: { trick: true },
    },
    {
      id: 'r_006',
      type: 'rules',
      difficulty: 'easy',
      questionText: '¿De qué color es la tarjeta que significa expulsión?',
      correctAnswer: 'Roja',
      options: ['Roja', 'Amarilla', 'Azul', 'Verde'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'r_007',
      type: 'rules',
      difficulty: 'medium',
      questionText: '¿Cuántos cambios se permiten en la prórroga?',
      correctAnswer: '1 cambio adicional',
      options: ['1 cambio adicional', '2 cambios adicionales', '3 cambios adicionales', 'No se permiten'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'r_008',
      type: 'rules',
      difficulty: 'hard',
      questionText: '¿Qué dimensiones mínimas debe tener un campo de fútbol?',
      correctAnswer: '90m x 45m',
      options: ['90m x 45m', '100m x 50m', '80m x 40m', '105m x 68m'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'r_009',
      type: 'rules',
      difficulty: 'medium',
      questionText: '¿Cuándo se concede un penalti?',
      correctAnswer: 'Falta dentro del área penal',
      options: ['Falta dentro del área penal', 'Falta fuera del área', 'Falta en el centro del campo', 'Cualquier falta del equipo visitante'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'r_010',
      type: 'rules',
      difficulty: 'easy',
      questionText: '¿Qué tarjeta se muestra por una falta táctica?',
      correctAnswer: 'Amarilla',
      options: ['Amarilla', 'Roja', 'Azul', 'Blanca'],
      imageUrl: null,
      extraData: null,
    },
  ];
}

// ════════════════════════════════════════════════════
// ESTADIOS
// ════════════════════════════════════════════════════

function stadiumQuestions() {
  return [
    {
      id: 's_001',
      type: 'stadium',
      difficulty: 'easy',
      questionText: '¿Cómo se llama el estadio del Real Madrid?',
      correctAnswer: 'Santiago Bernabéu',
      options: ['Santiago Bernabéu', 'Camp Nou', 'Wanda Metropolitano', 'Mestalla'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 's_002',
      type: 'stadium',
      difficulty: 'easy',
      questionText: '¿En qué estadio jugaba el Barcelona anteriormente?',
      correctAnswer: 'Camp Nou',
      options: ['Camp Nou', 'Santiago Bernabéu', 'Olímpico de Montjuïc', 'Wanda Metropolitano'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 's_003',
      type: 'stadium',
      difficulty: 'medium',
      questionText: '¿En qué estadio se jugó la final del Mundial 2014?',
      correctAnswer: 'Maracaná',
      options: ['Maracaná', 'Estadio Nacional de Brasilia', 'Arena Corinthians', 'Mineirão'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 's_004',
      type: 'stadium',
      difficulty: 'medium',
      questionText: '¿Cuál es el estadio con mayor capacidad de Inglaterra?',
      correctAnswer: 'Wembley',
      options: ['Wembley', 'Old Trafford', 'Anfield', 'Emirates Stadium'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 's_005',
      type: 'stadium',
      difficulty: 'hard',
      questionText: '¿Qué estadio es conocido como "La Bombonera"?',
      correctAnswer: 'Alberto J. Armando (Boca Juniors)',
      options: ['Alberto J. Armando (Boca Juniors)', 'Monumental (River Plate)', 'Centenario (Uruguay)', 'Azteca (México)'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 's_006',
      type: 'stadium',
      difficulty: 'easy',
      questionText: '¿En qué estadio se jugó la final del Mundial 2022?',
      correctAnswer: 'Estadio Lusail',
      options: ['Estadio Lusail', 'Estadio Al Bayt', 'Estadio Al Janoub', 'Estudio 974'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 's_007',
      type: 'stadium',
      difficulty: 'hard',
      questionText: '¿Cuál es el estadio más grande del mundo?',
      correctAnswer: 'Estadio Rungrado (Corea del Norte, ~150.000)',
      options: ['Estadio Rungrado (Corea del Norte, ~150.000)', 'Camp Nou', 'Maracaná', 'Wembley'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 's_008',
      type: 'stadium',
      difficulty: 'medium',
      questionText: '¿Qué estadio alemán es conocido como "El Teatro de los Sueños"?',
      correctAnswer: 'Westfalenstadion (Signal Iduna Park)',
      options: ['Westfalenstadion (Signal Iduna Park)', 'Allianz Arena', 'Olympiastadion', 'Volksparkstadion'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 's_009',
      type: 'stadium',
      difficulty: 'easy',
      questionText: '¿En qué estadio juega el Atlético de Madrid?',
      correctAnswer: 'Cívitas Metropolitano',
      options: ['Cívitas Metropolitano', 'Santiago Bernabéu', 'Camp Nou', 'Mestalla'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 's_010',
      type: 'stadium',
      difficulty: 'medium',
      questionText: '¿En qué estadio se jugó la final de la Champions League 2024?',
      correctAnswer: 'Wembley',
      options: ['Wembley', 'Atatürk Olympic Stadium', 'Estadio de la Cerámica', 'Allianz Arena'],
      imageUrl: null,
      extraData: null,
    },
  ];
}

// ════════════════════════════════════════════════════
// ESTADÍSTICAS
// ════════════════════════════════════════════════════

function statisticQuestions() {
  return [
    {
      id: 'st_001',
      type: 'statistic',
      difficulty: 'easy',
      questionText: '¿Cuántos goles marcó Ronaldo Nazário en la final del Mundial 2002?',
      correctAnswer: '2',
      options: ['2', '1', '3', '0'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'st_002',
      type: 'statistic',
      difficulty: 'medium',
      questionText: '¿Cuántos goles tiene Cristiano Ronaldo en su carrera?',
      correctAnswer: 'Más de 850',
      options: ['Más de 850', 'Más de 700', 'Más de 900', 'Más de 750'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'st_003',
      type: 'statistic',
      difficulty: 'hard',
      questionText: '¿Cuántos goles marcó Just Fontaine en un solo Mundial (1958)?',
      correctAnswer: '13',
      options: ['13', '10', '15', '8'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'st_004',
      type: 'statistic',
      difficulty: 'medium',
      questionText: '¿Cuántos goles marcó Miroslav Klose en Mundiales?',
      correctAnswer: '16',
      options: ['16', '14', '15', '12'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'st_005',
      type: 'statistic',
      difficulty: 'easy',
      questionText: '¿Cuántos Balones de Oro ha ganado Messi?',
      correctAnswer: '8',
      options: ['8', '7', '6', '5'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'st_006',
      type: 'statistic',
      difficulty: 'medium',
      questionText: '¿Cuántas Champions League ha ganado Real Madrid?',
      correctAnswer: '15',
      options: ['15', '14', '13', '12'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'st_007',
      type: 'statistic',
      difficulty: 'hard',
      questionText: '¿Cuántos goles marcó Gerd Müller en la Bundesliga?',
      correctAnswer: '365',
      options: ['365', '350', '372', '340'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'st_008',
      type: 'statistic',
      difficulty: 'easy',
      questionText: '¿Cuántos Mundiales ha ganado Brasil?',
      correctAnswer: '5',
      options: ['5', '4', '6', '3'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'st_009',
      type: 'statistic',
      difficulty: 'medium',
      questionText: '¿Cuántos goles tiene Messi en su carrera profesional?',
      correctAnswer: 'Más de 800',
      options: ['Más de 800', 'Más de 750', 'Más de 850', 'Más de 700'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'st_010',
      type: 'statistic',
      difficulty: 'hard',
      questionText: '¿Cuál es el récord de goles en una sola temporada de la Premier League?',
      correctAnswer: '36 (Erling Haaland, 2022-23)',
      options: ['36 (Erling Haaland, 2022-23)', '34 (Andy Cole, 1993-94)', '32 (Alan Shearer, 1995-96)', '31 (Mohamed Salah, 2017-18)'],
      imageUrl: null,
      extraData: null,
    },
  ];
}

// ════════════════════════════════════════════════════
// TRANSFERENCIAS
// ════════════════════════════════════════════════════

function transferQuestions() {
  return [
    {
      id: 'tr_001',
      type: 'transfer',
      difficulty: 'easy',
      questionText: '¿Qué club pagó 222M€ por Neymar en 2017?',
      correctAnswer: 'Paris Saint-Germain',
      options: ['Paris Saint-Germain', 'Real Madrid', 'Barcelona', 'Manchester City'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'tr_002',
      type: 'transfer',
      difficulty: 'medium',
      questionText: '¿A qué club fue Mbappé traspaso GRATIS en 2024?',
      correctAnswer: 'Real Madrid',
      options: ['Real Madrid', 'Liverpool', 'Manchester United', 'Bayern Munich'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'tr_003',
      type: 'transfer',
      difficulty: 'easy',
      questionText: '¿De qué club vino Cristiano Ronaldo al Real Madrid en 2009?',
      correctAnswer: 'Manchester United',
      options: ['Manchester United', 'Sporting de Lisboa', 'Juventus', 'Chelsea'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'tr_004',
      type: 'transfer',
      difficulty: 'medium',
      questionText: '¿Qué jugador fue traspaso del Barcelona al Real Madrid en 2000 por 60M€?',
      correctAnswer: 'Luis Figo',
      options: ['Luis Figo', 'Ronaldo Nazário', 'Michael Owen', 'David Beckham'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'tr_005',
      type: 'transfer',
      difficulty: 'hard',
      questionText: '¿Cuál fue el primer fichaje de más de 100M€ en la historia?',
      correctAnswer: 'Gareth Bale (Real Madrid, 2013)',
      options: ['Gareth Bale (Real Madrid, 2013)', 'Cristiano Ronaldo (Juventus, 2018)', 'Neymar (PSG, 2017)', 'Paul Pogba (Manchester United, 2016)'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'tr_006',
      type: 'transfer',
      difficulty: 'easy',
      questionText: '¿A qué club fue Messi en 2021 tras salir del Barcelona?',
      correctAnswer: 'Paris Saint-Germain',
      options: ['Paris Saint-Germain', 'Inter Miami', 'Manchester City', 'Juventus'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'tr_007',
      type: 'transfer',
      difficulty: 'medium',
      questionText: '¿Qué club pagó 100M€ por Eden Hazard en 2019?',
      correctAnswer: 'Real Madrid',
      options: ['Real Madrid', 'Chelsea', 'Bayern Munich', 'Barcelona'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'tr_008',
      type: 'transfer',
      difficulty: 'hard',
      questionText: '¿Cuánto pagó la Juventus por Cristiano Ronaldo en 2018?',
      correctAnswer: '100M€',
      options: ['100M€', '120M€', '80M€', '90M€'],
      imageUrl: null,
      extraData: null,
    },
    {
      id: 'tr_009',
      type: 'transfer',
      difficulty: 'medium',
      questionText: '¿Qué jugador boliviano fue fichado por el Bayern Munich?',
      correctAnswer: 'Ninguno de estos',
      options: ['Ninguno de estos', 'Marcelo Moreno', 'Juan Carlos Arce', 'Jhasmani Campos'],
      imageUrl: null,
      extraData: { trick: true },
    },
    {
      id: 'tr_010',
      type: 'transfer',
      difficulty: 'easy',
      questionText: '¿En qué club juega Haaland desde 2022?',
      correctAnswer: 'Manchester City',
      options: ['Manchester City', 'Borussia Dortmund', 'Bayern Munich', 'Liverpool'],
      imageUrl: null,
      extraData: null,
    },
  ];
}
