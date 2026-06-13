import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/haptics_service.dart';
import 'audio_settings_provider.dart';

/// Estado on/off de la vibración háptica, persistido vía [HapticsService].
final hapticsEnabledProvider =
    StateNotifierProvider<HapticsNotifier, bool>((ref) {
  return HapticsNotifier();
});

class HapticsNotifier extends BoolSettingNotifier {
  HapticsNotifier() : super(true) {
    _init();
  }

  Future<void> _init() async {
    await HapticsService().initialize();
    state = HapticsService().enabled;
  }

  @override
  Future<void> toggle() async {
    state = !state;
    await HapticsService().setEnabled(state);
  }

  @override
  Future<void> set(bool value) async {
    state = value;
    await HapticsService().setEnabled(value);
  }
}
