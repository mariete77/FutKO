import 'package:flutter/material.dart';
import 'package:fut_ko/data/models/prediction_model.dart';

class CreatePredictionScreen extends StatefulWidget {
  final String matchId;
  final String homeTeamName;
  final String awayTeamName;

  const CreatePredictionScreen({
    Key? key,
    required this.matchId,
    required this.homeTeamName,
    required this.awayTeamName,
  }) : super(key: key);

  @override
  _CreatePredictionScreenState createState() => _CreatePredictionScreenState();
}

class _CreatePredictionScreenState extends State<CreatePredictionScreen> {
  PredictionOutcome? _selectedOutcome;

  void _submitPrediction() {
    if (_selectedOutcome == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un resultado primero')),
      );
      return;
    }

    // Aquí iría la lógica para guardar en Firestore
    print('Predicción guardada: ${_selectedOutcome.toString()} para el partido ${widget.matchId}');

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predecir Resultado'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${widget.homeTeamName} vs ${widget.awayTeamName}',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildPredictionButton(
              context,
              label: '1 (Local)',
              outcome: PredictionOutcome.homeWin,
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildPredictionButton(
              context,
              label: 'X (Empate)',
              outcome: PredictionOutcome.draw,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            _buildPredictionButton(
              context,
              label: '2 (Visitante)',
              outcome: PredictionOutcome.awayWin,
              color: Colors.red,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _submitPrediction,
              child: const Text('Confirmar Predicción'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionButton(BuildContext context, {
    required String label,
    required PredictionOutcome outcome,
    required Color color,
  }) {
    final isSelected = _selectedOutcome == outcome;
    return ElevatedButton(
      onPressed: () => setState(() => _selectedOutcome = outcome),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? color : color.withOpacity(0.5),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isSelected ? const BorderSide(color: Colors.white, width: 2) : BorderSide.none,
        ),
      ),
      child: Text(label, style: const TextStyle(fontSize: 18)),
    );
  }
}
