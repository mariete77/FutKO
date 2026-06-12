import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/audio_service.dart';

/// Audio SFX enabled state
final audioSfxEnabledProvider = StateNotifierProvider<AudioSfxNotifier, bool>((ref) {
  return AudioSfxNotifier();
});

/// Audio music enabled state
final audioMusicEnabledProvider = StateNotifierProvider<AudioMusicNotifier, bool>((ref) {
  return AudioMusicNotifier();
});

class AudioSfxNotifier extends StateNotifier<bool> {
  AudioSfxNotifier() : super(true) {
    _init();
  }

  Future<void> _init() async {
    await AudioService().initialize();
    state = AudioService().sfxEnabled;
  }

  Future<void> toggle() async {
    state = !state;
    await AudioService().setSfxEnabled(state);
  }

  Future<void> set(bool value) async {
    state = value;
    await AudioService().setSfxEnabled(value);
  }
}

class AudioMusicNotifier extends StateNotifier<bool> {
  AudioMusicNotifier() : super(true) {
    _init();
  }

  Future<void> _init() async {
    await AudioService().initialize();
    state = AudioService().musicEnabled;
  }

  Future<void> toggle() async {
    state = !state;
    await AudioService().setMusicEnabled(state);
  }

  Future<void> set(bool value) async {
    state = value;
    await AudioService().setMusicEnabled(value);
  }
}
