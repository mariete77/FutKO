import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Game sound types
enum GameSound {
  goal,       // ⚽ Gol - acierto correcto
  redCard,    // 🔴 Tarjeta roja - fallo
  countdown,  // ⏱️ Countdown - últimos 3 segundos
  victory,    // 🏆 Victoria - ganó partida
  defeat,     // ☠️ Derrota - perdió partida
}

/// Audio service singleton para manejo de sonidos del juego.
/// Usa URLs de CDN de Mixkit (gratuitas, CC0).
class AudioService {
  static final AudioService _instance = AudioService._internal();

  factory AudioService() {
    return _instance;
  }

  AudioService._internal();

  // Canales de audio independientes
  final Map<GameSound, AudioPlayer> _players = {};

  bool _sfxEnabled = true;
  bool _musicEnabled = true;

  // URLs de Mixkit (CDN gratuito, licencia CC0)
  static const Map<GameSound, String> _soundUrls = {
    GameSound.goal: 'https://cdn.pixabay.com/download/audio/2021/08/04/audio_bb92d70826.mp3', // Goal cheer
    GameSound.redCard: 'https://cdn.pixabay.com/download/audio/2021/08/27/audio_55f63b17cb.mp3', // Buzzer
    GameSound.countdown: 'https://cdn.pixabay.com/download/audio/2021/06/12/audio_d1c3b78c96.mp3', // Beep
    GameSound.victory: 'https://cdn.pixabay.com/download/audio/2022/09/01/audio_01a7a5f2d7.mp3', // Fanfare
    GameSound.defeat: 'https://cdn.pixabay.com/download/audio/2021/07/07/audio_5851f99f43.mp3', // Sad trombone
  };

  /// Inicializar el servicio, cargar settings de audio desde SharedPreferences
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _sfxEnabled = prefs.getBool('audio_sfx_enabled') ?? true;
    _musicEnabled = prefs.getBool('audio_music_enabled') ?? true;
  }

  /// Reproducir un sonido de juego
  Future<void> play(GameSound sound) async {
    if (!_sfxEnabled && sound != GameSound.goal && sound != GameSound.defeat) {
      return; // Silenciar SFX si está deshabilitado (except goal/defeat)
    }

    try {
      final player = _players[sound] ?? AudioPlayer();
      _players[sound] = player;

      await player.play(
        UrlSource(_soundUrls[sound]!),
        volume: _getVolumeForSound(sound),
      );
    } catch (e) {
      // Fallar silenciosamente — CDN puede no estar disponible
      // print('Error playing sound: $e');
    }
  }

  /// Reproducir countdown (beep de 3 segundos)
  Future<void> playCountdown() async {
    if (!_sfxEnabled) return;
    await play(GameSound.countdown);
  }

  /// Reproducir sonido de gol (respuesta correcta)
  Future<void> playGoal() async {
    await play(GameSound.goal);
  }

  /// Reproducir sonido de tarjeta roja (respuesta incorrecta)
  Future<void> playRedCard() async {
    await play(GameSound.redCard);
  }

  /// Reproducir fanfare de victoria
  Future<void> playVictory() async {
    await play(GameSound.victory);
  }

  /// Reproducir sonido de derrota
  Future<void> playDefeat() async {
    await play(GameSound.defeat);
  }

  /// Obtener volumen dinámico por tipo de sonido
  double _getVolumeForSound(GameSound sound) {
    switch (sound) {
      case GameSound.goal:
        return 0.8;
      case GameSound.redCard:
        return 0.6;
      case GameSound.countdown:
        return 0.5;
      case GameSound.victory:
        return 0.9;
      case GameSound.defeat:
        return 0.7;
    }
  }

  /// Cambiar estado de SFX
  Future<void> setSfxEnabled(bool enabled) async {
    _sfxEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('audio_sfx_enabled', enabled);
  }

  /// Cambiar estado de música
  Future<void> setMusicEnabled(bool enabled) async {
    _musicEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('audio_music_enabled', enabled);
  }

  /// Obtener estado actual
  bool get sfxEnabled => _sfxEnabled;
  bool get musicEnabled => _musicEnabled;

  /// Detener todos los sonidos
  Future<void> stopAll() async {
    for (var player in _players.values) {
      await player.stop();
    }
  }

  /// Limpiar recursos
  Future<void> dispose() async {
    await stopAll();
    for (var player in _players.values) {
      await player.dispose();
    }
    _players.clear();
  }
}
