import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/audio_service.dart';

/// Base for simple on/off settings backed by a service. Exposes [set]/[toggle]
/// so shared UI (the settings switches) can drive any of them through a single
/// provider type.
abstract class BoolSettingNotifier extends StateNotifier<bool> {
  BoolSettingNotifier(super.state);

  Future<void> set(bool value);
  Future<void> toggle();
}

/// Audio SFX enabled state
final audioSfxEnabledProvider =
    StateNotifierProvider<AudioSfxNotifier, bool>((ref) {
  return AudioSfxNotifier();
});

/// Audio music enabled state
final audioMusicEnabledProvider =
    StateNotifierProvider<AudioMusicNotifier, bool>((ref) {
  return AudioMusicNotifier();
});

class AudioSfxNotifier extends BoolSettingNotifier {
  AudioSfxNotifier() : super(true) {
    _init();
  }

  Future<void> _init() async {
    await AudioService().initialize();
    state = AudioService().sfxEnabled;
  }

  @override
  Future<void> toggle() async {
    state = !state;
    await AudioService().setSfxEnabled(state);
  }

  @override
  Future<void> set(bool value) async {
    state = value;
    await AudioService().setSfxEnabled(value);
  }
}

class AudioMusicNotifier extends BoolSettingNotifier {
  AudioMusicNotifier() : super(true) {
    _init();
  }

  Future<void> _init() async {
    await AudioService().initialize();
    state = AudioService().musicEnabled;
  }

  @override
  Future<void> toggle() async {
    state = !state;
    await AudioService().setMusicEnabled(state);
  }

  @override
  Future<void> set(bool value) async {
    state = value;
    await AudioService().setMusicEnabled(value);
  }
}
