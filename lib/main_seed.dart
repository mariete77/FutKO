import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:futko/services/question_seeder_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: SeederApp()));
}

class SeederApp extends StatelessWidget {
  const SeederApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FutKO - Seed',
      theme: ThemeData.dark(),
      home: const SeedScreen(),
    );
  }
}

class SeedScreen extends StatefulWidget {
  const SeedScreen({super.key});

  @override
  State<SeedScreen> createState() => SeedScreenState();
}

class SeedScreenState extends State<SeedScreen> {
  String _status = 'Listo para sembrar preguntas';
  int _count = 0;
  bool _loading = false;

  Future<void> _seedQuestions() async {
    setState(() {
      _loading = true;
      _status = 'Sembrando preguntas...';
    });

    try {
      final seeder = QuestionSeederService();
      final count = await seeder.seedQuestions();
      setState(() {
        _count = count;
        _status = '✅ Se sembraron $count preguntas correctamente';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FutKO - Seeder')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Football Quiz Seed',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Text(_status, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              if (_count > 0)
                Text(
                  '$_count preguntas en Firestore',
                  style: const TextStyle(fontSize: 18, color: Colors.green),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loading ? null : _seedQuestions,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Sembrar Preguntas', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
