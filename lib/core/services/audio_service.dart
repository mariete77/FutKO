import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Audio service for playing sound effects and music
/// Uses audioplayers package for cross-platform audio
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer();
  
  bool _isInitialized = false;
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  double _sfxVolume = 1.0;
  double _musicVolume = 0.5;

  /// Initialize the audio service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Set audio contexts for different platforms
      await _sfxPlayer.setReleaseMode(ReleaseMode.release);
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      
      // Set initial volumes
      await _sfxPlayer.setVolume(_sfxVolume);
      await _musicPlayer.setVolume(_musicVolume);

      _isInitialized = true;
      debugPrint('AudioService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing AudioService: $e');
    }
  }

  /// Play a sound effect
  Future<void> playSfx(String soundPath) async {
    if (!_isInitialized || !_soundEnabled) return;

    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource(soundPath));
    } catch (e) {
      debugPrint('Error playing SFX: $e');
    }
  }

  /// Play background music
  Future<void> playMusic(String musicPath) async {
    if (!_isInitialized || !_musicEnabled) return;

    try {
      await _musicPlayer.stop();
      await _musicPlayer.play(AssetSource(musicPath));
    } catch (e) {
      debugPrint('Error playing music: $e');
    }
  }

  /// Stop background music
  Future<void> stopMusic() async {
    try {
      await _musicPlayer.stop();
    } catch (e) {
      debugPrint('Error stopping music: $e');
    }
  }

  /// Pause background music
  Future<void> pauseMusic() async {
    try {
      await _musicPlayer.pause();
    } catch (e) {
      debugPrint('Error pausing music: $e');
    }
  }

  /// Resume background music
  Future<void> resumeMusic() async {
    if (!_musicEnabled) return;
    try {
      await _musicPlayer.resume();
    } catch (e) {
      debugPrint('Error resuming music: $e');
    }
  }

  /// Play achievement unlock sound
  Future<void> playAchievementUnlocked() async {
    await playSfx('audio/achievement_unlocked.mp3');
  }

  /// Play correct answer sound
  Future<void> playCorrectAnswer() async {
    await playSfx('audio/correct_answer.mp3');
  }

  /// Play wrong answer sound
  Future<void> playWrongAnswer() async {
    await playSfx('audio/wrong_answer.mp3');
  }

  /// Play victory sound
  Future<void> playVictory() async {
    await playSfx('audio/victory.mp3');
  }

  /// Play defeat sound
  Future<void> playDefeat() async {
    await playSfx('audio/defeat.mp3');
  }

  /// Play streak milestone sound (3, 5, 10)
  Future<void> playStreakMilestone() async {
    await playSfx('audio/streak_milestone.mp3');
  }

  /// Play button click sound
  Future<void> playButtonClick() async {
    await playSfx('audio/button_click.mp3');
  }

  /// Play timer warning sound (last 5 seconds)
  Future<void> playTimerWarning() async {
    await playSfx('audio/timer_warning.mp3');
  }

  /// Play level up sound
  Future<void> playLevelUp() async {
    await playSfx('audio/level_up.mp3');
  }

  /// Set sound effects volume (0.0 to 1.0)
  Future<void> setSfxVolume(double volume) async {
    _sfxVolume = volume.clamp(0.0, 1.0);
    await _sfxPlayer.setVolume(_sfxVolume);
  }

  /// Set music volume (0.0 to 1.0)
  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 1.0);
    await _musicPlayer.setVolume(_musicVolume);
  }

  /// Toggle sound effects on/off
  void toggleSound(bool enabled) {
    _soundEnabled = enabled;
  }

  /// Toggle music on/off
  Future<void> toggleMusic(bool enabled) async {
    _musicEnabled = enabled;
    if (!enabled) {
      await stopMusic();
    }
  }

  /// Get current settings
  bool get isSoundEnabled => _soundEnabled;
  bool get isMusicEnabled => _musicEnabled;
  double get sfxVolume => _sfxVolume;
  double get musicVolume => _musicVolume;

  /// Dispose audio players
  Future<void> dispose() async {
    await _sfxPlayer.dispose();
    await _musicPlayer.dispose();
  }
}

/// Global instance for easy access
final audioService = AudioService();
