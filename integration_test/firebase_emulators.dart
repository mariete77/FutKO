import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> initializeFirebaseEmulators() async {
  await Firebase.initializeApp();

  FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
}

Future<UserCredential> createTestUser({
  String email = 'test@futko.app',
  String password = 'test1234',
}) async {
  try {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      return await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
    rethrow;
  }
}

Future<void> seedTestQuestions() async {
  final firestore = FirebaseFirestore.instance;
  final questions = [
    {
      'type': 'player',
      'difficulty': 'easy',
      'questionText': '¿Quién ganó el Balón de Oro 2023?',
      'correctAnswer': 'Lionel Messi',
      'options': ['Lionel Messi', 'Cristiano Ronaldo', 'Kylian Mbappé', 'Erling Haaland'],
      'imageUrl': '',
      'extraData': {},
    },
    {
      'type': 'team',
      'difficulty': 'easy',
      'questionText': '¿Qué equipo ganó la Champions League 2023?',
      'correctAnswer': 'Manchester City',
      'options': ['Manchester City', 'Real Madrid', 'Inter Milan', 'Bayern Munich'],
      'imageUrl': '',
      'extraData': {},
    },
    {
      'type': 'stadium',
      'difficulty': 'medium',
      'questionText': '¿En qué estadio juega el FC Barcelona?',
      'correctAnswer': 'Spotify Camp Nou',
      'options': ['Spotify Camp Nou', 'Santiago Bernabéu', 'Wanda Metropolitano', 'San Mamés'],
      'imageUrl': '',
      'extraData': {},
    },
    {
      'type': 'competition',
      'difficulty': 'easy',
      'questionText': '¿Cuántos equipos juegan en La Liga?',
      'correctAnswer': '20',
      'options': ['20', '18', '22', '16'],
      'imageUrl': '',
      'extraData': {},
    },
    {
      'type': 'history',
      'difficulty': 'medium',
      'questionText': '¿En qué año se fundó la FIFA?',
      'correctAnswer': '1904',
      'options': ['1904', '1920', '1898', '1910'],
      'imageUrl': '',
      'extraData': {},
    },
    {
      'type': 'rules',
      'difficulty': 'easy',
      'questionText': '¿Cuántos jugadores hay en cada equipo?',
      'correctAnswer': '11',
      'options': ['11', '10', '12', '9'],
      'imageUrl': '',
      'extraData': {},
    },
    {
      'type': 'badge',
      'difficulty': 'hard',
      'questionText': '¿Qué equipo tiene este escudo?',
      'correctAnswer': 'Liverpool FC',
      'options': ['Liverpool FC', 'Manchester United', 'Arsenal', 'Chelsea'],
      'imageUrl': '',
      'extraData': {},
    },
    {
      'type': 'playerImage',
      'difficulty': 'medium',
      'questionText': '¿Quién es este jugador?',
      'correctAnswer': 'Kylian Mbappé',
      'options': ['Kylian Mbappé', 'Erling Haaland', 'Jude Bellingham', 'Vinícius Jr'],
      'imageUrl': '',
      'extraData': {},
    },
    {
      'type': 'statistic',
      'difficulty': 'hard',
      'questionText': '¿Quién es el máximo goleador de la historia del Real Madrid?',
      'correctAnswer': 'Cristiano Ronaldo',
      'options': ['Cristiano Ronaldo', 'Raúl González', 'Karim Benzema', 'Alfredo Di Stéfano'],
      'imageUrl': '',
      'extraData': {},
    },
    {
      'type': 'transfer',
      'difficulty': 'medium',
      'questionText': '¿Cuánto pagó el PSG por Neymar en 2017?',
      'correctAnswer': '222 millones',
      'options': ['222 millones', '180 millones', '250 millones', '200 millones'],
      'imageUrl': '',
      'extraData': {},
    },
  ];

  final batch = firestore.batch();
  for (final q in questions) {
    final docRef = firestore.collection('questions').doc();
    batch.set(docRef, q);
  }
  await batch.commit();
}

Future<void> clearEmulatorData() async {
  try {
    await FirebaseFirestore.instance.clearPersistence();
  } catch (_) {}
}
